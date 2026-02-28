// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/analysis_result.dart';
import '../services/api_service.dart';
import 'perspective_card.dart';

enum _AudioState { idle, loading, ready, error }

/// Renders the Defender vs Protector debate as an interactive podcast.
///
/// • If [result.debateTranscript] is populated: shows the alternating
///   turn-by-turn transcript with a play button that synthesises Neural2
///   TTS voices and plays them back with active-turn highlighting.
///
/// • If [result.debateTranscript] is null / empty (older analyses):
///   falls back to the original side-by-side PerspectiveCard layout.
class DebatePodcast extends StatefulWidget {
  final AnalysisResult result;
  const DebatePodcast({super.key, required this.result});

  @override
  State<DebatePodcast> createState() => _DebatePodcastState();
}

class _DebatePodcastState extends State<DebatePodcast>
    with SingleTickerProviderStateMixin {
  _AudioState _audioState = _AudioState.idle;
  List<Map<String, dynamic>> _timings = [];
  int _activeTurnIndex = -1;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _errorMessage;

  late final html.AudioElement _audio;
  Timer? _positionTimer;
  late final AnimationController _waveController;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _turnKeys = [];

  AnalysisResult get result => widget.result;

  @override
  void initState() {
    super.initState();

    final count = result.debateTranscript?.length ?? 0;
    _turnKeys.addAll(List.generate(count, (_) => GlobalKey()));

    _audio = html.AudioElement();
    _audio.crossOrigin = 'anonymous';

    _audio.onPlay.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = true);
      _startPositionTracking();
    });

    _audio.onPause.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      _positionTimer?.cancel();
    });

    _audio.onEnded.listen((_) {
      if (!mounted) return;
      _positionTimer?.cancel();
      setState(() {
        _isPlaying = false;
        _activeTurnIndex = -1;
        _position = Duration.zero;
      });
    });

    _audio.onDurationChange.listen((_) {
      if (!mounted) return;
      final d = _audio.duration;
      if (d.isNaN || d.isInfinite) return;
      setState(() => _duration = Duration(milliseconds: (d * 1000).round()));
    });

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _audio.pause();
    _waveController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Position tracking ──────────────────────────────────────────────────────

  void _startPositionTracking() {
    _positionTimer?.cancel();
    _positionTimer =
        Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) return;
      final posMs = (_audio.currentTime * 1000).round();
      setState(() {
        _position = Duration(milliseconds: posMs);
        _updateActiveTurn(posMs);
      });
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _updateActiveTurn(int posMs) {
    if (_timings.isEmpty) return;
    int newActive = -1;
    for (int i = 0; i < _timings.length; i++) {
      final t = _timings[i];
      if (posMs >= (t['startMs'] as int) && posMs < (t['endMs'] as int)) {
        newActive = i;
        break;
      }
    }
    if (newActive != _activeTurnIndex) {
      _activeTurnIndex = newActive;
      _scrollToActiveTurn();
    }
  }

  void _scrollToActiveTurn() {
    if (_activeTurnIndex < 0 || _activeTurnIndex >= _turnKeys.length) return;
    final key = _turnKeys[_activeTurnIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.35,
        );
      }
    });
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _generateAndPlay() async {
    setState(() {
      _audioState = _AudioState.loading;
      _errorMessage = null;
    });
    try {
      final res = await ApiService().generateDebateAudio(
        analysisId: result.id,
        debateTranscript: result.debateTranscript ?? [],
      );
      // Use base64 data URL to avoid CORS issues with Storage URLs
      final audioBase64 = res['audioBase64'] as String?;
      if (audioBase64 == null || audioBase64.isEmpty) {
        throw Exception('No audio data returned from server');
      }
      _timings = List<Map<String, dynamic>>.from(
        (res['timings'] as List<dynamic>?) ?? [],
      );
      _audio.src = audioBase64;
      if (mounted) setState(() => _audioState = _AudioState.ready);
      FirebaseAnalytics.instance.logEvent(
        name: 'podcast_played',
        parameters: {'agreement_type': result.agreementType},
      );
      // Auto-play after loading
      await _audio.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _audioState = _AudioState.error;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_audioState == _AudioState.idle) {
      await _generateAndPlay();
    } else if (_isPlaying) {
      _audio.pause();
    } else if (_audioState == _AudioState.ready) {
      await _audio.play();
    }
  }

  Future<void> _seek(double fraction) async {
    if (_duration.inMilliseconds == 0) return;
    final secs = fraction * _duration.inMilliseconds / 1000.0;
    _audio.currentTime = secs;
    setState(() {
      _position = Duration(milliseconds: (secs * 1000).round());
    });
  }

  Future<void> _restart() async {
    _audio.currentTime = 0;
    setState(() {
      _position = Duration.zero;
      _activeTurnIndex = -1;
    });
    await _audio.play();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final transcript = result.debateTranscript;

    if (transcript == null || transcript.isEmpty) {
      return _LegacyPerspectives(result: result);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1035), Color(0xFF0F0D18)],
        ),
        border: Border.all(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.09),
            blurRadius: 28,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFFF97316)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildTranscript(transcript),
                const SizedBox(height: 16),
                _buildAudioSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
            ),
          ),
          child: const Icon(Icons.podcasts_rounded,
              color: Colors.white, size: 15),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Financial Debate Podcast',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Text('AI voices debate the terms of your agreement',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFFF97316)],
            ),
          ),
          child: const Text('LIVE DEBATE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
        ),
      ],
    );
  }

  // ── Transcript ─────────────────────────────────────────────────────────────

  Widget _buildTranscript(List<DebateTurn> turns) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 360),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF09090F),
        border: Border.all(color: const Color(0xFF1E1E2E)),
      ),
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: turns.length,
        itemBuilder: (_, i) => _buildTurnItem(turns[i], i),
      ),
    );
  }

  Widget _buildTurnItem(DebateTurn turn, int index) {
    final isDefender = turn.speaker == 'defender';
    final isActive = index == _activeTurnIndex;
    final color =
        isDefender ? const Color(0xFF3B82F6) : const Color(0xFFF97316);
    final icon =
        isDefender ? Icons.account_balance_rounded : Icons.shield_rounded;
    final label = isDefender ? 'Defender' : 'Protector';

    return AnimatedContainer(
      key: _turnKeys[index],
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isActive ? color.withValues(alpha: 0.08) : Colors.transparent,
        border: Border.all(
          color:
              isActive ? color.withValues(alpha: 0.30) : Colors.transparent,
        ),
        boxShadow: isActive
            ? [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 12)]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.14),
              border: Border.all(color: color.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, size: 13, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(label,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.5)),
                  if (isActive) ...[
                    const SizedBox(width: 6),
                    _SpeakingBars(
                        color: color, controller: _waveController),
                  ],
                ]),
                const SizedBox(height: 4),
                Text(turn.message,
                    style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 12,
                        height: 1.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Audio section ──────────────────────────────────────────────────────────

  Widget _buildAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 1,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xFF2A2A3E).withValues(alpha: 0.0),
              const Color(0xFF2A2A3E),
              const Color(0xFF2A2A3E).withValues(alpha: 0.0),
            ]),
          ),
        ),
        if (_audioState == _AudioState.error) _buildErrorState(),
        if (_audioState != _AudioState.error) _buildPlayerRow(),
      ],
    );
  }

  /// Unified centered layout: play button on top, controls below.
  Widget _buildPlayerRow() {
    final isLoading = _audioState == _AudioState.loading;
    final isReady = _audioState == _AudioState.ready;
    final progress = isReady && _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Waveform (only while playing)
        if (_isPlaying) ...[
          _Waveform(controller: _waveController),
          const SizedBox(height: 12),
        ],

        // ── Centered play/pause/loading button ──
        GestureDetector(
          onTap: isLoading ? null : _togglePlayPause,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isLoading
                  ? const LinearGradient(
                      colors: [Color(0xFF3B3B5E), Color(0xFF2A2A3E)])
                  : const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
              boxShadow: isLoading
                  ? null
                  : [
                      BoxShadow(
                        color:
                            const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF8B5CF6)),
                    ),
                  )
                : Icon(
                    isReady && _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Status text (idle / loading) ──
        if (!isReady) ...[
          Text(
            isLoading
                ? 'Generating AI voices…'
                : 'Tap to listen to the AI debate',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],

        // ── Player controls (ready state) ──
        if (isReady) ...[
          // Speaker legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _speakerChip('Defender', const Color(0xFF3B82F6),
                  Icons.account_balance_rounded),
              const SizedBox(width: 8),
              _speakerChip('Protector', const Color(0xFFF97316),
                  Icons.shield_rounded),
            ],
          ),
          const SizedBox(height: 10),

          // Progress bar
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: const Color(0xFF8B5CF6),
              inactiveTrackColor: const Color(0xFF2A2A3E),
              thumbColor: const Color(0xFF8B5CF6),
              overlayColor:
                  const Color(0xFF8B5CF6).withValues(alpha: 0.12),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: progress.toDouble(),
              onChanged: _seek,
            ),
          ),

          // Time + restart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_fmt(_position)} / ${_fmt(_duration)}',
                style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    fontFeatures: [FontFeature.tabularFigures()]),
              ),
              GestureDetector(
                onTap: _restart,
                child: const Icon(Icons.replay_rounded,
                    size: 16, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _generateAndPlay,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Audio generation failed',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
        if (_errorMessage != null) ...[
          const SizedBox(height: 4),
          Text(_errorMessage!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
        ],
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _generateAndPlay,
          child: const Text('Tap to retry',
              style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _speakerChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// =============================================================================
// ANIMATED WAVEFORM  — 22 bars with staggered animation
// =============================================================================
class _Waveform extends StatelessWidget {
  final AnimationController controller;
  const _Waveform({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(22, (i) {
              final phase = i * 0.14;
              final v = ((controller.value + phase) % 1.0);
              final h = 4.0 + (v * 18.0);
              final isLeft = i < 11;
              final color = isLeft
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFFF97316);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                width: 3,
                height: h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5),
                  color: color.withValues(alpha: 0.75),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// =============================================================================
// SPEAKING BARS  — tiny 3-bar animation shown next to the active speaker label
// =============================================================================
class _SpeakingBars extends StatelessWidget {
  final Color color;
  final AnimationController controller;
  const _SpeakingBars({required this.color, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          final v = ((controller.value + i * 0.25) % 1.0);
          return Container(
            margin: const EdgeInsets.only(right: 1.5),
            width: 2,
            height: 4.0 + v * 6.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: color,
            ),
          );
        }),
      ),
    );
  }
}

// =============================================================================
// LEGACY FALLBACK  — shown when debate_transcript is absent (older analyses)
// =============================================================================
class _LegacyPerspectives extends StatelessWidget {
  final AnalysisResult result;
  const _LegacyPerspectives({required this.result});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final wide = constraints.maxWidth > 600;
      if (wide) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PerspectiveCard(
                  title: 'Defender',
                  subtitle: 'Lender Perspective',
                  icon: Icons.account_balance_rounded,
                  color: const Color(0xFF3B82F6),
                  content: result.defenderAnalysis,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: PerspectiveCard(
                  title: 'Protector',
                  subtitle: 'Borrower Perspective',
                  icon: Icons.shield_rounded,
                  color: const Color(0xFFF97316),
                  content: result.protectorAnalysis,
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: [
          PerspectiveCard(
            title: 'Defender',
            subtitle: 'Lender Perspective',
            icon: Icons.account_balance_rounded,
            color: const Color(0xFF3B82F6),
            content: result.defenderAnalysis,
          ),
          const SizedBox(height: 20),
          PerspectiveCard(
            title: 'Protector',
            subtitle: 'Borrower Perspective',
            icon: Icons.shield_rounded,
            color: const Color(0xFFF97316),
            content: result.protectorAnalysis,
          ),
        ],
      );
    });
  }
}
