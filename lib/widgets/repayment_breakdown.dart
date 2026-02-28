import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// Visual breakdown of principal vs interest over loan lifetime.
class RepaymentBreakdown extends StatefulWidget {
  final ExtractedClauses clauses;

  const RepaymentBreakdown({super.key, required this.clauses});

  @override
  State<RepaymentBreakdown> createState() => _RepaymentBreakdownState();
}

class _RepaymentBreakdownState extends State<RepaymentBreakdown> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final details = FinancialCalculator.repaymentDetails(widget.clauses);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.012 : 1.0, _hovering ? 1.012 : 1.0),
        transformAlignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF12101E), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6)
                  .withValues(alpha: _hovering ? 0.10 : 0.03),
              blurRadius: _hovering ? 28 : 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: details != null
                  ? _breakdownContent(details)
                  : _insufficientData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breakdownContent(RepaymentDetails d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 20),

        // Total repayment — large hero number
        Text('Total Repayment',
            style: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 11)),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: d.totalRepayment),
          duration: const Duration(milliseconds: 1600),
          curve: Curves.easeOutCubic,
          builder: (context, val, _) {
            return Text(
              FinancialCalculator.currency(val),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Stacked bar
        _stackedBar(d),
        const SizedBox(height: 18),

        // Three stat cards
        Row(
          children: [
            Expanded(
                child: _stat(
                    'Principal',
                    FinancialCalculator.currency(d.principal),
                    '${d.principalPct.toStringAsFixed(0)}%',
                    const Color(0xFF8B5CF6))),
            const SizedBox(width: 10),
            Expanded(
                child: _stat(
                    'Interest Paid',
                    FinancialCalculator.currency(d.totalInterest),
                    '${d.interestPct.toStringAsFixed(0)}%',
                    const Color(0xFFF59E0B))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: _stat(
                    'Monthly',
                    FinancialCalculator.currency(d.monthlyInstallment),
                    '${d.tenureMonths} months',
                    const Color(0xFF06B6D4))),
            const SizedBox(width: 10),
            Expanded(
                child: _stat(
                    'Interest Rate',
                    '${d.interestRate.toStringAsFixed(1)}%',
                    '${d.tenureYears} years',
                    const Color(0xFF64748B))),
          ],
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                const Color(0xFF8B5CF6).withValues(alpha: 0.06),
              ],
            ),
            border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.bar_chart_rounded,
              color: Color(0xFF8B5CF6), size: 15),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text('Repayment Breakdown',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ),
      ],
    );
  }

  Widget _stackedBar(RepaymentDetails d) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        final principalFlex = (d.principalPct * val).round().clamp(1, 100);
        final interestFlex = (d.interestPct * val).round().clamp(1, 100);

        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 14,
                child: Row(
                  children: [
                    Expanded(
                      flex: principalFlex,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7C3AED),
                              Color(0xFF8B5CF6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: interestFlex,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF59E0B)
                                  .withValues(alpha: 0.7),
                              const Color(0xFFF59E0B),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: const Color(0xFF8B5CF6),
                        )),
                    const SizedBox(width: 4),
                    Text(
                        'Principal ${d.principalPct.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: Color(0xFF94A3B8), fontSize: 10)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: const Color(0xFFF59E0B),
                        )),
                    const SizedBox(width: 4),
                    Text(
                        'Interest ${d.interestPct.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: Color(0xFF94A3B8), fontSize: 10)),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _stat(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sub,
              style: const TextStyle(
                  color: Color(0xFF475569), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _insufficientData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF151520),
            border: Border.all(color: const Color(0xFF1E1E2E)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF475569), size: 16),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Loan amount, interest rate, or tenure not found in the agreement. '
                    'Repayment breakdown requires all three values.',
                    style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
