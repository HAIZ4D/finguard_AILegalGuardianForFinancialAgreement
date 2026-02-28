export interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

export interface AgreementContext {
  agreement_type: string;
  extracted_clauses: Record<string, string>;
  plain_language_summary: string;
  detected_risks: string[];
  defender_analysis: string;
  protector_analysis: string;
  narrative_simulation: {
    one_missed_payment: string;
    three_missed_payments: string;
    full_default: string;
  };
  risk_scores: {
    legal_risk_score: number;
    financial_burden_score: number;
    poverty_vulnerability_score: number;
    overall_risk_score: number;
    risk_level: string;
  };
}

export interface ChatRequest {
  user_message: string;
  conversation_history: ChatMessage[];
  agreement_context: AgreementContext;
}
