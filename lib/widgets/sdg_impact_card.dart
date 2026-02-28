import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// SDG 1 impact explanation with benchmark comparisons.
class SdgImpactCard extends StatefulWidget {
  final AnalysisResult result;
  final double? dtiRatio;

  const SdgImpactCard({
    super.key,
    required this.result,
    this.dtiRatio,
  });

  @override
  State<SdgImpactCard> createState() => _SdgImpactCardState();
}

class _SdgImpactCardState extends State<SdgImpactCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final benchmarks = FinancialCalculator.benchmarks(
      widget.result.extractedClauses,
      widget.result.agreementType,
      dtiRatio: widget.dtiRatio,
    );
    final povertyScore =
        widget.result.riskScores.povertyVulnerabilityScore;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.008 : 1.0, _hovering ? 1.008 : 1.0),
        transformAlignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF101420), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFFE5243B).withValues(alpha: 0.22)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE5243B)
                  .withValues(alpha: _hovering ? 0.08 : 0.02),
              blurRadius: _hovering ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Red accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE5243B),
                    const Color(0xFFE5243B).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFE5243B)
                                  .withValues(alpha: 0.15),
                              const Color(0xFFE5243B)
                                  .withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                              color: const Color(0xFFE5243B)
                                  .withValues(alpha: 0.12)),
                        ),
                        child: const Icon(Icons.public_rounded,
                            color: Color(0xFFE5243B), size: 15),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SDG 1 · No Poverty',
                                style: TextStyle(
                                    color: Color(0xFFE5243B),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                            SizedBox(height: 2),
                            Text('Why this matters',
                                style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFFE5243B)
                              .withValues(alpha: 0.10),
                        ),
                        child: Text('Score: $povertyScore',
                            style: const TextStyle(
                                color: Color(0xFFE5243B),
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Impact explanation
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          const Color(0xFFE5243B).withValues(alpha: 0.03),
                      border: Border.all(
                          color: const Color(0xFFE5243B)
                              .withValues(alpha: 0.08)),
                    ),
                    child: Text(
                      _impactText(povertyScore),
                      style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 11,
                          height: 1.7),
                    ),
                  ),

                  // Benchmarks
                  if (benchmarks.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const Text('Benchmark Comparison',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text(
                        'How your agreement compares to recommended safe ranges',
                        style: TextStyle(
                            color: Color(0xFF64748B), fontSize: 10)),
                    const SizedBox(height: 12),
                    ...benchmarks.map(_benchmarkRow),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _impactText(int score) {
    if (score >= 60) {
      return 'This agreement carries significant poverty vulnerability. '
          'High repayment burden, combined with repossession risk or balloon '
          'payments, can push borrowers into debt cycles — particularly '
          'affecting lower-income households. Defaulting may result in loss '
          'of essential assets while the debt obligation remains.';
    }
    if (score >= 30) {
      return 'Some financial vulnerability indicators are present. '
          'Extended repayment tenure or above-average interest rates '
          'increase the total cost of borrowing and can strain household '
          'budgets. Consider whether this commitment leaves sufficient '
          'buffer for unexpected expenses.';
    }
    return 'This agreement shows low poverty vulnerability. '
        'The terms are within generally acceptable ranges and the total '
        'repayment cost is proportionate. However, always ensure the '
        'monthly commitment fits comfortably within your budget.';
  }

  Widget _benchmarkRow(BenchmarkItem item) {
    final color = _statusColor(item.status);
    final icon = _statusIcon(item.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withValues(alpha: 0.04),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label,
                      style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontWeight: FontWeight.w500,
                          fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('Safe range: ${item.benchmark}',
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 10)),
                ],
              ),
            ),
            Text(item.actual,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Color _statusColor(BenchmarkStatus s) {
    switch (s) {
      case BenchmarkStatus.good:
        return const Color(0xFF22C55E);
      case BenchmarkStatus.caution:
        return const Color(0xFFF59E0B);
      case BenchmarkStatus.danger:
        return const Color(0xFFEF4444);
    }
  }

  IconData _statusIcon(BenchmarkStatus s) {
    switch (s) {
      case BenchmarkStatus.good:
        return Icons.check_circle_rounded;
      case BenchmarkStatus.caution:
        return Icons.warning_amber_rounded;
      case BenchmarkStatus.danger:
        return Icons.error_rounded;
    }
  }
}
