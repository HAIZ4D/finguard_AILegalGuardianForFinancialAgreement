import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {analyzeWithGemini, chatWithGemini} from "./services/geminiService";
import {calculateRiskScores} from "./services/riskEngine";
import {generateDebateAudio as ttsGenerateDebateAudio} from "./services/ttsService";
import {AnalyzeRequest, AnalysisResult} from "./types/analysis";
import {ChatRequest} from "./types/chat";
import {DebateAudioRequest} from "./types/debate";

admin.initializeApp();

const db = admin.firestore();

// ─── GET HISTORY ────────────────────────────────────────────────────────────
export const getHistory = onRequest(
  {
    cors: true,
    region: "us-central1",
  },
  async (req, res) => {
    if (req.method !== "GET") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const limit = Math.min(
        parseInt(req.query.limit as string) || 20,
        50,
      );

      const snapshot = await db
        .collection("analyses")
        .orderBy("timestamp", "desc")
        .limit(limit)
        .get();

      const analyses = snapshot.docs.map((doc) => {
        const data = doc.data() as Omit<AnalysisResult, "id">;
        return {
          id: doc.id,
          data: {
            agreement_type: data.agreement_type,
            extracted_clauses: data.extracted_clauses,
            defender_analysis: data.defender_analysis,
            protector_analysis: data.protector_analysis,
            narrative_simulation: data.narrative_simulation,
            detected_risks: data.detected_risks,
            plain_language_summary: data.plain_language_summary,
            risk_scores: data.risk_scores,
            user_decision: (data as Record<string, unknown>).user_decision ?? null,
            debate_transcript: (data as Record<string, unknown>).debate_transcript ?? null,
          },
        };
      });

      res.status(200).json({success: true, analyses});
    } catch (error: unknown) {
      const message = error instanceof Error ?
        error.message : "Unknown error";
      console.error("History fetch error:", message);
      res.status(500).json({error: "Failed to fetch history", message});
    }
  },
);

// ─── LOG DECISION (Behavioral Impact Tracker) ──────────────────────────────
export const logDecision = onRequest(
  {
    cors: true,
    region: "us-central1",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {analysis_id, decision, risk_score, timestamp} = req.body;

      if (!decision) {
        res.status(400).json({error: "Missing decision field"});
        return;
      }

      await db.collection("decisions").add({
        analysis_id: analysis_id || "",
        decision,
        risk_score: risk_score ?? 0,
        timestamp: timestamp || new Date().toISOString(),
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Also store decision on the analysis document for history display
      if (analysis_id) {
        await db.collection("analyses").doc(analysis_id).update({
          user_decision: decision,
        }).catch(() => {/* ignore if doc doesn't exist */});
      }

      res.status(200).json({success: true});
    } catch (error: unknown) {
      const message = error instanceof Error ?
        error.message : "Unknown error";
      console.error("Log decision error:", message);
      res.status(500).json({error: "Failed to log decision", message});
    }
  },
);

// ─── ANALYZE CONTRACT ───────────────────────────────────────────────────────
export const analyzeContract = onRequest(
  {
    cors: true,
    region: "us-central1",
    timeoutSeconds: 120,
    memory: "512MiB",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {contract_text, file_path, pdf_bytes_base64, agreement_type} =
        req.body as AnalyzeRequest;

      let textToAnalyze = contract_text || "";

      // If PDF bytes sent directly as base64 (preferred — no Storage upload needed)
      if (pdf_bytes_base64 && !contract_text) {
        const pdfBuffer = Buffer.from(pdf_bytes_base64, "base64");
        const pdfParse = (await import("pdf-parse")).default;
        const pdfData = await pdfParse(pdfBuffer);
        textToAnalyze = pdfData.text;
      } else if (file_path && !contract_text) {
        // Legacy: If PDF file path provided, extract text from Cloud Storage
        const bucket = admin.storage().bucket();
        const file = bucket.file(file_path);
        const [buffer] = await file.download();
        const pdfParse = (await import("pdf-parse")).default;
        const pdfData = await pdfParse(buffer);
        textToAnalyze = pdfData.text;
      }

      if (!textToAnalyze.trim()) {
        res.status(400).json({error: "No contract text provided"});
        return;
      }

      // Get project ID from environment
      const projectId = process.env.GCLOUD_PROJECT ||
        process.env.GCP_PROJECT || "";

      // Step 1: AI Analysis — single Gemini call activates all 4 agents
      const geminiResult = await analyzeWithGemini(
        projectId,
        textToAnalyze,
        agreement_type,
      );

      // Step 2: Deterministic Risk Scoring — rule-based, NOT AI
      const riskScores = calculateRiskScores(
        geminiResult.extracted_clauses,
        geminiResult.agreement_type,
      );

      // Step 3: Combine AI analysis + deterministic scores
      const analysisResult: Omit<AnalysisResult, "id"> = {
        ...geminiResult,
        risk_scores: riskScores,
        timestamp: admin.firestore.FieldValue.serverTimestamp() as
          unknown as FirebaseFirestore.Timestamp,
        input_method: (file_path || pdf_bytes_base64) ? "pdf" : "text",
      };

      // Step 4: Save to Firestore
      const docRef = await db.collection("analyses").add(analysisResult);

      // Step 5: Return structured JSON to frontend
      res.status(200).json({
        success: true,
        id: docRef.id,
        data: {
          ...geminiResult,
          risk_scores: riskScores,
        },
      });
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Unknown error";
      console.error("Analysis error:", message);
      res.status(500).json({
        error: "Analysis failed",
        message: message,
      });
    }
  },
);

