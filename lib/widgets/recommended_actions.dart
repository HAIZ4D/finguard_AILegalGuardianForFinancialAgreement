import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../utils/financial_calculator.dart';

/// Rule-based recommended actions generated from risk scores and clauses.
class RecommendedActions extends StatefulWidget {
  final AnalysisResult result;
  final double? dtiRatio;

  const RecommendedActions({
    super.key,
    required this.result,
    this.dtiRatio,
  });

  @override
  State<RecommendedActions> createState() => _RecommendedActionsState();
}

class _RecommendedActionsState extends State<RecommendedActions> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final actions = FinancialCalculator.recommendations(
      widget.result,
      dti: widget.dtiRatio,
    );

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
            colors: [Color(0xFF101420), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF06B6D4).withValues(alpha: 0.25)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4)
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
                    const Color(0xFF06B6D4),
                    const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(actions.length),
                  const SizedBox(height: 16),
                  ...actions.asMap().entries.map((entry) {
                    final isLast = entry.key == actions.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                      child: _actionTile(entry.value),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(int count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF06B6D4).withValues(alpha: 0.18),
                const Color(0xFF06B6D4).withValues(alpha: 0.06),
              ],
            ),
            border: Border.all(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.lightbulb_rounded,
              color: Color(0xFF06B6D4), size: 15),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text('Recommended Actions',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF06B6D4).withValues(alpha: 0.18),
                const Color(0xFF06B6D4).withValues(alpha: 0.08),
              ],
            ),
          ),
          child: Text('$count',
              style: const TextStyle(
                  color: Color(0xFF06B6D4),
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _actionTile(ActionItem action) {
    final color = _severityColor(action.severity);
    final icon = _severityIcon(action.severity);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.04),
        border: Border(
          left: BorderSide(color: color, width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: color.withValues(alpha: 0.10),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action.title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
                const SizedBox(height: 4),
                Text(action.description,
                    style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 11,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _severityColor(ActionSeverity s) {
    switch (s) {
      case ActionSeverity.safe:
        return const Color(0xFF22C55E);
      case ActionSeverity.info:
        return const Color(0xFF3B82F6);
      case ActionSeverity.warning:
        return const Color(0xFFF59E0B);
      case ActionSeverity.critical:
        return const Color(0xFFEF4444);
    }
  }

  IconData _severityIcon(ActionSeverity s) {
    switch (s) {
      case ActionSeverity.safe:
        return Icons.check_circle_rounded;
      case ActionSeverity.info:
        return Icons.info_rounded;
      case ActionSeverity.warning:
        return Icons.warning_amber_rounded;
      case ActionSeverity.critical:
        return Icons.error_rounded;
    }
  }
}
