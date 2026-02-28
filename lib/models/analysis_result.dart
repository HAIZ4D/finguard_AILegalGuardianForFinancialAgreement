class DebateTurn {
  final String speaker;
  final String message;

  DebateTurn({required this.speaker, required this.message});

  factory DebateTurn.fromJson(Map<String, dynamic> json) {
    return DebateTurn(
      speaker: json['speaker'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

class ExtractedClauses {
  final String interestRate;
  final String lateFee;
  final String earlySettlementPenalty;
  final String liabilityType;
  final String repossessionClause;
  final String? loanAmount;
  final String? loanTenure;
  final String? interestModel;
  final String? compoundingFrequency;
  final String? guarantorLiability;
  final String? insuranceRequirement;
  final String? balloonPayment;

  ExtractedClauses({
    required this.interestRate,
    required this.lateFee,
    required this.earlySettlementPenalty,
    required this.liabilityType,
    required this.repossessionClause,
    this.loanAmount,
    this.loanTenure,
    this.interestModel,
    this.compoundingFrequency,
    this.guarantorLiability,
    this.insuranceRequirement,
    this.balloonPayment,
  });

  factory ExtractedClauses.fromJson(Map<String, dynamic> json) {
    return ExtractedClauses(
      interestRate: json['interest_rate'] ?? '',
      lateFee: json['late_fee'] ?? '',
      earlySettlementPenalty: json['early_settlement_penalty'] ?? '',
      liabilityType: json['liability_type'] ?? '',
      repossessionClause: json['repossession_clause'] ?? '',
      loanAmount: json['loan_amount'],
      loanTenure: json['loan_tenure'],
      interestModel: json['interest_model'],
      compoundingFrequency: json['compounding_frequency'],
      guarantorLiability: json['guarantor_liability'],
      insuranceRequirement: json['insurance_requirement'],
      balloonPayment: json['balloon_payment'],
    );
  }
}

class NarrativeSimulation {
  final String oneMissedPayment;
  final String threeMissedPayments;
  final String fullDefault;

  NarrativeSimulation({
    required this.oneMissedPayment,
    required this.threeMissedPayments,
    required this.fullDefault,
  });

  factory NarrativeSimulation.fromJson(Map<String, dynamic> json) {
    return NarrativeSimulation(
      oneMissedPayment: json['one_missed_payment'] ?? '',
      threeMissedPayments: json['three_missed_payments'] ?? '',
      fullDefault: json['full_default'] ?? '',
    );
  }
}

class RiskScores {
  final int legalRiskScore;
  final int financialBurdenScore;
  final int povertyVulnerabilityScore;
  final int overallRiskScore;
  final String riskLevel;

  RiskScores({
    required this.legalRiskScore,
    required this.financialBurdenScore,
    required this.povertyVulnerabilityScore,
    required this.overallRiskScore,
    required this.riskLevel,
  });

  factory RiskScores.fromJson(Map<String, dynamic> json) {
    return RiskScores(
      legalRiskScore: json['legal_risk_score'] ?? 0,
      financialBurdenScore: json['financial_burden_score'] ?? 0,
      povertyVulnerabilityScore: json['poverty_vulnerability_score'] ?? 0,
      overallRiskScore: json['overall_risk_score'] ?? 0,
      riskLevel: json['risk_level'] ?? 'Low',
    );
  }
}

class AnalysisResult {
  final String id;
  final String agreementType;
  final ExtractedClauses extractedClauses;
  final String defenderAnalysis;
  final String protectorAnalysis;
  final NarrativeSimulation narrativeSimulation;
  final List<String> detectedRisks;
  final String plainLanguageSummary;
  final RiskScores riskScores;

  /// Optional structured debate transcript (8 alternating turns).
  /// Null for analyses created before this feature was added.
  final List<DebateTurn>? debateTranscript;

  /// User's post-analysis decision (proceed / reconsider / negotiate).
  /// Mutable — set locally when user taps, persisted via backend.
  String? userDecision;

  AnalysisResult({
    required this.id,
    required this.agreementType,
    required this.extractedClauses,
    required this.defenderAnalysis,
    required this.protectorAnalysis,
    required this.narrativeSimulation,
    required this.detectedRisks,
    required this.plainLanguageSummary,
    required this.riskScores,
    this.debateTranscript,
    this.userDecision,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AnalysisResult(
      id: json['id'] ?? '',
      agreementType: data['agreement_type'] ?? '',
      extractedClauses: ExtractedClauses.fromJson(
        data['extracted_clauses'] ?? {},
      ),
      defenderAnalysis: data['defender_analysis'] ?? '',
      protectorAnalysis: data['protector_analysis'] ?? '',
      narrativeSimulation: NarrativeSimulation.fromJson(
        data['narrative_simulation'] ?? {},
      ),
      detectedRisks: List<String>.from(data['detected_risks'] ?? []),
      plainLanguageSummary: data['plain_language_summary'] ?? '',
      riskScores: RiskScores.fromJson(data['risk_scores'] ?? {}),
      debateTranscript: data['debate_transcript'] != null
          ? (data['debate_transcript'] as List<dynamic>)
              .map((e) => DebateTurn.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      userDecision: data['user_decision'] as String?,
    );
  }
}
