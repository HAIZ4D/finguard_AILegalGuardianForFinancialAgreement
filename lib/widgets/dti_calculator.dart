import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// Interactive Debt-to-Income calculator with real-time DTI gauge.
class DtiCalculator extends StatefulWidget {
  final ExtractedClauses clauses;
  final int povertyScore;
  final ValueChanged<double?> onDtiChanged;

  const DtiCalculator({
    super.key,
    required this.clauses,
    required this.povertyScore,
    required this.onDtiChanged,
  });

  @override
  State<DtiCalculator> createState() => _DtiCalculatorState();
}

class _DtiCalculatorState extends State<DtiCalculator> {
  final _incomeCtl = TextEditingController();
  final _commitmentsCtl = TextEditingController();
  double? _dti;
  double? _estimatedInstallment;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _estimatedInstallment =
        FinancialCalculator.monthlyInstallment(widget.clauses);
  }

  @override
  void dispose() {
    _incomeCtl.dispose();
    _commitmentsCtl.dispose();
    super.dispose();
  }

  void _recalculate() {
    final income =
        double.tryParse(_incomeCtl.text.replaceAll(',', ''));
    final commitments =
        double.tryParse(_commitmentsCtl.text.replaceAll(',', '')) ?? 0;

    if (income != null && income > 0 && _estimatedInstallment != null) {
      final ratio = FinancialCalculator.dtiRatio(
          income, _estimatedInstallment!, commitments);
      setState(() => _dti = ratio);
      widget.onDtiChanged(ratio);
    } else {
      setState(() => _dti = null);
      widget.onDtiChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            colors: [Color(0xFF0F1A1A), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF10B981).withValues(alpha: 0.25)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981)
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
                    const Color(0xFF10B981),
                    const Color(0xFF10B981).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 18),

                  // Estimated installment
                  if (_estimatedInstallment != null) ...[
                    _infoRow(
                      'Est. Monthly Installment',
                      FinancialCalculator.currency(_estimatedInstallment!),
                      const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Input fields
                  _inputField(
                    controller: _incomeCtl,
                    label: 'Your Monthly Income',
                    hint: 'e.g. 5000',
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: _commitmentsCtl,
                    label: 'Existing Monthly Commitments',
                    hint: 'e.g. 1200',
                  ),
                  const SizedBox(height: 20),

                  // DTI result
                  if (_dti != null) ...[
                    _dtiResult(),
                    const SizedBox(height: 16),
                    _dtiGauge(),
                    const SizedBox(height: 12),
                    _dtiMessage(),
                  ] else
                    _placeholder(),
                ],
              ),
            ),
          ],
        ),
      ),
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
                const Color(0xFF10B981).withValues(alpha: 0.18),
                const Color(0xFF10B981).withValues(alpha: 0.06),
              ],
            ),
            border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.account_balance_rounded,
              color: Color(0xFF10B981), size: 15),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text('DTI Impact Calculator',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
          ),
          child: const Text('Optional',
              style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))],
          style: const TextStyle(color: Colors.white, fontSize: 14),
          onChanged: (_) => _recalculate(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF475569)),
            prefixText: 'RM ',
            prefixStyle: const TextStyle(color: Color(0xFF64748B)),
            filled: true,
            fillColor: const Color(0xFF0A0A14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E1E2E)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E1E2E)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF10B981)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.06),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _dtiResult() {
    final color = _dtiColor(_dti!);
    return Row(
      children: [
        const Text('Your DTI Ratio: ',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _dti!),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, val, _) {
            return Text('${val.toStringAsFixed(1)}%',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 8),
                    ]));
          },
        ),
      ],
    );
  }

  Widget _dtiGauge() {
    final color = _dtiColor(_dti!);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _dti!),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        return Column(
          children: [
            SizedBox(
              height: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    // Segmented background
                    Row(
                      children: [
                        Expanded(
                            flex: 30,
                            child: Container(
                                color: const Color(0xFF22C55E)
                                    .withValues(alpha: 0.12))),
                        Expanded(
                            flex: 10,
                            child: Container(
                                color: const Color(0xFFF59E0B)
                                    .withValues(alpha: 0.12))),
                        Expanded(
                            flex: 60,
                            child: Container(
                                color: const Color(0xFFEF4444)
                                    .withValues(alpha: 0.12))),
                      ],
                    ),
                    // Fill
                    FractionallySizedBox(
                      widthFactor: (val / 100).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: color,
                          boxShadow: [
                            BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Text('Safe',
                    style:
                        TextStyle(color: Color(0xFF22C55E), fontSize: 9)),
                Spacer(),
                Text('40%',
                    style:
                        TextStyle(color: Color(0xFFF59E0B), fontSize: 9)),
                Spacer(),
                Text('Danger',
                    style:
                        TextStyle(color: Color(0xFFEF4444), fontSize: 9)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _dtiMessage() {
    final color = _dtiColor(_dti!);
    final IconData icon;
    final String msg;

    if (_dti! <= 30) {
      icon = Icons.check_circle_rounded;
      msg = 'Your DTI is in the safe zone. This commitment appears manageable.';
    } else if (_dti! <= 40) {
      icon = Icons.info_rounded;
      msg =
          'At this level, your financial flexibility is limited. A single '
          'unexpected expense may push you into unsafe debt.';
    } else {
      icon = Icons.warning_rounded;
      msg =
          'Your debt level exceeds recommended safety limits. This increases '
          'vulnerability to financial distress.';
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.06),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(msg,
                style: TextStyle(
                    color: color.withValues(alpha: 0.9),
                    fontSize: 11,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF151520),
        border: Border.all(color: const Color(0xFF1E1E2E)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF475569), size: 14),
          SizedBox(width: 8),
          Expanded(
            child: Text(
                'Enter your income to calculate your debt-to-income ratio.',
                style: TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 11,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }

  Color _dtiColor(double dti) {
    if (dti <= 30) return const Color(0xFF22C55E);
    if (dti <= 40) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}
