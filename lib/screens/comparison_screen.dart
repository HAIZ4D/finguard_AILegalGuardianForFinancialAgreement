import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as List<AnalysisResult>;
    final a = args[0];
    final b = args[1];

    final diffType = a.agreementType != b.agreementType;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      appBar: _buildAppBar(context),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Different agreement type warning
                if (diffType) _warningBanner(a, b),

                // Column headers
                _columnHeaders(a, b),
                const SizedBox(height: 20),

                // Section 1 — Risk Overview
                _sectionLabel('Risk Overview', Icons.shield_rounded,
                    const Color(0xFF8B5CF6)),
                const SizedBox(height: 12),
                _riskOverview(a, b),
                const SizedBox(height: 28),

                // Section 2 — Financial Cost Table
                _sectionLabel('Financial Cost Comparison',
                    Icons.account_balance_rounded, const Color(0xFF06B6D4)),
                const SizedBox(height: 12),
                _financialTable(a, b),
                const SizedBox(height: 28),

                // Section 3 — Clause Risk Differences
                _sectionLabel('Clause Risk Differences',
                    Icons.gavel_rounded, const Color(0xFFF59E0B)),
                const SizedBox(height: 12),
                _clauseTable(a, b),
                const SizedBox(height: 28),

                // Section 4 — Risk Simulation
                _sectionLabel('Risk Simulation Comparison',
                    Icons.movie_filter_rounded, const Color(0xFFEF4444)),
                const SizedBox(height: 12),
                _simulationSection(a, b),
                const SizedBox(height: 28),

                // Section 5 — AI Verdict
                _sectionLabel('AI Recommendation Verdict',
                    Icons.auto_awesome_rounded, const Color(0xFF22C55E)),
                const SizedBox(height: 12),
                _verdictSection(a, b),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Color(0xFF94A3B8), size: 20),
            splashRadius: 18,
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              ),
            ),
            child: const Icon(Icons.compare_arrows_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          const Text('Agreement Comparison',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white)),
        ],
      ),
    );
  }

  // ── Warning Banner ──────────────────────────────────────────────────────

  Widget _warningBanner(AnalysisResult a, AnalysisResult b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
        border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFFF59E0B), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Comparing different agreement types: "${a.agreementType}" vs "${b.agreementType}". '
              'Some fields may not be directly comparable.',
              style: const TextStyle(
                  color: Color(0xFFF59E0B), fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Column Headers ──────────────────────────────────────────────────────

  Widget _columnHeaders(AnalysisResult a, AnalysisResult b) {
    return Row(
      children: [
        const SizedBox(width: 160),
        Expanded(child: _headerChip(a, 'A', const Color(0xFF3B82F6))),
        const SizedBox(width: 12),
        Expanded(child: _headerChip(b, 'B', const Color(0xFF8B5CF6))),
      ],
    );
  }

  Widget _headerChip(AnalysisResult r, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
        ),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 11)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(r.agreementType,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ── Section Label ───────────────────────────────────────────────────────

  Widget _sectionLabel(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.20)),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.25), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Section 1: Risk Overview ────────────────────────────────────────────

  Widget _riskOverview(AnalysisResult a, AnalysisResult b) {
    final aScore = a.riskScores.overallRiskScore;
    final bScore = b.riskScores.overallRiskScore;
    final diff = (aScore - bScore).abs();
    final lower = aScore <= bScore ? 'A' : 'B';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _riskCard(a, const Color(0xFF3B82F6))),
            const SizedBox(width: 12),
            Expanded(child: _riskCard(b, const Color(0xFF8B5CF6))),
          ],
        ),
        if (diff > 0) ...[
          const SizedBox(height: 12),
          _insightBanner(
            icon: Icons.insights_rounded,
            color: const Color(0xFF22C55E),
            text:
                'Agreement $lower is $diff points lower risk overall — safer choice based on scoring.',
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _scoreBreakdownRow(
                'Legal Risk',
                a.riskScores.legalRiskScore,
                b.riskScores.legalRiskScore,
                const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _scoreBreakdownRow(
                'Financial Burden',
                a.riskScores.financialBurdenScore,
                b.riskScores.financialBurdenScore,
                const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _scoreBreakdownRow(
                'Poverty Vulnerability',
                a.riskScores.povertyVulnerabilityScore,
                b.riskScores.povertyVulnerabilityScore,
                const Color(0xFFEC4899),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _riskCard(AnalysisResult r, Color accentColor) {
    final riskColor = _riskColor(r.riskScores.riskLevel);
    final score = r.riskScores.overallRiskScore;

    return _darkCard(
      accentColor: accentColor,
      child: Column(
        children: [
          // Score arc
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 7,
                  backgroundColor: riskColor.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text('$score',
                      style: TextStyle(
                          color: riskColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 24)),
                  Text('/100',
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: riskColor.withValues(alpha: 0.10),
              border: Border.all(color: riskColor.withValues(alpha: 0.22)),
            ),
            child: Text(r.riskScores.riskLevel,
                style: TextStyle(
                    color: riskColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _scoreBreakdownRow(
      String label, int aScore, int bScore, Color color) {
    final aBetter = aScore <= bScore;
    return _darkCard(
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 140,
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: _miniScoreBar(aScore, color, isBetter: aBetter),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 36,
            child: Text('$aScore',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: aBetter
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _miniScoreBar(bScore, color, isBetter: !aBetter),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 36,
            child: Text('$bScore',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: !aBetter
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  Widget _miniScoreBar(int score, Color color, {bool isBetter = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: score / 100,
        backgroundColor: const Color(0xFF1E1E2E),
        valueColor: AlwaysStoppedAnimation<Color>(
          isBetter ? const Color(0xFF22C55E) : color,
        ),
        minHeight: 6,
      ),
    );
  }

  // ── Section 2: Financial Table ──────────────────────────────────────────

  Widget _financialTable(AnalysisResult a, AnalysisResult b) {
    final rows = [
      _FinRow(
          'Loan Amount',
          a.extractedClauses.loanAmount ?? '—',
          b.extractedClauses.loanAmount ?? '—',
          Icons.attach_money_rounded),
      _FinRow(
          'Interest Rate',
          a.extractedClauses.interestRate,
          b.extractedClauses.interestRate,
          Icons.percent_rounded),
      _FinRow(
          'Interest Model',
          a.extractedClauses.interestModel ?? '—',
          b.extractedClauses.interestModel ?? '—',
          Icons.calculate_rounded),
      _FinRow(
          'Loan Tenure',
          a.extractedClauses.loanTenure ?? '—',
          b.extractedClauses.loanTenure ?? '—',
          Icons.calendar_month_rounded),
      _FinRow(
          'Late Fee',
          a.extractedClauses.lateFee,
          b.extractedClauses.lateFee,
          Icons.timer_off_rounded),
      _FinRow(
          'Early Settlement',
          a.extractedClauses.earlySettlementPenalty,
          b.extractedClauses.earlySettlementPenalty,
          Icons.exit_to_app_rounded),
      _FinRow(
          'Balloon Payment',
          a.extractedClauses.balloonPayment ?? '—',
          b.extractedClauses.balloonPayment ?? '—',
          Icons.account_balance_wallet_rounded),
      _FinRow(
          'Insurance Required',
          a.extractedClauses.insuranceRequirement ?? '—',
          b.extractedClauses.insuranceRequirement ?? '—',
          Icons.health_and_safety_rounded),
    ];

    return _darkCard(
      accentColor: const Color(0xFF06B6D4),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const SizedBox(width: 160),
                Expanded(
                  child: _tableHeader('Agreement A', const Color(0xFF3B82F6)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _tableHeader('Agreement B', const Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E1E2E), height: 1),
          const SizedBox(height: 6),
          ...rows.map((r) => _finRow(r)),
        ],
      ),
    );
  }

  Widget _tableHeader(String label, Color color) {
    return Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: color, fontWeight: FontWeight.w600, fontSize: 12));
  }

  Widget _finRow(_FinRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Row(
              children: [
                Icon(row.icon, color: const Color(0xFF475569), size: 13),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(row.label,
                      style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(row.aVal,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _finCellColor(row.aVal, row.bVal, true),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(row.bVal,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _finCellColor(row.aVal, row.bVal, false),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }

  /// Simple heuristic: extract leading number and compare.
  /// Lower % / fee → green. Higher → red.
  Color _finCellColor(String aVal, String bVal, bool isA) {
    final aNum = _extractNum(aVal);
    final bNum = _extractNum(bVal);
    if (aNum == null || bNum == null || aNum == bNum) {
      return const Color(0xFFCBD5E1);
    }
    final thisNum = isA ? aNum : bNum;
    final otherNum = isA ? bNum : aNum;
    return thisNum < otherNum
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
  }

  double? _extractNum(String s) {
    final match = RegExp(r'(\d+\.?\d*)').firstMatch(s);
    if (match == null) return null;
    return double.tryParse(match.group(1)!);
  }

  // ── Section 3: Clause Risk Differences ─────────────────────────────────

  Widget _clauseTable(AnalysisResult a, AnalysisResult b) {
    final rows = [
      _ClauseRow('Late Fee', a.extractedClauses.lateFee,
          b.extractedClauses.lateFee),
      _ClauseRow('Early Settlement', a.extractedClauses.earlySettlementPenalty,
          b.extractedClauses.earlySettlementPenalty),
      _ClauseRow(
          'Liability Type',
          a.extractedClauses.liabilityType,
          b.extractedClauses.liabilityType),
      _ClauseRow(
          'Repossession Clause',
          a.extractedClauses.repossessionClause,
          b.extractedClauses.repossessionClause),
      _ClauseRow(
          'Guarantor Liability',
          a.extractedClauses.guarantorLiability ?? '—',
          b.extractedClauses.guarantorLiability ?? '—'),
      _ClauseRow(
          'Compounding',
          a.extractedClauses.compoundingFrequency ?? '—',
          b.extractedClauses.compoundingFrequency ?? '—'),
    ];

    return Column(
      children: rows.map((r) => _clauseRow(r)).toList(),
    );
  }

  Widget _clauseRow(_ClauseRow row) {
    final aNum = _extractNum(row.aVal);
    final bNum = _extractNum(row.bVal);
    final aStricter =
        aNum != null && bNum != null && aNum > bNum;
    final bStricter =
        aNum != null && bNum != null && bNum > aNum;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF10101A),
        border: Border.all(color: const Color(0xFF1E1E2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(row.label,
                style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
          ),
          const Divider(color: Color(0xFF1E1E2E), height: 1),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _clauseCell(
                      row.aVal, aStricter, const Color(0xFF3B82F6)),
                ),
                Container(
                    width: 1, color: const Color(0xFF1E1E2E)),
                Expanded(
                  child: _clauseCell(
                      row.bVal, bStricter, const Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _clauseCell(String val, bool stricter, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val,
              style: const TextStyle(
                  color: Color(0xFFCBD5E1), fontSize: 12, height: 1.5)),
          if (stricter) ...[
            const SizedBox(height: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFEF4444).withValues(alpha: 0.10),
                border: Border.all(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.25)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_rounded,
                      color: Color(0xFFEF4444), size: 10),
                  SizedBox(width: 4),
                  Text('Stricter',
                      style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Section 4: Simulation ───────────────────────────────────────────────

  Widget _simulationSection(AnalysisResult a, AnalysisResult b) {
    return Column(
      children: [
        _simRow(
          '1 Missed Payment',
          Icons.looks_one_rounded,
          const Color(0xFFF59E0B),
          a.narrativeSimulation.oneMissedPayment,
          b.narrativeSimulation.oneMissedPayment,
        ),
        const SizedBox(height: 12),
        _simRow(
          '3 Missed Payments',
          Icons.looks_3_rounded,
          const Color(0xFFEF4444),
          a.narrativeSimulation.threeMissedPayments,
          b.narrativeSimulation.threeMissedPayments,
        ),
        const SizedBox(height: 12),
        _simRow(
          'Full Default',
          Icons.dangerous_rounded,
          const Color(0xFF991B1B),
          a.narrativeSimulation.fullDefault,
          b.narrativeSimulation.fullDefault,
        ),
      ],
    );
  }

  Widget _simRow(String scenario, IconData icon, Color color,
      String aText, String bText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 7),
            Text(scenario,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _simCard(aText, const Color(0xFF3B82F6), color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _simCard(bText, const Color(0xFF8B5CF6), color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _simCard(String text, Color borderColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF10101A),
        border: Border.all(color: const Color(0xFF1E1E2E)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(text,
          style: const TextStyle(
              color: Color(0xFFCBD5E1), fontSize: 12, height: 1.6)),
    );
  }

  // ── Section 5: AI Verdict ───────────────────────────────────────────────

  Widget _verdictSection(AnalysisResult a, AnalysisResult b) {
    final verdict = _computeVerdict(a, b);

    return Column(
      children: [
        // Main verdict banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF22C55E).withValues(alpha: 0.10),
                const Color(0xFF16A34A).withValues(alpha: 0.04),
              ],
            ),
            border: Border.all(
                color: const Color(0xFF22C55E).withValues(alpha: 0.22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                      border: Border.all(
                          color:
                              const Color(0xFF22C55E).withValues(alpha: 0.25)),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: Color(0xFF22C55E), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recommended Agreement',
                          style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11)),
                      Text(
                        'Agreement ${verdict.winner}',
                        style: const TextStyle(
                            color: Color(0xFF22C55E),
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...verdict.reasons.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF22C55E), size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(r,
                              style: const TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 12,
                                  height: 1.5)),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Audience guidance
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: _audienceCard(
                      'Who should pick A?',
                      verdict.audienceA,
                      const Color(0xFF3B82F6))),
              const SizedBox(width: 12),
              Expanded(
                  child: _audienceCard(
                      'Who should pick B?',
                      verdict.audienceB,
                      const Color(0xFF8B5CF6))),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF1E1E2E).withValues(alpha: 0.5),
            border: Border.all(color: const Color(0xFF2A2A3E)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: Color(0xFF475569), size: 13),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This recommendation is computed locally from deterministic risk scores. '
                  'It does not constitute legal or financial advice. Consult a professional before signing.',
                  style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 10,
                      height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _audienceCard(String title, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.07),
            color.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_rounded, color: color, size: 13),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text(text,
              style: const TextStyle(
                  color: Color(0xFFCBD5E1), fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }

  // ── Verdict Logic ───────────────────────────────────────────────────────

  _VerdictResult _computeVerdict(AnalysisResult a, AnalysisResult b) {
    final aScore = a.riskScores.overallRiskScore;
    final bScore = b.riskScores.overallRiskScore;
    final aLegal = a.riskScores.legalRiskScore;
    final bLegal = b.riskScores.legalRiskScore;
    final aFin = a.riskScores.financialBurdenScore;
    final bFin = b.riskScores.financialBurdenScore;
    final aWins = aScore <= bScore;
    final winner = aWins ? 'A' : 'B';
    final diff = (aScore - bScore).abs();
    final wLegal = aWins ? aLegal : bLegal;
    final lLegal = aWins ? bLegal : aLegal;
    final wFin = aWins ? aFin : bFin;
    final lFin = aWins ? bFin : aFin;

    final reasons = <String>[];

    if (diff > 0) {
      reasons.add(
        'Agreement $winner has a lower overall risk score (${ aWins ? aScore : bScore} vs ${aWins ? bScore : aScore}), '
        'making it $diff points safer.',
      );
    }
    if (wLegal < lLegal) {
      reasons.add(
        'Legal risk is lower in Agreement $winner ($wLegal vs $lLegal), '
        'indicating fewer enforceable penalty clauses.',
      );
    }
    if (wFin < lFin) {
      reasons.add(
        'Financial burden score is lower in Agreement $winner ($wFin vs $lFin), '
        'meaning less monetary pressure on the borrower.',
      );
    }
    if (reasons.isEmpty) {
      reasons.add(
        'Both agreements have identical risk scores. '
        'Review individual clauses carefully before deciding.',
      );
    }

    final audienceA = _audienceText(a, 'A');
    final audienceB = _audienceText(b, 'B');

    return _VerdictResult(
        winner: winner,
        reasons: reasons,
        audienceA: audienceA,
        audienceB: audienceB);
  }

  String _audienceText(AnalysisResult r, String label) {
    final level = r.riskScores.riskLevel;
    switch (level) {
      case 'Low':
        return 'Agreement $label is suitable for borrowers seeking minimal risk with straightforward terms.';
      case 'Medium':
        return 'Agreement $label suits borrowers who can manage moderate obligations and have a stable income.';
      default:
        return 'Agreement $label is only appropriate if you fully understand the high-risk clauses and have legal advice.';
    }
  }

  // ── Shared Helpers ──────────────────────────────────────────────────────

  Widget _insightBanner(
      {required IconData icon,
      required Color color,
      required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.07),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: color, fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _darkCard({
    Widget? child,
    Color? accentColor,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111120), Color(0xFF0D0D18)],
        ),
        border: Border.all(color: const Color(0xFF1E1E2E)),
        boxShadow: accentColor != null
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  Color _riskColor(String level) {
    switch (level) {
      case 'High':
        return const Color(0xFFEF4444);
      case 'Medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF22C55E);
    }
  }
}

// ── Data Models ─────────────────────────────────────────────────────────────

class _FinRow {
  final String label;
  final String aVal;
  final String bVal;
  final IconData icon;
  const _FinRow(this.label, this.aVal, this.bVal, this.icon);
}

class _ClauseRow {
  final String label;
  final String aVal;
  final String bVal;
  const _ClauseRow(this.label, this.aVal, this.bVal);
}

class _VerdictResult {
  final String winner;
  final List<String> reasons;
  final String audienceA;
  final String audienceB;
  const _VerdictResult(
      {required this.winner,
      required this.reasons,
      required this.audienceA,
      required this.audienceB});
}
