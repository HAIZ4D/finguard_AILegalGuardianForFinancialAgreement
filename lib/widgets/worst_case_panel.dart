import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// "If You Sign This Agreement…" worst-case financial outcome panel.
class WorstCasePanel extends StatefulWidget {
  final AnalysisResult result;

  const WorstCasePanel({super.key, required this.result});

  @override
  State<WorstCasePanel> createState() => _WorstCasePanelState();
}

class _WorstCasePanelState extends State<WorstCasePanel> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final wc = FinancialCalculator.worstCase(widget.result);

    // Only show if we have at least some numeric data
    final hasData = wc.totalRepayment != null ||
        wc.balloonPayment != null ||
        wc.hasRepossessionRisk;
    if (!hasData) return const SizedBox.shrink();

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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A0E0E),
              const Color(0xFF120D18),
            ],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFFEF4444).withValues(alpha: 0.25)
                : const Color(0xFF2A1A1A),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444)
                  .withValues(alpha: _hovering ? 0.10 : 0.03),
              blurRadius: _hovering ? 24 : 12,
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
                    const Color(0xFFEF4444),
                    const Color(0xFFEF4444).withValues(alpha: 0.1),
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
                              const Color(0xFFEF4444)
                                  .withValues(alpha: 0.18),
                              const Color(0xFFEF4444)
                                  .withValues(alpha: 0.06),
                            ],
                          ),
                          border: Border.all(
                              color: const Color(0xFFEF4444)
                                  .withValues(alpha: 0.15)),
                        ),
                        child: const Icon(Icons.warning_rounded,
                            color: Color(0xFFEF4444), size: 15),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('If You Sign This Agreement…',
                                style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14)),
                            SizedBox(height: 2),
                            Text('Maximum financial commitment',
                                style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Metrics grid
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (wc.totalRepayment != null)
                        _metricCard(
                          icon: Icons.payments_rounded,
                          label: 'Total Repayment',
                          value: FinancialCalculator.currency(
                              wc.totalRepayment!),
                          sublabel: wc.tenureYears != null
                              ? 'over ${wc.tenureYears} years'
                              : null,
                          color: const Color(0xFFEF4444),
                        ),
                      if (wc.totalInterest != null)
                        _metricCard(
                          icon: Icons.trending_up_rounded,
                          label: 'Total Interest Paid',
                          value: FinancialCalculator.currency(
                              wc.totalInterest!),
                          sublabel: wc.totalRepayment != null
                              ? '${(wc.totalInterest! / wc.totalRepayment! * 100).toStringAsFixed(0)}% of total'
                              : null,
                          color: const Color(0xFFF59E0B),
                        ),
                      if (wc.hasRepossessionRisk)
                        _metricCard(
                          icon: Icons.gavel_rounded,
                          label: 'Asset Loss Risk',
                          value: 'Yes',
                          sublabel: wc.repossessionDesc,
                          color: const Color(0xFFEF4444),
                        ),
                      if (wc.balloonPayment != null)
                        _metricCard(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Balloon Payment Due',
                          value: FinancialCalculator.currency(
                              wc.balloonPayment!),
                          sublabel: 'Lump sum at end of tenure',
                          color: const Color(0xFFF97316),
                        ),
                      if (wc.monthlyInstallment != null)
                        _metricCard(
                          icon: Icons.calendar_month_rounded,
                          label: 'Monthly Commitment',
                          value: FinancialCalculator.currency(
                              wc.monthlyInstallment!),
                          sublabel: 'Every month for ${wc.tenureYears ?? '—'} years',
                          color: const Color(0xFF3B82F6),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    String? sublabel,
    required Color color,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.04),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: 6),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          if (sublabel != null) ...[
            const SizedBox(height: 4),
            Text(sublabel,
                style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    height: 1.4)),
          ],
        ],
      ),
    );
  }
}
