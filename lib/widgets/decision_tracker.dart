import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import '../models/analysis_result.dart';
import '../providers/analysis_provider.dart';
import '../services/api_service.dart';

/// "Would you proceed with this agreement?" — lightweight behavioral
/// impact tracker for hackathon judging.
class DecisionTracker extends StatefulWidget {
  final AnalysisResult result;

  const DecisionTracker({super.key, required this.result});

  @override
  State<DecisionTracker> createState() => _DecisionTrackerState();
}

class _DecisionTrackerState extends State<DecisionTracker> {
  bool _hovering = false;

  static const _options = [
    _Option(
      key: 'proceed',
      label: 'Proceed',
      icon: Icons.check_circle_rounded,
      color: Color(0xFF22C55E),
    ),
    _Option(
      key: 'reconsider',
      label: 'Reconsider',
      icon: Icons.pause_circle_rounded,
      color: Color(0xFFF59E0B),
    ),
    _Option(
      key: 'negotiate',
      label: 'Seek Negotiation',
      icon: Icons.handshake_rounded,
      color: Color(0xFF3B82F6),
    ),
  ];

  bool get _hasDecision => widget.result.userDecision != null;

  Future<void> _submit(String decision) async {
    // Update local state via provider
    if (mounted) {
      context
          .read<AnalysisProvider>()
          .setDecision(widget.result.id, decision);
    }

    // Log to Firebase Analytics
    FirebaseAnalytics.instance.logEvent(
      name: 'decision_recorded',
      parameters: {
        'decision': decision,
        'risk_level': widget.result.riskScores.riskLevel,
        'risk_score': widget.result.riskScores.overallRiskScore,
      },
    );

    // Fire-and-forget — log to backend
    try {
      await ApiService().logDecision(
        analysisId: widget.result.id,
        decision: decision,
        riskScore: widget.result.riskScores.overallRiskScore,
      );
    } catch (_) {
      // Silent fail — UI still shows confirmation
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
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111828), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.22)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6)
                  .withValues(alpha: _hovering ? 0.06 : 0.02),
              blurRadius: _hovering ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Purple accent bar
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
              child: _hasDecision ? _confirmation() : _prompt(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prompt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                    color: const Color(0xFF8B5CF6)
                        .withValues(alpha: 0.12)),
              ),
              child: const Icon(Icons.how_to_vote_rounded,
                  color: Color(0xFF8B5CF6), size: 15),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Would you proceed with this agreement?',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  SizedBox(height: 2),
                  Text(
                      'Your response helps measure FinGuard\'s impact',
                      style: TextStyle(
                          color: Color(0xFF64748B), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Options
        Row(
          children: _options.map((opt) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: opt != _options.last ? 10 : 0),
                child: _optionButton(opt),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _optionButton(_Option opt) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _submit(opt.key),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: opt.color.withValues(alpha: 0.05),
            border:
                Border.all(color: opt.color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(opt.icon, color: opt.color, size: 22),
              const SizedBox(height: 6),
              Text(opt.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: opt.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmation() {
    final opt = _options.firstWhere(
        (o) => o.key == widget.result.userDecision,
        orElse: () => _options.first);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: opt.color.withValues(alpha: 0.12),
            border:
                Border.all(color: opt.color.withValues(alpha: 0.2)),
          ),
          child: Icon(opt.icon, color: opt.color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You selected: ${opt.label}',
                  style: TextStyle(
                      color: opt.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const SizedBox(height: 3),
              const Text(
                  'Thank you — your response has been recorded.',
                  style: TextStyle(
                      color: Color(0xFF64748B), fontSize: 11)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context
                .read<AnalysisProvider>()
                .setDecision(widget.result.id, '');
            // Setting empty string then null effectively resets
            widget.result.userDecision = null;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF1E1E2E),
            ),
            child: const Text('Change',
                style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}

class _Option {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const _Option({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}
