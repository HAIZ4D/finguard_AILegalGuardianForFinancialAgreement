export interface DebateTurn {
  speaker: "defender" | "protector";
  message: string;
}

export interface DebateAudioRequest {
  analysis_id: string;
  debate_transcript: DebateTurn[];
}

export interface DebateAudioTimingSegment {
  index: number;
  speaker: string;
  startMs: number;
  endMs: number;
}

export interface DebateAudioResponse {
  audioUrl: string;
  audioBase64: string; // data:audio/wav;base64,... — served directly to avoid CORS
  wavBuffer: Buffer;   // raw bytes for callers that need the buffer
  timings: DebateAudioTimingSegment[];
  durationMs: number;
}
