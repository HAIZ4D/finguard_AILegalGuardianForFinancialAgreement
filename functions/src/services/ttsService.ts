import {TextToSpeechClient, protos} from "@google-cloud/text-to-speech";
import * as admin from "firebase-admin";
import {
  DebateTurn,
  DebateAudioTimingSegment,
  DebateAudioResponse,
} from "../types/debate";

const SAMPLE_RATE = 24000;
const BYTES_PER_SAMPLE = 2; // 16-bit PCM

type AudioEncoding =
  protos.google.cloud.texttospeech.v1.AudioEncoding;

/**
 * Parses a LINEAR16 TTS response buffer and extracts only the raw PCM bytes,
 * stripping the WAV header (which Google TTS includes in LINEAR16 responses).
 */
function extractPcmFromWav(buf: Buffer): Buffer {
  // Walk the RIFF chunk list to find the "data" subchunk
  let offset = 12; // Skip "RIFF" (4) + ChunkSize (4) + "WAVE" (4)
  while (offset < buf.length - 8) {
    const chunkId = buf.toString("ascii", offset, offset + 4);
    const chunkSize = buf.readUInt32LE(offset + 4);
    if (chunkId === "data") {
      return buf.slice(offset + 8); // Skip "data" (4) + size field (4)
    }
    offset += 8 + chunkSize;
  }
  // Fallback: standard 44-byte WAV header
  return buf.slice(44);
}

/**
 * Builds a minimal WAV file header for LINEAR16 mono audio at SAMPLE_RATE Hz.
 */
function buildWavHeader(pcmLength: number): Buffer {
  const byteRate = SAMPLE_RATE * 1 * BYTES_PER_SAMPLE; // 48000
  const blockAlign = 1 * BYTES_PER_SAMPLE; // 2

  const header = Buffer.alloc(44);
  header.write("RIFF", 0, "ascii");
  header.writeUInt32LE(36 + pcmLength, 4); // ChunkSize
  header.write("WAVE", 8, "ascii");
  header.write("fmt ", 12, "ascii");
  header.writeUInt32LE(16, 16); // Subchunk1Size (PCM = 16)
  header.writeUInt16LE(1, 20); // AudioFormat  (PCM = 1)
  header.writeUInt16LE(1, 22); // NumChannels  (mono)
  header.writeUInt32LE(SAMPLE_RATE, 24); // SampleRate
  header.writeUInt32LE(byteRate, 28); // ByteRate
  header.writeUInt16LE(blockAlign, 32); // BlockAlign
  header.writeUInt16LE(16, 34); // BitsPerSample
  header.write("data", 36, "ascii");
  header.writeUInt32LE(pcmLength, 40); // Subchunk2Size

  return header;
}

function pcmBytesToMs(bytes: number): number {
  return Math.round((bytes / BYTES_PER_SAMPLE / SAMPLE_RATE) * 1000);
}

/**
 * Synthesises each debate turn using Google Cloud TTS (Neural2 voices),
 * concatenates the PCM audio into a single WAV file, uploads it to
 * Cloud Storage, and returns the public URL plus per-turn timing data.
 */
export async function generateDebateAudio(
  analysisId: string,
  turns: DebateTurn[],
): Promise<DebateAudioResponse> {
  const tts = new TextToSpeechClient();

  // Synthesise all turns in parallel for speed
  const rawBuffers = await Promise.all(
    turns.map(async (turn) => {
      const [response] = await tts.synthesizeSpeech({
        input: {text: turn.message},
        voice: {
          languageCode: "en-US",
          // Defender: authoritative male  |  Protector: empathetic female
          name: turn.speaker === "defender" ?
            "en-US-Neural2-D" :
            "en-US-Neural2-F",
        },
        audioConfig: {
          audioEncoding: "LINEAR16" as unknown as AudioEncoding,
          sampleRateHertz: SAMPLE_RATE,
        },
      });
      return Buffer.from(response.audioContent as Uint8Array);
    }),
  );

  // Strip WAV headers — keep only raw PCM bytes
  const pcmBuffers = rawBuffers.map(extractPcmFromWav);

  // Compute per-turn timing from cumulative PCM byte offsets
  const timings: DebateAudioTimingSegment[] = [];
  let cumulativeBytes = 0;
  for (let i = 0; i < pcmBuffers.length; i++) {
    const startMs = pcmBytesToMs(cumulativeBytes);
    cumulativeBytes += pcmBuffers[i].length;
    const endMs = pcmBytesToMs(cumulativeBytes);
    timings.push({index: i, speaker: turns[i].speaker, startMs, endMs});
  }
  const durationMs = pcmBytesToMs(cumulativeBytes);

  // Build final WAV = new header + concatenated PCM
  const wavHeader = buildWavHeader(cumulativeBytes);
  const wavBuffer = Buffer.concat([wavHeader, ...pcmBuffers]);

  // Upload to default Firebase Storage bucket (for caching / idempotency)
  const bucket = admin.storage().bucket();
  const fileName = `debate_audio/${analysisId}.wav`;
  const file = bucket.file(fileName);

  await file.save(wavBuffer, {metadata: {contentType: "audio/wav"}});
  await file.makePublic();

  const audioUrl =
    `https://storage.googleapis.com/${bucket.name}/${fileName}`;

  // Encode WAV as a data URL so the browser can play it without CORS
  const audioBase64 =
    `data:audio/wav;base64,${wavBuffer.toString("base64")}`;

  return {audioUrl, audioBase64, wavBuffer, timings, durationMs};
}