// ─── CHAT WITH AGREEMENT ──────────────────────────────────────────────────────
export const chatWithAgreement = onRequest(
  {
    cors: true,
    region: "us-central1",
    timeoutSeconds: 60,
    memory: "256MiB",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {
        user_message,
        conversation_history,
        agreement_context,
      } = req.body as ChatRequest;

      if (!user_message?.trim()) {
        res.status(400).json({error: "Missing user_message"});
        return;
      }

      if (!agreement_context?.agreement_type) {
        res.status(400).json({error: "Missing agreement_context"});
        return;
      }

      const projectId =
        process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT || "";

      const reply = await chatWithGemini(projectId, {
        user_message: user_message.trim(),
        conversation_history: conversation_history || [],
        agreement_context,
      });

      res.status(200).json({success: true, reply});
    } catch (error: unknown) {
      const message =
        error instanceof Error ? error.message : "Unknown error";
      console.error("Chat error:", message);
      res.status(500).json({error: "Chat failed", message});
    }
  },
);

// ─── GENERATE DEBATE AUDIO ───────────────────────────────────────────────────
export const generateDebateAudio = onRequest(
  {
    cors: true,
    region: "us-central1",
    timeoutSeconds: 180,
    memory: "512MiB",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {analysis_id, debate_transcript} = req.body as DebateAudioRequest;

      if (!analysis_id) {
        res.status(400).json({error: "Missing analysis_id"});
        return;
      }
      if (!Array.isArray(debate_transcript) || debate_transcript.length === 0) {
        res.status(400).json({error: "Missing or empty debate_transcript"});
        return;
      }

      // Check Firestore cache to avoid re-generating
      const docRef = db.collection("analyses").doc(analysis_id);
      const doc = await docRef.get();
      if (doc.exists) {
        const cached = doc.data();
        if (cached?.audioUrl) {
          // Re-download from Storage and return as base64 to bypass CORS
          try {
            const bucket = admin.storage().bucket();
            const fileName = `debate_audio/${analysis_id}.wav`;
            const [wavBuf] = await bucket.file(fileName).download();
            const audioBase64 =
              `data:audio/wav;base64,${wavBuf.toString("base64")}`;
            res.status(200).json({
              success: true,
              audioBase64,
              timings: cached.audioTimings || [],
              durationMs: cached.audioDurationMs || 0,
            });
            return;
          } catch {
            // File missing from Storage — fall through to regenerate
          }
        }
      }

      // Generate TTS audio and merge into single WAV
      const audioResult = await ttsGenerateDebateAudio(
        analysis_id,
        debate_transcript,
      );

      // Cache metadata in Firestore (not the base64 blob)
      await docRef.update({
        audioUrl: audioResult.audioUrl,
        audioTimings: audioResult.timings,
        audioDurationMs: audioResult.durationMs,
      }).catch(() => {/* ignore if doc not found */});

      res.status(200).json({
        success: true,
        audioBase64: audioResult.audioBase64,
        timings: audioResult.timings,
        durationMs: audioResult.durationMs,
      });
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Unknown error";
      console.error("Debate audio error:", message);
      res.status(500).json({error: "Audio generation failed", message});
    }
  },
);
