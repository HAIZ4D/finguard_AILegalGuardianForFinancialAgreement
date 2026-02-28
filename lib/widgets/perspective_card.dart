import 'package:flutter/material.dart';

class PerspectiveCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String content;

  const PerspectiveCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.content,
  });

  @override
  State<PerspectiveCard> createState() => _PerspectiveCardState();
}

class _PerspectiveCardState extends State<PerspectiveCard> {
  bool _expanded = false;
  bool _hovering = false;

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF151520), Color(0xFF0F0F18)],
          ),
          border: Border.all(
            color: _hovering
                ? widget.color.withValues(alpha: 0.28)
                : widget.color.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color
                  .withValues(alpha: _hovering ? 0.14 : 0.06),
              blurRadius: _hovering ? 28 : 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color,
                    widget.color.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),

            // Header with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: 0.12),
                    widget.color.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withValues(alpha: 0.20),
                          widget.color.withValues(alpha: 0.08),
                        ],
                      ),
                      border: Border.all(
                          color: widget.color.withValues(alpha: 0.18)),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.12),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(widget.icon,
                        color: widget.color, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: widget.color,
                                fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(widget.subtitle,
                            style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withValues(alpha: 0.12),
                          widget.color.withValues(alpha: 0.04),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withValues(alpha: 0.6),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    widget.color.withValues(alpha: 0.4),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('AI',
                            style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content (structured bullet format)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBullets(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBullets() {
    final sentences = widget.content
        .split(RegExp(r'(?<=[.!?])\s+'))
        .where((s) => s.trim().length > 10)
        .toList();

    final display = _expanded ? sentences : sentences.take(3).toList();
    final hasMore = sentences.length > 3;

    return [
      ...display.map((sentence) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.6),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(sentence.trim(),
                      style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          height: 1.6,
                          fontSize: 12)),
                ),
              ],
            ),
          )),
      if (hasMore) ...[
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _expanded ? 'Show less' : 'Show all points',
                style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: widget.color,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    ];
  }
}
