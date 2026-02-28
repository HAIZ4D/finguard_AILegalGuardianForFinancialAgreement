import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// Expandable "How is this score calculated?" panel showing weighted
/// risk factors contributing to each score dimension.
class ScoreTransparency extends StatefulWidget {
  final AnalysisResult result;
  final bool initiallyExpanded;

  const ScoreTransparency({
    super.key,
    required this.result,
    this.initiallyExpanded = false,
  });

  @override
  State<ScoreTransparency> createState() => _ScoreTransparencyState();
}

class _ScoreTransparencyState extends State<ScoreTransparency> {
  late bool _expanded = widget.initiallyExpanded;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final factors = FinancialCalculator.scoreFactors(
      widget.result.extractedClauses,
      widget.result.agreementType,
    );

    final legalFactors =
        factors.where((f) => f.category == 'legal').toList();
    final financialFactors =
        factors.where((f) => f.category == 'financial').toList();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111120), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.22)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6)
                  .withValues(alpha: _hovering ? 0.08 : 0.02),
              blurRadius: _hovering ? 20 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),

            // Header (always visible, tappable)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.15),
                              const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.12)),
                        ),
                        child: const Icon(Icons.analytics_rounded,
                            color: Color(0xFF8B5CF6), size: 14),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('How is this score calculated?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            SizedBox(height: 2),
                            Text(
                                'Deterministic rule-based scoring — no AI bias',
                                style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF8B5CF6)
                              .withValues(alpha: 0.10),
                        ),
                        child: Text(
                          '${factors.length} factors',
                          style: const TextStyle(
                              color: Color(0xFFA78BFA),
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: const Color(0xFF64748B),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expandable content
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _expandedContent(
                  factors, legalFactors, financialFactors),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandedContent(
    List<RiskFactor> all,
    List<RiskFactor> legal,
    List<RiskFactor> financial,
  ) {
    final s = widget.result.riskScores;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formula explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.04),
              border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Scoring Formula',
                    style: TextStyle(
                        color: Color(0xFFA78BFA),
                        fontWeight: FontWeight.w600,
                        fontSize: 11)),
                const SizedBox(height: 6),
                Text(
                  'Overall = (Legal ${s.legalRiskScore} + Financial ${s.financialBurdenScore} + Poverty ${s.povertyVulnerabilityScore}) ÷ 3 = ${s.overallRiskScore}',
                  style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 11,
                      fontFamily: 'monospace'),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Poverty score = 80% of all risk points combined. Each factor contributes points to its category, capped at 100.',
                  style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 10,
                      height: 1.5),
                ),
              ],
            ),
          ),

          if (legal.isNotEmpty) ...[
            const SizedBox(height: 14),
            _categoryHeader('Legal Risk', s.legalRiskScore,
                const Color(0xFFEF4444)),
            const SizedBox(height: 8),
            ...legal.map((f) => _factorRow(f)),
          ],

          if (financial.isNotEmpty) ...[
            const SizedBox(height: 14),
            _categoryHeader('Financial Burden', s.financialBurdenScore,
                const Color(0xFFF59E0B)),
            const SizedBox(height: 8),
            ...financial.map((f) => _factorRow(f)),
          ],

          if (all.isEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'No significant risk factors detected — all terms appear within safe ranges.',
              style: TextStyle(
                  color: Color(0xFF22C55E), fontSize: 11, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _categoryHeader(String label, int score, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11)),
        const Spacer(),
        Text('$score / 100',
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11)),
      ],
    );
  }

  Widget _factorRow(RiskFactor factor) {
    final isHigh = factor.severity == 'high';
    final color = isHigh ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            isHigh
                ? Icons.error_rounded
                : Icons.warning_amber_rounded,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(factor.label,
                style: const TextStyle(
                    color: Color(0xFFCBD5E1), fontSize: 11)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color.withValues(alpha: 0.10),
            ),
            child: Text('+${factor.points}',
                style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
