import 'dart:math';
import 'package:flutter/material.dart';

/// Animated semi-circular gauge with arc-draw animation, counting score,
/// glowing tip, and tick marks. The centerpiece of the hero section.
class AnimatedGauge extends StatefulWidget {
  final int score;
  final Color color;
  final double size;

  const AnimatedGauge({
    super.key,
    required this.score,
    required this.color,
    this.size = 180,
  });

  @override
  State<AnimatedGauge> createState() => _AnimatedGaugeState();
}

class _AnimatedGaugeState extends State<AnimatedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(AnimatedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final displayScore = (_animation.value * 100).round();
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Soft background glow behind gauge
              Container(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color
                          .withValues(alpha: 0.07 * _animation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // The gauge arcs
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _GaugePainter(
                  progress: _animation.value,
                  color: widget.color,
                ),
              ),
              // Score text in center
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$displayScore',
                    style: TextStyle(
                      fontSize: widget.size * 0.26,
                      fontWeight: FontWeight.w800,
                      color: widget.color,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: widget.color.withValues(alpha: 0.6),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '/100',
                    style: TextStyle(
                      color: widget.color.withValues(alpha: 0.4),
                      fontSize: widget.size * 0.07,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;

  _GaugePainter({required this.progress, required this.color});

  // Arc spans 270° starting from bottom-left (7:30 position)
  static const double _startAngle = 3 * pi / 4;
  static const double _totalSweep = 3 * pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // ── Background arc (full track) ──
    final bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _totalSweep, false, bgPaint);

    // ── Tick marks at 0%, 25%, 50%, 75%, 100% ──
    final tickPaint = Paint()
      ..color = const Color(0xFF2A2A3E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i <= 4; i++) {
      final angle = _startAngle + _totalSweep * (i / 4);
      final innerR = radius - 20;
      final outerR = radius - 15;
      canvas.drawLine(
        Offset(
            center.dx + innerR * cos(angle), center.dy + innerR * sin(angle)),
        Offset(
            center.dx + outerR * cos(angle), center.dy + outerR * sin(angle)),
        tickPaint,
      );
    }

    if (progress > 0) {
      final sweepAngle = _totalSweep * progress;

      // ── Glow arc (behind, blurred) ──
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawArc(rect, _startAngle, sweepAngle, false, glowPaint);

      // ── Foreground arc ──
      final fgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, _startAngle, sweepAngle, false, fgPaint);

      // ── Bright tip dot ──
      final tipAngle = _startAngle + sweepAngle;
      final tipPos =
          Offset(center.dx + radius * cos(tipAngle), center.dy + radius * sin(tipAngle));

      // Tip glow
      canvas.drawCircle(
        tipPos,
        6,
        Paint()
          ..color = color.withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      // Tip white dot
      canvas.drawCircle(tipPos, 3, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress || old.color != color;
}
