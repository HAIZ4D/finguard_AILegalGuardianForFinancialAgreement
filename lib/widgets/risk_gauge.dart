import 'package:flutter/material.dart';

/// Compact horizontal-bar risk gauge with animated fill and counting score.
class RiskGauge extends StatelessWidget {
  final String label;
  final int score;
  final IconData icon;
  final String? sdgLabel;

  const RiskGauge({
    super.key,
    required this.label,
    required this.score,
    required this.icon,
    this.sdgLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);
    final level = _scoreLevel(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(icon, size: 12, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ),
            if (sdgLabel != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5243B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(sdgLabel!,
                    style: const TextStyle(
                        color: Color(0xFFE5243B),
                        fontSize: 8,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
            ],
            // Animated score counter
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: score),
              duration: const Duration(milliseconds: 1800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Text('$value',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                        shadows: [
                          Shadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ]));
              },
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Animated gradient progress bar
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: score / 100),
          duration: const Duration(milliseconds: 1800),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Stack(
              children: [
                // Background track
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: const Color(0xFF1A1A28),
                  ),
                ),
                // Animated foreground fill
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.4),
                          color,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 6),

        // Level label
        Text(level,
            style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Color _scoreColor(int score) {
    if (score <= 30) return const Color(0xFF22C55E);
    if (score <= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _scoreLevel(int score) {
    if (score <= 30) return 'Low Risk';
    if (score <= 60) return 'Medium Risk';
    return 'High Risk';
  }
}
