import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analysis_provider.dart';
import '../models/analysis_result.dart';
import '../widgets/finguard_logo.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  bool _compareMode = false;
  final Set<String> _selectedIds = {};
  bool _tipDismissed = false;

  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _pulseAnim = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    final provider = context.read<AnalysisProvider>();
    Future.microtask(() => provider.fetchHistory());
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _toggleCompareMode() {
    setState(() {
      _compareMode = !_compareMode;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else if (_selectedIds.length < 2) {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Consumer<AnalysisProvider>(
            builder: (context, provider, _) {
              if (provider.historyLoading && provider.history.isEmpty) {
                return _loadingView();
              }
              if (provider.history.isEmpty) {
                return _emptyView();
              }
              return _historyList(provider);
            },
          ),
          if (_compareMode)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: _buildCompareBar(context),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_compareMode) {
                _toggleCompareMode();
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              _compareMode
                  ? Icons.close_rounded
                  : Icons.arrow_back_rounded,
              color: const Color(0xFF94A3B8),
              size: 20,
            ),
            splashRadius: 18,
          ),
          const SizedBox(width: 4),
          const FinGuardLogo(size: 24),
          const SizedBox(width: 10),
          Text(
            _compareMode ? 'Select 2 to Compare' : 'Analysis History',
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white),
          ),
          const Spacer(),
          if (!_compareMode)
            Consumer<AnalysisProvider>(
              builder: (context, provider, _) {
                if (provider.history.length < 2) return const SizedBox();
                return _compareButton();
              },
            ),
          if (_compareMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                '${_selectedIds.length}/2',
                style: TextStyle(
                  color: _selectedIds.length == 2
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _compareButton() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        final glow = _pulseAnim.value;
        return GestureDetector(
          onTap: _toggleCompareMode,
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulse ring
                Container(
                  width: 130,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Color.lerp(
                        const Color(0xFF8B5CF6).withValues(alpha: 0.0),
                        const Color(0xFF8B5CF6).withValues(alpha: 0.55),
                        glow,
                      )!,
                      width: 1.5,
                    ),
                  ),
                ),
                // Inner button
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.lerp(
                          const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.55),
                          glow,
                        )!,
                        blurRadius: 8 + glow * 14,
                        spreadRadius: glow * 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.compare_arrows_rounded,
                          color: Colors.white, size: 15),
                      SizedBox(width: 6),
                      Text('Compare',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompareBar(BuildContext context) {
    final ready = _selectedIds.length == 2;
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: ready
                ? [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]
                : [const Color(0xFF1E1E2E), const Color(0xFF14141F)],
          ),
          border: Border.all(
            color: ready
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
                : const Color(0xFF2A2A3E),
          ),
          boxShadow: [
            BoxShadow(
              color: ready
                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ready ? Icons.compare_rounded : Icons.touch_app_rounded,
              color: ready ? Colors.white : const Color(0xFF64748B),
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              ready
                  ? 'Compare Selected (2)'
                  : 'Select ${2 - _selectedIds.length} more to compare',
              style: TextStyle(
                color: ready ? Colors.white : const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (ready) ...[
              const Spacer(),
              GestureDetector(
                onTap: () => _navigateToComparison(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: const Text(
                    'Compare →',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToComparison(BuildContext context) {
    final provider = context.read<AnalysisProvider>();
    final selected = provider.history
        .where((r) => _selectedIds.contains(r.id))
        .toList();
    if (selected.length == 2) {
      Navigator.pushNamed(
        context,
        '/analysis/compare',
        arguments: selected,
      );
    }
  }

  Widget _loadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              backgroundColor: Color(0xFF2A2A3E),
            ),
          ),
          SizedBox(height: 16),
          Text('Loading history...',
              style:
                  TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E1E2E),
              border: Border.all(color: const Color(0xFF2A2A3E)),
            ),
            child: const Icon(Icons.history_rounded,
                size: 40, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 20),
          const Text('No analyses yet',
              style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(height: 6),
          const Text('Your contract analyses will appear here',
              style:
                  TextStyle(color: Color(0xFF475569), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _historyList(AnalysisProvider provider) {
    final showTip =
        !_compareMode && !_tipDismissed && provider.history.length >= 2;
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 12, 16, _compareMode ? 100 : 16),
      itemCount: provider.history.length + (showTip ? 1 : 0),
      itemBuilder: (context, index) {
        if (showTip && index == 0) return _tipBanner();
        final result =
            provider.history[index - (showTip ? 1 : 0)];
        return _historyCard(context, result, provider);
      },
    );
  }

  Widget _tipBanner() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, _) {
        final glow = _pulseAnim.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B5CF6).withValues(alpha: 0.10),
                const Color(0xFF7C3AED).withValues(alpha: 0.04),
              ],
            ),
            border: Border.all(
              color: Color.lerp(
                const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                const Color(0xFF8B5CF6).withValues(alpha: 0.42),
                glow,
              )!,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                ),
                child: const Icon(Icons.compare_arrows_rounded,
                    color: Color(0xFF8B5CF6), size: 14),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Compare two agreements',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 1),
                    Text(
                        'Tap the Compare button above to select 2 contracts and see a side-by-side analysis.',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _tipDismissed = true),
                child: const Icon(Icons.close_rounded,
                    color: Color(0xFF475569), size: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _historyCard(
      BuildContext context, AnalysisResult result, AnalysisProvider provider) {
    final riskColor = _riskColor(result.riskScores.riskLevel);
    final decision = result.userDecision;
    final decisionMeta = _decisionMeta(decision);
    final isSelected = _selectedIds.contains(result.id);
    final isDisabled =
        _compareMode && !isSelected && _selectedIds.length >= 2;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isDisabled ? 0.35 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                    const Color(0xFF7C3AED).withValues(alpha: 0.06),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF14141F), Color(0xFF0F0F18)],
                ),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.50)
                : const Color(0xFF1E1E2E),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
                  : riskColor.withValues(alpha: 0.04),
              blurRadius: isSelected ? 20 : 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: isDisabled
                ? null
                : () {
                    if (_compareMode) {
                      _toggleSelection(result.id);
                    } else {
                      provider.selectResult(result);
                      Navigator.pushNamed(context, '/result');
                    }
                  },
            child: Column(
              children: [
                // Top accent bar
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [
                              const Color(0xFF8B5CF6),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                            ]
                          : [
                              riskColor,
                              riskColor.withValues(alpha: 0.1),
                            ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Checkbox in compare mode, else score circle
                      if (_compareMode)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFF475569),
                              width: 2,
                            ),
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                              : null,
                        )
                      else
                        Container(
                          width: 52,
                          height: 52,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                riskColor.withValues(alpha: 0.15),
                                riskColor.withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border.all(
                                color: riskColor.withValues(alpha: 0.20)),
                          ),
                          child: Center(
                            child: Text(
                              '${result.riskScores.overallRiskScore}',
                              style: TextStyle(
                                  color: riskColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                          ),
                        ),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(result.agreementType,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                              result.plainLanguageSummary.length > 80
                                  ? '${result.plainLanguageSummary.substring(0, 80)}...'
                                  : result.plainLanguageSummary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Badges column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: riskColor.withValues(alpha: 0.10),
                              border: Border.all(
                                  color: riskColor.withValues(alpha: 0.20)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                    _riskIcon(result.riskScores.riskLevel),
                                    color: riskColor,
                                    size: 11),
                                const SizedBox(width: 4),
                                Text(result.riskScores.riskLevel,
                                    style: TextStyle(
                                        color: riskColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                          if (decisionMeta != null) ...[
                            const SizedBox(height: 8),
                            _decisionBadge(decisionMeta),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _decisionBadge(_DecisionMeta meta) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: meta.color.withValues(alpha: 0.08),
        border: Border.all(color: meta.color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, color: meta.color, size: 10),
          const SizedBox(width: 4),
          Text(meta.label,
              style: TextStyle(
                  color: meta.color,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  _DecisionMeta? _decisionMeta(String? decision) {
    if (decision == null || decision.isEmpty) return null;
    switch (decision) {
      case 'proceed':
        return const _DecisionMeta(
          icon: Icons.check_circle_rounded,
          color: Color(0xFF22C55E),
          label: 'Proceeded',
        );
      case 'reconsider':
        return const _DecisionMeta(
          icon: Icons.pause_circle_rounded,
          color: Color(0xFFF59E0B),
          label: 'Reconsidering',
        );
      case 'negotiate':
        return const _DecisionMeta(
          icon: Icons.handshake_rounded,
          color: Color(0xFF3B82F6),
          label: 'Negotiating',
        );
      default:
        return null;
    }
  }

  Color _riskColor(String level) {
    switch (level) {
      case 'High':
        return const Color(0xFFEF4444);
      case 'Medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF22C55E);
    }
  }

  IconData _riskIcon(String level) {
    switch (level) {
      case 'High':
        return Icons.dangerous_rounded;
      case 'Medium':
        return Icons.warning_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}

class _DecisionMeta {
  final IconData icon;
  final Color color;
  final String label;

  const _DecisionMeta({
    required this.icon,
    required this.color,
    required this.label,
  });
}
