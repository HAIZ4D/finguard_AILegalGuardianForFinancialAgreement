import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// Educational panel explaining effective interest rate impact
/// for flat-rate loans with long tenure, plus a What-If negotiation slider.
class InterestInsight extends StatefulWidget {
  final ExtractedClauses clauses;
  final String agreementType;
  final int basePovertyScore;

  const InterestInsight({
    super.key,
    required this.clauses,
    required this.agreementType,
    required this.basePovertyScore,
  });

  @override
  State<InterestInsight> createState() => _InterestInsightState();
}

class _InterestInsightState extends State<InterestInsight> {
  bool _hovering = false;
  double? _simulatedRate;

  @override
  Widget build(BuildContext context) {
    final nominalRate = FinancialCalculator.parsePercentage(
        widget.clauses.interestRate);
    final effectiveRate =
        FinancialCalculator.effectiveRate(widget.clauses);
    final years =
        FinancialCalculator.parseYears(widget.clauses.loanTenure);
    final model = (widget.clauses.interestModel ?? '').toLowerCase();
    final isFlat =
        !model.contains('reducing') && !model.contains('diminishing');

    // Only show if we have meaningful data and it's a flat rate
    if (nominalRate == null || effectiveRate == null || !isFlat) {
      return const SizedBox.shrink();
    }

    final multiplier = effectiveRate / nominalRate;
    final details =
        FinancialCalculator.repaymentDetails(widget.clauses);

    // Simulation values (when slider is active)
    final isSimulating =
        _simulatedRate != null && _simulatedRate != nominalRate;
    final simRate = _simulatedRate ?? nominalRate;
    final simEffective = years != null
        ? FinancialCalculator.effectiveRateForCustom(simRate, years)
        : null;
    final simDetails = isSimulating
        ? FinancialCalculator.repaymentDetailsWithRate(
            widget.clauses, simRate)
        : null;
    final simPoverty = isSimulating
        ? FinancialCalculator.simulatePovertyScore(
            widget.clauses, widget.agreementType, simRate)
        : null;

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
                ? const Color(0xFFF59E0B).withValues(alpha: 0.22)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B)
                  .withValues(alpha: _hovering ? 0.08 : 0.02),
              blurRadius: _hovering ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amber accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF59E0B),
                    const Color(0xFFF59E0B).withValues(alpha: 0.1),
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
                  _header(),
                  const SizedBox(height: 16),

                  // Rate comparison
                  Row(
                    children: [
                      Expanded(
                          child: _rateBox(
                        label: 'Stated Rate',
                        rate: '${nominalRate.toStringAsFixed(1)}%',
                        sublabel: 'Flat rate per annum',
                        color: const Color(0xFF3B82F6),
                      )),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Color(0xFF475569), size: 16),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _rateBox(
                        label: 'Effective Rate',
                        rate: '≈ ${effectiveRate.toStringAsFixed(1)}%',
                        sublabel: 'True annual cost',
                        color: const Color(0xFFF59E0B),
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Emotional framing sentence
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          const Color(0xFFF59E0B).withValues(alpha: 0.06),
                      border: Border.all(
                          color: const Color(0xFFF59E0B)
                              .withValues(alpha: 0.12)),
                    ),
                    child: Text(
                      _emotionalFraming(multiplier),
                      style: const TextStyle(
                          color: Color(0xFFFBBF24),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Explanation
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          const Color(0xFFF59E0B).withValues(alpha: 0.03),
                      border: Border.all(
                          color: const Color(0xFFF59E0B)
                              .withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A flat rate of ${nominalRate.toStringAsFixed(1)}% '
                          '${years != null ? "over $years years " : ""}'
                          'charges interest on the original principal throughout '
                          'the entire loan period — even as you pay it down monthly. '
                          'The effective cost is approximately '
                          '${multiplier.toStringAsFixed(1)}× the stated rate.',
                          style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 11,
                              height: 1.7),
                        ),
                        if (details != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            'You will pay ${FinancialCalculator.currency(details.totalInterest)} '
                            'in interest alone — '
                            '${details.interestPct.toStringAsFixed(0)}% of your total repayment.',
                            style: const TextStyle(
                                color: Color(0xFFFBBF24),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                height: 1.5),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── What-If Slider ──
                  if (years != null) ...[
                    const SizedBox(height: 20),
                    _sliderSection(
                      nominalRate: nominalRate,
                      years: years,
                      simRate: simRate,
                      simEffective: simEffective,
                      simDetails: simDetails,
                      simPoverty: simPoverty,
                      originalDetails: details,
                      isSimulating: isSimulating,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _emotionalFraming(double multiplier) {
    if (multiplier >= 1.8) {
      return 'This loan costs nearly double the advertised rate due to '
          'flat interest calculation.';
    }
    if (multiplier >= 1.5) {
      return 'The true cost of this loan is significantly higher than '
          'the stated rate due to flat interest on the full principal.';
    }
    return 'Flat interest results in a moderately higher effective cost '
        'than the stated rate.';
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
                const Color(0xFFF59E0B).withValues(alpha: 0.15),
                const Color(0xFFF59E0B).withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12)),
          ),
          child: const Icon(Icons.school_rounded,
              color: Color(0xFFF59E0B), size: 15),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Effective Interest Insight',
                  style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              SizedBox(height: 2),
              Text('What flat rate really costs you',
                  style:
                      TextStyle(color: Color(0xFF64748B), fontSize: 10)),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
          ),
          child: const Text('Educational',
              style: TextStyle(
                  color: Color(0xFFFBBF24),
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _sliderSection({
    required double nominalRate,
    required int years,
    required double simRate,
    required double? simEffective,
    required RepaymentDetails? simDetails,
    required int? simPoverty,
    required RepaymentDetails? originalDetails,
    required bool isSimulating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF10B981).withValues(alpha: 0.10),
              ),
              child: const Icon(Icons.tune_rounded,
                  color: Color(0xFF10B981), size: 13),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Simulate Negotiated Interest Rate',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
            if (isSimulating)
              GestureDetector(
                onTap: () => setState(() => _simulatedRate = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color:
                        const Color(0xFF475569).withValues(alpha: 0.2),
                  ),
                  child: const Text('Reset',
                      style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 9,
                          fontWeight: FontWeight.w500)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Slider
        Row(
          children: [
            const Text('5%',
                style:
                    TextStyle(color: Color(0xFF64748B), fontSize: 10)),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFF10B981),
                  inactiveTrackColor: const Color(0xFF1E1E2E),
                  thumbColor: const Color(0xFF10B981),
                  overlayColor: const Color(0xFF10B981)
                      .withValues(alpha: 0.12),
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 7),
                ),
                child: Slider(
                  value: simRate.clamp(5.0, 25.0),
                  min: 5,
                  max: 25,
                  divisions: 40,
                  onChanged: (v) =>
                      setState(() => _simulatedRate = v),
                ),
              ),
            ),
            const Text('25%',
                style:
                    TextStyle(color: Color(0xFF64748B), fontSize: 10)),
          ],
        ),

        // Current slider value
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: isSimulating
                  ? const Color(0xFF10B981).withValues(alpha: 0.10)
                  : const Color(0xFF1E1E2E),
            ),
            child: Text(
              '${simRate.toStringAsFixed(1)}% flat',
              style: TextStyle(
                  color: isSimulating
                      ? const Color(0xFF10B981)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ),
        ),

        // Simulation results
        if (isSimulating && simEffective != null) ...[
          const SizedBox(height: 16),
          _simulationResults(
            simEffective: simEffective,
            simDetails: simDetails,
            simPoverty: simPoverty!,
            originalDetails: originalDetails,
          ),
        ],
      ],
    );
  }

  Widget _simulationResults({
    required double simEffective,
    required RepaymentDetails? simDetails,
    required int simPoverty,
    required RepaymentDetails? originalDetails,
  }) {
    final savings = (originalDetails != null && simDetails != null)
        ? originalDetails.totalInterest - simDetails.totalInterest
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.06),
            const Color(0xFF10B981).withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('If you negotiate to this rate:',
              style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 11)),
          const SizedBox(height: 12),

          // Metrics row
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _simMetric(
                'Effective Rate',
                '${simEffective.toStringAsFixed(1)}%',
                const Color(0xFFF59E0B),
              ),
              if (simDetails != null)
                _simMetric(
                  'Total Repayment',
                  FinancialCalculator.currency(
                      simDetails.totalRepayment),
                  const Color(0xFF3B82F6),
                ),
              if (simDetails != null)
                _simMetric(
                  'Total Interest',
                  FinancialCalculator.currency(
                      simDetails.totalInterest),
                  const Color(0xFFF97316),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Poverty score change
          Row(
            children: [
              const Icon(Icons.public_rounded,
                  color: Color(0xFFE5243B), size: 13),
              const SizedBox(width: 6),
              const Text('Poverty Score: ',
                  style: TextStyle(
                      color: Color(0xFF94A3B8), fontSize: 11)),
              Text('${widget.basePovertyScore}',
                  style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.arrow_forward_rounded,
                    color: Color(0xFF475569), size: 12),
              ),
              Text('$simPoverty',
                  style: TextStyle(
                      color: simPoverty < widget.basePovertyScore
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              if (simPoverty < widget.basePovertyScore) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFF22C55E)
                        .withValues(alpha: 0.12),
                  ),
                  child: Text(
                    '-${widget.basePovertyScore - simPoverty}',
                    style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),

          // Savings highlight
          if (savings != null && savings > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    const Color(0xFF22C55E).withValues(alpha: 0.08),
                border: Border.all(
                    color: const Color(0xFF22C55E)
                        .withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_rounded,
                      color: Color(0xFF22C55E), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You would save ${FinancialCalculator.currency(savings)} '
                      'in total interest.',
                      style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.w600,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _simMetric(String label, String value, Color color) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.05),
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 9,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _rateBox({
    required String label,
    required String rate,
    required String sublabel,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.04),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(rate,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
          const SizedBox(height: 4),
          Text(sublabel,
              style: const TextStyle(
                  color: Color(0xFF64748B), fontSize: 9)),
        ],
      ),
    );
  }
}
