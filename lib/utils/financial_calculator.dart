import 'dart:math';
import '../models/analysis_result.dart';

// =============================================================================
// FINANCIAL CALCULATOR — Pure deterministic calculations
// =============================================================================

class FinancialCalculator {
  /// Parse a monetary amount from a string (e.g., "RM50,310" → 50310.0)
  static double? parseAmount(String? text) {
    if (text == null || text.isEmpty) return null;
    final cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }

  /// Parse a percentage from a string (e.g., "14% per annum" → 14.0)
  static double? parsePercentage(String? text) {
    if (text == null || text.isEmpty) return null;
    final match = RegExp(r'(\d+\.?\d*)').firstMatch(text);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  /// Parse years from a string (e.g., "9 years" → 9)
  static int? parseYears(String? text) {
    if (text == null || text.isEmpty) return null;
    final match = RegExp(r'(\d+)').firstMatch(text);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  /// Monthly installment — flat rate (common in Malaysian hire purchase)
  static double monthlyFlat(double principal, double annualRate, int years) {
    final totalInterest = principal * (annualRate / 100) * years;
    return (principal + totalInterest) / (years * 12);
  }

  /// Monthly installment — reducing balance
  static double monthlyReducing(
      double principal, double annualRate, int years) {
    final r = annualRate / 100 / 12;
    final n = years * 12;
    if (r == 0) return principal / n;
    return principal * (r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
  }

  /// Auto-detect interest model and calculate monthly installment
  static double? monthlyInstallment(ExtractedClauses clauses) {
    final principal = parseAmount(clauses.loanAmount);
    final rate = parsePercentage(clauses.interestRate);
    final years = parseYears(clauses.loanTenure);
    if (principal == null || rate == null || years == null || years == 0) {
      return null;
    }
    final model = (clauses.interestModel ?? '').toLowerCase();
    if (model.contains('reducing') || model.contains('diminishing')) {
      return monthlyReducing(principal, rate, years);
    }
    return monthlyFlat(principal, rate, years);
  }

  /// Full repayment breakdown
  static RepaymentDetails? repaymentDetails(ExtractedClauses clauses) {
    final principal = parseAmount(clauses.loanAmount);
    final rate = parsePercentage(clauses.interestRate);
    final years = parseYears(clauses.loanTenure);
    final monthly = monthlyInstallment(clauses);
    if (principal == null ||
        rate == null ||
        years == null ||
        monthly == null) {
      return null;
    }
    final months = years * 12;
    final total = monthly * months;
    return RepaymentDetails(
      principal: principal,
      totalRepayment: total,
      totalInterest: total - principal,
      monthlyInstallment: monthly,
      tenureMonths: months,
      tenureYears: years,
      interestRate: rate,
    );
  }

  /// DTI ratio = (installment + existing) / income * 100
  static double dtiRatio(
      double income, double installment, double existing) {
    if (income <= 0) return 0;
    return ((installment + existing) / income) * 100;
  }

  /// Decision level from overall risk score
  static DecisionInfo decision(int overallRiskScore) {
    if (overallRiskScore <= 30) {
      return const DecisionInfo(
        label: 'Safe to Proceed',
        description: 'Agreement terms are within acceptable ranges.',
        level: DecisionLevel.safe,
      );
    }
    if (overallRiskScore <= 55) {
      return const DecisionInfo(
        label: 'Proceed with Caution',
        description: 'Review flagged concerns before committing.',
        level: DecisionLevel.caution,
      );
    }
    return const DecisionInfo(
      label: 'High Financial Risk \u2013 Reconsider',
      description: 'Significant risks identified. Consider alternatives.',
      level: DecisionLevel.reconsider,
    );
  }

  /// Rule-based recommended actions
  static List<ActionItem> recommendations(
    AnalysisResult result, {
    double? dti,
  }) {
    final actions = <ActionItem>[];
    final c = result.extractedClauses;
    final s = result.riskScores;

    // Interest rate > 15%
    final rate = parsePercentage(c.interestRate);
    if (rate != null && rate > 15) {
      actions.add(ActionItem(
        title: 'Negotiate Interest Rate',
        description:
            'At ${rate.toStringAsFixed(1)}%, the rate is above the typical range. '
            'Compare offers from multiple lenders before committing.',
        severity: ActionSeverity.warning,
      ));
    }

    // Joint & several liability
    final liability = c.liabilityType.toLowerCase();
    if (liability.contains('joint') && liability.contains('several')) {
      actions.add(const ActionItem(
        title: 'Understand Joint & Several Liability',
        description:
            'You could be held responsible for the entire debt individually. '
            'Discuss shared obligations with all parties involved.',
        severity: ActionSeverity.critical,
      ));
    }

    // Immediate repossession
    if (c.repossessionClause.toLowerCase().contains('immediate')) {
      actions.add(const ActionItem(
        title: 'Build an Emergency Fund',
        description:
            'Immediate repossession is possible upon default. '
            'Maintain a buffer of at least 3 months\' payments.',
        severity: ActionSeverity.warning,
      ));
    }

    // Balloon payment
    if (_present(c.balloonPayment)) {
      actions.add(ActionItem(
        title: 'Plan for Balloon Payment',
        description:
            'A large final payment of ${c.balloonPayment} is due. '
            'Start a dedicated savings plan for this amount.',
        severity: ActionSeverity.warning,
      ));
    }

    // Early settlement penalty
    if (c.earlySettlementPenalty.toLowerCase().contains('%')) {
      actions.add(const ActionItem(
        title: 'Understand Early Settlement Terms',
        description:
            'There is a penalty for early repayment. Factor this in '
            'if you plan to refinance or settle the loan early.',
        severity: ActionSeverity.info,
      ));
    }

    // Late fee escalation
    final lf = c.lateFee.toLowerCase();
    if (lf.contains('compound') ||
        lf.contains('per annum') ||
        lf.contains('8%') ||
        lf.contains('10%')) {
      actions.add(const ActionItem(
        title: 'Set Up Payment Reminders',
        description:
            'Late fees can compound quickly. Automate payments or '
            'set reminders to avoid escalating penalty costs.',
        severity: ActionSeverity.info,
      ));
    }

    // Insurance required
    if (_present(c.insuranceRequirement)) {
      actions.add(const ActionItem(
        title: 'Budget for Insurance Costs',
        description:
            'Mandatory insurance adds to your total cost. '
            'Shop around for competitive insurance rates.',
        severity: ActionSeverity.info,
      ));
    }

    // DTI warnings
    if (dti != null && dti > 50) {
      actions.add(ActionItem(
        title: 'Reconsider This Commitment',
        description:
            'Your projected DTI of ${dti.toStringAsFixed(0)}% far exceeds '
            'the safe threshold. This loan may cause severe financial strain.',
        severity: ActionSeverity.critical,
      ));
    } else if (dti != null && dti > 40) {
      actions.add(ActionItem(
        title: 'Reduce Financial Exposure',
        description:
            'Your DTI of ${dti.toStringAsFixed(0)}% exceeds the recommended '
            '40% limit. Consider a smaller loan or longer tenure.',
        severity: ActionSeverity.warning,
      ));
    }

    // High legal risk
    if (s.legalRiskScore > 60) {
      actions.add(const ActionItem(
        title: 'Seek Professional Legal Review',
        description:
            'Legal terms carry elevated risk. Have the agreement '
            'reviewed by a qualified legal advisor before signing.',
        severity: ActionSeverity.critical,
      ));
    }

    // All clear
    if (s.overallRiskScore <= 30 && actions.isEmpty) {
      actions.add(const ActionItem(
        title: 'Terms Appear Reasonable',
        description:
            'No significant concerns identified. Ensure you understand '
            'all obligations and keep copies of all documents.',
        severity: ActionSeverity.safe,
      ));
    }

    return actions;
  }

  /// Approximate effective annual rate for flat-rate loans.
  /// Flat interest charges interest on the original principal throughout,
  /// but the borrower repays principal monthly, so the effective rate is
  /// roughly:  effectiveRate ≈ (2 × n × flatRate) / (n + 1)
  static double? effectiveRate(ExtractedClauses clauses) {
    final rate = parsePercentage(clauses.interestRate);
    final years = parseYears(clauses.loanTenure);
    if (rate == null || years == null || years == 0) return null;
    final model = (clauses.interestModel ?? '').toLowerCase();
    if (model.contains('reducing') || model.contains('diminishing')) {
      return rate; // already an effective rate
    }
    final n = years * 12;
    return (2 * n * rate) / (n + 1);
  }

  /// Determine scored risk factors (mirrors backend riskEngine.ts logic).
  /// Returns list of factors with category, label, severity, and points.
  static List<RiskFactor> scoreFactors(
    ExtractedClauses clauses,
    String agreementType, {
    double? customInterestRate,
  }) {
    final factors = <RiskFactor>[];
    final type = agreementType.toLowerCase();

    final interestRate =
        customInterestRate ?? parsePercentage(clauses.interestRate);
    final lateFee = parsePercentage(clauses.lateFee);
    final earlyPenalty = parsePercentage(clauses.earlySettlementPenalty);
    final repo = clauses.repossessionClause.toLowerCase();
    final balloon = (clauses.balloonPayment ?? '').toLowerCase();
    final insurance = (clauses.insuranceRequirement ?? '').toLowerCase();
    final liability = clauses.liabilityType.toLowerCase();
    final guarantor = (clauses.guarantorLiability ?? '').toLowerCase();
    final compound = (clauses.compoundingFrequency ?? '').toLowerCase();
    final model = (clauses.interestModel ?? '').toLowerCase();

    // ── Personal Loan / Loan rules ──
    if (type.contains('personal') || type.contains('loan')) {
      if (interestRate != null && interestRate > 15) {
        factors.add(RiskFactor(
          label: 'Interest rate > 15%',
          category: 'financial',
          severity: 'high',
          points: 25,
        ));
      }
      if (model.contains('flat')) {
        factors.add(RiskFactor(
          label: 'Flat interest model',
          category: 'financial',
          severity: 'medium',
          points: 15,
        ));
      }
      if (lateFee != null && lateFee > 5) {
        factors.add(RiskFactor(
          label: 'Late fee > 5%',
          category: 'legal',
          severity: 'high',
          points: 25,
        ));
      }
      if (earlyPenalty != null && earlyPenalty > 3) {
        factors.add(RiskFactor(
          label: 'Early settlement penalty > 3%',
          category: 'financial',
          severity: 'medium',
          points: 15,
        ));
      }
      if (compound.contains('month')) {
        factors.add(RiskFactor(
          label: 'Monthly compounding interest',
          category: 'financial',
          severity: 'medium',
          points: 15,
        ));
      }
    }

    // ── Guarantor rules ──
    if (type.contains('guarantor')) {
      if (liability.contains('joint') && liability.contains('several')) {
        factors.add(RiskFactor(
          label: 'Joint & Several Liability',
          category: 'legal',
          severity: 'high',
          points: 25,
        ));
      }
      if (liability.contains('unlimited')) {
        factors.add(RiskFactor(
          label: 'Unlimited liability',
          category: 'legal',
          severity: 'high',
          points: 25,
        ));
      }
      if (!guarantor.contains('release') && !liability.contains('release')) {
        factors.add(RiskFactor(
          label: 'No release clause',
          category: 'legal',
          severity: 'medium',
          points: 15,
        ));
      }
      if (guarantor.contains('direct') ||
          guarantor.contains('recovery') ||
          liability.contains('direct recovery')) {
        factors.add(RiskFactor(
          label: 'Direct legal recovery clause',
          category: 'legal',
          severity: 'high',
          points: 25,
        ));
      }
    }

    // ── Hire Purchase rules ──
    if (type.contains('hire') || type.contains('purchase')) {
      if (repo.contains('immediate')) {
        factors.add(RiskFactor(
          label: 'Immediate repossession clause',
          category: 'legal',
          severity: 'high',
          points: 25,
        ));
      }
      if (interestRate != null && interestRate > 12) {
        factors.add(RiskFactor(
          label: 'Hire purchase interest > 12%',
          category: 'financial',
          severity: 'medium',
          points: 15,
        ));
      }
      if (balloon.isNotEmpty &&
          !balloon.contains('not applicable') &&
          !balloon.contains('none')) {
        factors.add(RiskFactor(
          label: 'Balloon payment clause',
          category: 'financial',
          severity: 'high',
          points: 25,
        ));
      }
      if (insurance.contains('mandatory') || insurance.contains('required')) {
        factors.add(RiskFactor(
          label: 'Mandatory expensive insurance',
          category: 'financial',
          severity: 'medium',
          points: 15,
        ));
      }
    }

    return factors;
  }

  /// Worst-case financial outcome data.
  static WorstCaseOutcome worstCase(AnalysisResult result) {
    final c = result.extractedClauses;
    final details = repaymentDetails(c);
    final balloon = parseAmount(c.balloonPayment);
    final repo = c.repossessionClause.toLowerCase();

    return WorstCaseOutcome(
      totalRepayment: details?.totalRepayment,
      totalInterest: details?.totalInterest,
      balloonPayment: balloon,
      hasRepossessionRisk: repo.contains('immediate') || repo.contains('upon'),
      repossessionDesc: repo.contains('immediate')
          ? 'Asset can be repossessed immediately upon default'
          : repo.contains('default')
              ? 'Asset may be repossessed after default proceedings'
              : null,
      monthlyInstallment: details?.monthlyInstallment,
      tenureYears: details?.tenureYears,
    );
  }

  /// Benchmark data comparing contract terms against typical safe ranges.
  static List<BenchmarkItem> benchmarks(
    ExtractedClauses clauses,
    String agreementType, {
    double? dtiRatio,
  }) {
    final items = <BenchmarkItem>[];
    final years = parseYears(clauses.loanTenure);
    final rate = parsePercentage(clauses.interestRate);
    final type = agreementType.toLowerCase();

    // DTI benchmark
    if (dtiRatio != null) {
      items.add(BenchmarkItem(
        label: 'Debt-to-Income Ratio',
        actual: '${dtiRatio.toStringAsFixed(0)}%',
        benchmark: '30 – 40%',
        status: dtiRatio <= 30
            ? BenchmarkStatus.good
            : dtiRatio <= 40
                ? BenchmarkStatus.caution
                : BenchmarkStatus.danger,
      ));
    }

    // Tenure benchmark
    if (years != null) {
      final isCarLoan =
          type.contains('hire') || type.contains('purchase') || type.contains('vehicle');
      final typicalMax = isCarLoan ? 7 : 10;
      items.add(BenchmarkItem(
        label: 'Loan Tenure',
        actual: '$years years',
        benchmark: isCarLoan ? '5 – 7 years' : '5 – 10 years',
        status: years <= typicalMax
            ? BenchmarkStatus.good
            : years <= typicalMax + 2
                ? BenchmarkStatus.caution
                : BenchmarkStatus.danger,
      ));
    }

    // Interest rate benchmark
    if (rate != null) {
      final isHP = type.contains('hire') || type.contains('purchase');
      final typicalMax = isHP ? 6.0 : 12.0;
      items.add(BenchmarkItem(
        label: 'Interest Rate',
        actual: '${rate.toStringAsFixed(1)}%',
        benchmark: isHP ? '3 – 6% (flat)' : '6 – 12% p.a.',
        status: rate <= typicalMax
            ? BenchmarkStatus.good
            : rate <= typicalMax * 1.5
                ? BenchmarkStatus.caution
                : BenchmarkStatus.danger,
      ));
    }

    return items;
  }

  /// Extract key insight sentences from a summary paragraph.
  /// Takes the first [count] sentences as bullet points.
  static List<String> extractKeyInsights(String summary, {int count = 3}) {
    final sentences = summary
        .split(RegExp(r'(?<=[.!?])\s+'))
        .where((s) => s.trim().length > 10)
        .toList();
    return sentences.take(count).toList();
  }

  /// The remaining text after removing the key insight sentences.
  static String remainingSummary(String summary, {int count = 3}) {
    final sentences = summary
        .split(RegExp(r'(?<=[.!?])\s+'))
        .where((s) => s.trim().length > 10)
        .toList();
    if (sentences.length <= count) return '';
    return sentences.skip(count).join(' ');
  }

  /// Repayment details recalculated with a custom interest rate.
  static RepaymentDetails? repaymentDetailsWithRate(
      ExtractedClauses clauses, double customRate) {
    final principal = parseAmount(clauses.loanAmount);
    final years = parseYears(clauses.loanTenure);
    if (principal == null || years == null || years == 0) return null;
    final model = (clauses.interestModel ?? '').toLowerCase();
    final double monthly;
    if (model.contains('reducing') || model.contains('diminishing')) {
      monthly = monthlyReducing(principal, customRate, years);
    } else {
      monthly = monthlyFlat(principal, customRate, years);
    }
    final months = years * 12;
    final total = monthly * months;
    return RepaymentDetails(
      principal: principal,
      totalRepayment: total,
      totalInterest: total - principal,
      monthlyInstallment: monthly,
      tenureMonths: months,
      tenureYears: years,
      interestRate: customRate,
    );
  }

  /// Effective rate for a custom flat rate given tenure in years.
  static double effectiveRateForCustom(double flatRate, int years) {
    final n = years * 12;
    return (2 * n * flatRate) / (n + 1);
  }

  /// Simulate poverty vulnerability score with a custom interest rate.
  static int simulatePovertyScore(
    ExtractedClauses clauses,
    String agreementType,
    double customRate,
  ) {
    final factors = scoreFactors(clauses, agreementType,
        customInterestRate: customRate);
    final totalPoints = factors.fold<int>(0, (sum, f) => sum + f.points);
    return min(100, (totalPoints * 0.8).round());
  }

  /// Format currency (e.g., 50310 → "RM 50,310")
  static String currency(double amount) {
    final str = amount.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return 'RM $buf';
  }

  static bool _present(String? v) {
    if (v == null || v.isEmpty) return false;
    final l = v.toLowerCase();
    return l != 'not applicable' &&
        l != 'not specified' &&
        l != 'n/a' &&
        l != 'none';
  }
}

// =============================================================================
// DATA CLASSES
// =============================================================================

class RepaymentDetails {
  final double principal;
  final double totalRepayment;
  final double totalInterest;
  final double monthlyInstallment;
  final int tenureMonths;
  final int tenureYears;
  final double interestRate;

  const RepaymentDetails({
    required this.principal,
    required this.totalRepayment,
    required this.totalInterest,
    required this.monthlyInstallment,
    required this.tenureMonths,
    required this.tenureYears,
    required this.interestRate,
  });

  double get principalPct => principal / totalRepayment * 100;
  double get interestPct => totalInterest / totalRepayment * 100;
}

enum DecisionLevel { safe, caution, reconsider }

class DecisionInfo {
  final String label;
  final String description;
  final DecisionLevel level;

  const DecisionInfo({
    required this.label,
    required this.description,
    required this.level,
  });
}

enum ActionSeverity { safe, info, warning, critical }

class ActionItem {
  final String title;
  final String description;
  final ActionSeverity severity;

  const ActionItem({
    required this.title,
    required this.description,
    required this.severity,
  });
}

class RiskFactor {
  final String label;
  final String category; // 'legal', 'financial'
  final String severity; // 'high', 'medium'
  final int points;

  const RiskFactor({
    required this.label,
    required this.category,
    required this.severity,
    required this.points,
  });
}

class WorstCaseOutcome {
  final double? totalRepayment;
  final double? totalInterest;
  final double? balloonPayment;
  final bool hasRepossessionRisk;
  final String? repossessionDesc;
  final double? monthlyInstallment;
  final int? tenureYears;

  const WorstCaseOutcome({
    this.totalRepayment,
    this.totalInterest,
    this.balloonPayment,
    required this.hasRepossessionRisk,
    this.repossessionDesc,
    this.monthlyInstallment,
    this.tenureYears,
  });
}

enum BenchmarkStatus { good, caution, danger }

class BenchmarkItem {
  final String label;
  final String actual;
  final String benchmark;
  final BenchmarkStatus status;

  const BenchmarkItem({
    required this.label,
    required this.actual,
    required this.benchmark,
    required this.status,
  });
}
