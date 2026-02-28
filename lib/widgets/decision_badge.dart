import 'package:flutter/material.dart';
import '../utils/financial_calculator.dart';

/// Prominent Sign / Reconsider decision-support badge.
class DecisionBadge extends StatelessWidget {
  final int overallRiskScore;

  const DecisionBadge({super.key, required this.overallRiskScore});

  @override
  Widget build(BuildContext context) {
    final info = FinancialCalculator.decision(overallRiskScore);
    final color = _color(info.level);
    final icon = _icon(info.level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.14),
            color.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(info.label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    )),
                const SizedBox(height: 2),
                Text(info.description,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.7),
                      fontSize: 10,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _color(DecisionLevel level) {
    switch (level) {
      case DecisionLevel.safe:
        return const Color(0xFF22C55E);
      case DecisionLevel.caution:
        return const Color(0xFFF59E0B);
      case DecisionLevel.reconsider:
        return const Color(0xFFEF4444);
    }
  }

  IconData _icon(DecisionLevel level) {
    switch (level) {
      case DecisionLevel.safe:
        return Icons.verified_rounded;
      case DecisionLevel.caution:
        return Icons.info_rounded;
      case DecisionLevel.reconsider:
        return Icons.warning_rounded;
    }
  }
}
