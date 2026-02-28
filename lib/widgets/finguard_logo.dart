import 'package:flutter/material.dart';

/// Premium FinGuard logo — custom-painted shield with gradient, inner glow,
/// and a stylised "F" initial.
class FinGuardLogo extends StatelessWidget {
  final double size;

  const FinGuardLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Shield path (modern angular shape) ──
    final shield = Path()
      ..moveTo(w * 0.50, h * 0.02) // top centre
      ..cubicTo(
        w * 0.38, h * 0.02,
        w * 0.08, h * 0.08,
        w * 0.06, h * 0.18,
      )
      ..lineTo(w * 0.06, h * 0.48)
      ..cubicTo(
        w * 0.06, h * 0.68,
        w * 0.22, h * 0.86,
        w * 0.50, h * 0.98,
      )
      ..cubicTo(
        w * 0.78, h * 0.86,
        w * 0.94, h * 0.68,
        w * 0.94, h * 0.48,
      )
      ..lineTo(w * 0.94, h * 0.18)
      ..cubicTo(
        w * 0.92, h * 0.08,
        w * 0.62, h * 0.02,
        w * 0.50, h * 0.02,
      )
      ..close();

    // ── Outer glow ──
    canvas.drawPath(
      shield,
      Paint()
        ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // ── Main gradient fill ──
    canvas.drawPath(
      shield,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7C3AED),
            const Color(0xFF8B5CF6),
            const Color(0xFFA78BFA),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // ── Inner highlight (top-left arc glow) ──
    final highlightPath = Path()
      ..moveTo(w * 0.50, h * 0.06)
      ..cubicTo(
        w * 0.38, h * 0.06,
        w * 0.14, h * 0.11,
        w * 0.12, h * 0.20,
      )
      ..lineTo(w * 0.12, h * 0.36)
      ..cubicTo(
        w * 0.12, h * 0.36,
        w * 0.35, h * 0.20,
        w * 0.60, h * 0.06,
      )
      ..close();

    canvas.drawPath(
      highlightPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15),
    );

    // ── Stylised "F" initial ──
    _drawF(canvas, w, h);

    // ── Thin inner border ──
    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.30),
            Colors.white.withValues(alpha: 0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
  }

  void _drawF(Canvas canvas, double w, double h) {
    // Position the F in the centre of the shield
    final cx = w * 0.50;
    final cy = h * 0.50;
    final fSize = w * 0.30;

    final fPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = fSize * 0.18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Vertical stroke
    final fPath = Path()
      ..moveTo(cx - fSize * 0.30, cy - fSize * 0.55)
      ..lineTo(cx - fSize * 0.30, cy + fSize * 0.55);

    // Top horizontal stroke
    fPath
      ..moveTo(cx - fSize * 0.30, cy - fSize * 0.55)
      ..lineTo(cx + fSize * 0.35, cy - fSize * 0.55);

    // Middle horizontal stroke (slightly shorter)
    fPath
      ..moveTo(cx - fSize * 0.30, cy - fSize * 0.02)
      ..lineTo(cx + fSize * 0.18, cy - fSize * 0.02);

    canvas.drawPath(fPath, fPaint);

    // Subtle glow behind the F
    canvas.drawPath(
      fPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = fSize * 0.18
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
