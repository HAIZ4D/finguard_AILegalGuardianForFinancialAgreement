import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class SimulationTimeline extends StatelessWidget {
  final NarrativeSimulation simulation;

  const SimulationTimeline({super.key, required this.simulation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineStep(
          step: 1,
          title: '1 Missed Payment',
          description: simulation.oneMissedPayment,
          color: const Color(0xFFFBBF24),
          icon: Icons.warning_amber_rounded,
          isFirst: true,
        ),
        _TimelineStep(
          step: 2,
          title: '3 Missed Payments',
          description: simulation.threeMissedPayments,
          color: const Color(0xFFF97316),
          icon: Icons.error_outline_rounded,
        ),
        _TimelineStep(
          step: 3,
          title: 'Full Default',
          description: simulation.fullDefault,
          color: const Color(0xFFEF4444),
          icon: Icons.dangerous_rounded,
          isLast: true,
        ),
      ],
    );
  }
}

class _TimelineStep extends StatefulWidget {
  final int step;
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.step,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<_TimelineStep> createState() => _TimelineStepState();
}

class _TimelineStepState extends State<_TimelineStep> {
  bool _expanded = false;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!widget.isFirst)
                  Container(
                    width: 2,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1E1E2E),
                          widget.color.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.withValues(alpha: 0.15),
                        widget.color.withValues(alpha: 0.05),
                      ],
                    ),
                    border: Border.all(
                        color: widget.color.withValues(alpha: 0.35),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child:
                      Icon(widget.icon, size: 14, color: widget.color),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.color.withValues(alpha: 0.3),
                            const Color(0xFF1E1E2E),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Content card with hover effect
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hovering = true),
                onExit: (_) => setState(() => _hovering = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  transform: Matrix4.identity()
                    ..scale(_hovering ? 1.012 : 1.0,
                        _hovering ? 1.012 : 1.0),
                  transformAlignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF151520), Color(0xFF0F0F18)],
                    ),
                    border: Border.all(
                      color: _hovering
                          ? widget.color.withValues(alpha: 0.22)
                          : widget.color.withValues(alpha: 0.10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(
                            alpha: _hovering ? 0.10 : 0.04),
                        blurRadius: _hovering ? 20 : 12,
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
                              widget.color.withValues(alpha: 0.6),
                              widget.color.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                      // Body
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              setState(() => _expanded = !_expanded),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(widget.title,
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.w600,
                                              color: widget.color,
                                              fontSize: 13)),
                                    ),
                                    Icon(
                                      _expanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: const Color(0xFF475569),
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                AnimatedCrossFade(
                                  firstChild: Text(
                                    _truncate(
                                        widget.description, 120),
                                    style: const TextStyle(
                                        color: Color(0xFFCBD5E1),
                                        height: 1.6,
                                        fontSize: 12),
                                  ),
                                  secondChild: Text(
                                    widget.description,
                                    style: const TextStyle(
                                        color: Color(0xFFCBD5E1),
                                        height: 1.6,
                                        fontSize: 12),
                                  ),
                                  crossFadeState: _expanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: const Duration(
                                      milliseconds: 200),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
