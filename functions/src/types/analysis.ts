import {DebateTurn} from "./debate";

export interface ExtractedClauses {
  interest_rate: string;
  late_fee: string;
  early_settlement_penalty: string;
  liability_type: string;
  repossession_clause: string;
  loan_amount?: string;
  loan_tenure?: string;
  interest_model?: string;
  compounding_frequency?: string;
  guarantor_liability?: string;
  insurance_requirement?: string;
  balloon_payment?: string;
}

export interface NarrativeSimulation {
  one_missed_payment: string;
  three_missed_payments: string;
  full_default: string;
}

export interface GeminiResponse {
  agreement_type: string;
  extracted_clauses: ExtractedClauses;
  defender_analysis: string;
  protector_analysis: string;
  narrative_simulation: NarrativeSimulation;
  detected_risks: string[];
  plain_language_summary: string;
  debate_transcript?: DebateTurn[];
}

export interface RiskScores {
  legal_risk_score: number;
  financial_burden_score: number;
  poverty_vulnerability_score: number;
  overall_risk_score: number;
  risk_level: "Low" | "Medium" | "High";
}

export interface AnalysisResult {
  id?: string;
  agreement_type: string;
  extracted_clauses: ExtractedClauses;
  defender_analysis: string;
  protector_analysis: string;
  narrative_simulation: NarrativeSimulation;
  detected_risks: string[];
  plain_language_summary: string;
  risk_scores: RiskScores;
  debate_transcript?: DebateTurn[];
  timestamp: FirebaseFirestore.Timestamp | Date;
  input_method: "text" | "pdf";
}

export interface AnalyzeRequest {
  contract_text?: string;
  file_path?: string;
  pdf_bytes_base64?: string;
  agreement_type?: string;
}
