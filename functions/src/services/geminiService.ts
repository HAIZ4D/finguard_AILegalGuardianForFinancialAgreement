import {VertexAI} from "@google-cloud/vertexai";
import {buildContractPrompt} from "../prompts/contractPrompt";
import {buildChatSystemPrompt} from "../prompts/chatPrompt";
import {GeminiResponse} from "../types/analysis";
import {ChatRequest} from "../types/chat";

const LOCATION = "us-central1";
const MODEL = "gemini-2.0-flash-001";

export async function analyzeWithGemini(
  projectId: string,
  contractText: string,
  agreementType?: string,
): Promise<GeminiResponse> {
  const vertexAI = new VertexAI({
    project: projectId,
    location: LOCATION,
  });

  const model = vertexAI.getGenerativeModel({
    model: MODEL,
    generationConfig: {
      responseMimeType: "application/json",
      temperature: 0.2,
      maxOutputTokens: 8192,
    },
  });

  const prompt = buildContractPrompt(contractText, agreementType);

  const result = await model.generateContent({
    contents: [{role: "user", parts: [{text: prompt}]}],
  });

  const response = result.response;
  const candidate = response?.candidates?.[0];
  const text = candidate?.content?.parts?.[0]?.text;

  // Log finish reason — "MAX_TOKENS" means response was truncated
  const finishReason = (candidate as unknown as {finishReason?: string})?.finishReason;
  console.log("[Gemini] finishReason:", finishReason, "textLen:", text?.length ?? 0);

  if (!text) {
    throw new Error("Gemini returned empty response");
  }

  // Clean potential markdown code fences from response
  let cleanText = text.trim();
  if (cleanText.startsWith("```json")) {
    cleanText = cleanText.slice(7);
  } else if (cleanText.startsWith("```")) {
    cleanText = cleanText.slice(3);
  }
  if (cleanText.endsWith("```")) {
    cleanText = cleanText.slice(0, -3);
  }
  cleanText = cleanText.trim();

  let parsed: GeminiResponse;
  try {
    parsed = JSON.parse(cleanText) as GeminiResponse;
  } catch {
    throw new Error("Gemini response is not valid JSON: " + cleanText.substring(0, 200));
  }

  if (
    !parsed.agreement_type ||
    !parsed.extracted_clauses ||
    !parsed.narrative_simulation
  ) {
    throw new Error("Gemini response missing required fields");
  }

  // Sanitise optional debate_transcript — must be array if present
  if (parsed.debate_transcript && !Array.isArray(parsed.debate_transcript)) {
    parsed.debate_transcript = undefined;
  }

  // Debug: log debate_transcript presence so we can diagnose missing data
  console.log(
    "[Gemini] debate_transcript present:",
    !!parsed.debate_transcript,
    "turns:",
    parsed.debate_transcript?.length ?? 0,
  );

  return parsed;
}

export async function chatWithGemini(
  projectId: string,
  request: ChatRequest,
): Promise<string> {
  const vertexAI = new VertexAI({
    project: projectId,
    location: LOCATION,
  });

  const systemPrompt = buildChatSystemPrompt(request.agreement_context);

  const model = vertexAI.getGenerativeModel({
    model: MODEL,
    systemInstruction: systemPrompt,
    generationConfig: {
      responseMimeType: "text/plain",
      temperature: 0.3,
      maxOutputTokens: 1024,
    },
  });

  // Build conversation: history + current message
  const contents: Array<{role: string; parts: Array<{text: string}>}> = [];

  // Add recent history (cap at 10 messages to stay within token limits)
  const recentHistory = request.conversation_history.slice(-10);
  for (const msg of recentHistory) {
    contents.push({
      role: msg.role === "user" ? "user" : "model",
      parts: [{text: msg.content}],
    });
  }

  // Add current user message
  contents.push({
    role: "user",
    parts: [{text: request.user_message}],
  });

  const result = await model.generateContent({contents});

  const response = result.response;
  const text = response?.candidates?.[0]?.content?.parts?.[0]?.text;

  if (!text) {
    throw new Error("Gemini returned empty response");
  }

  return text.trim();
}
