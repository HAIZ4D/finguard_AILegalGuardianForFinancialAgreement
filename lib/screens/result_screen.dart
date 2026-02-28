import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/analysis_provider.dart';
import '../models/analysis_result.dart';
import '../widgets/animated_gauge.dart';
import '../widgets/risk_gauge.dart';
import '../widgets/clause_card.dart';
import '../widgets/debate_podcast.dart';
import '../widgets/simulation_timeline.dart';
import '../widgets/decision_badge.dart';
import '../widgets/dti_calculator.dart';
import '../widgets/repayment_breakdown.dart';
import '../widgets/recommended_actions.dart';
import '../widgets/finguard_logo.dart';
import '../widgets/score_transparency.dart';
import '../widgets/worst_case_panel.dart';
import '../widgets/interest_insight.dart';
import '../widgets/decision_tracker.dart';
import '../widgets/agreement_chat_panel.dart';
import '../utils/financial_calculator.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<AnalysisProvider>(
        builder: (context, provider, _) {
          if (provider.state == AnalysisState.loading) {
            return _buildLoadingView();
          }
          if (provider.state == AnalysisState.error) {
            return _buildErrorView(context, provider.errorMessage);
          }
          final result = provider.result;
          if (result == null) {
            return const Center(
                child: Text('No analysis data',
                    style: TextStyle(color: Color(0xFF64748B))));
          }
          return _DashboardBody(result: result);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      title: Row(
        children: [
          const FinGuardLogo(size: 28),
          const SizedBox(width: 10),
          const Text('FinGuard',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white)),
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            ),
            child: const Text('Analysis Report',
                style: TextStyle(
                    color: Color(0xFFA78BFA),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      actions: [
        _appBarAction(
          icon: Icons.history_rounded,
          tooltip: 'History',
          onPressed: () => Navigator.pushNamed(context, '/history'),
        ),
        _appBarAction(
          icon: Icons.add_rounded,
          tooltip: 'New Analysis',
          onPressed: () {
            context.read<AnalysisProvider>().reset();
            Navigator.pushNamed(context, '/upload');
          },
        ),
        _appBarAction(
          icon: Icons.home_rounded,
          tooltip: 'Home',
          onPressed: () {
            context.read<AnalysisProvider>().reset();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _appBarAction(
      {required IconData icon,
      required String tooltip,
      required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF12121E),
        border: Border.all(color: const Color(0xFF1E1E2E)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFF94A3B8), size: 16),
        tooltip: tooltip,
        splashRadius: 18,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              backgroundColor: const Color(0xFF2A2A3E),
            ),
          ),
          const SizedBox(height: 24),
          const Text('FinGuard AI is analyzing...',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
              'Extracting clauses, simulating risks, scoring dangers',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            const Text('Analysis Failed',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 8),
            Text(message ?? 'An unexpected error occurred',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFA78BFA),
                side: const BorderSide(color: Color(0xFF2A2A3E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DASHBOARD BODY
// =============================================================================
class _DashboardBody extends StatefulWidget {
  final AnalysisResult result;
  const _DashboardBody({required this.result});

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  double? _dtiRatio;
  bool _chatOpen = false;
  Offset _bubbleOffset = const Offset(20, 400);

  AnalysisResult get result => widget.result;

  bool _isWide(BoxConstraints c) => c.maxWidth > 1000;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = _isWide(constraints);
        final hPad = wide ? 32.0 : 16.0;

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0D0B16), Color(0xFF080810)],
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
                child: Column(
              children: [
                // ── ROW 1: Hero Risk Overview ──
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: _heroSection(wide),
                ),
                const SizedBox(height: 16),

                // ── ROW 1b: Financial Debate Podcast ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 200),
                  child: DebatePodcast(result: result),
                ),
                const SizedBox(height: 24),

                // ── ROW 2: Clauses + AI Summary ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 250),
                  child: _row(
                    wide: wide,
                    left: _clausesCard(),
                    right: _summaryCard(),
                  ),
                ),
                const SizedBox(height: 20),

                // ── ROW 3: Interest Insight + Worst-Case ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 350),
                  child: _row(
                    wide: wide,
                    left: InterestInsight(
                        clauses: result.extractedClauses,
                        agreementType: result.agreementType,
                        basePovertyScore:
                            result.riskScores.povertyVulnerabilityScore),
                    right: WorstCasePanel(result: result),
                  ),
                ),
                const SizedBox(height: 20),

                // ── ROW 4: DTI Calculator + Repayment Breakdown ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 450),
                  child: _row(
                    wide: wide,
                    left: DtiCalculator(
                      clauses: result.extractedClauses,
                      povertyScore:
                          result.riskScores.povertyVulnerabilityScore,
                      onDtiChanged: (v) => setState(() => _dtiRatio = v),
                    ),
                    right: RepaymentBreakdown(
                        clauses: result.extractedClauses),
                  ),
                ),
                const SizedBox(height: 20),

                // ── ROW 5: Recommended Actions (full width) ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 550),
                  child: RecommendedActions(
                    result: result,
                    dtiRatio: _dtiRatio,
                  ),
                ),
                const SizedBox(height: 20),

                // ── ROW 6: Risk Simulation + Detected Risks ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 850),
                  child: _row(
                    wide: wide,
                    left: _simulationCard(),
                    right: result.detectedRisks.isNotEmpty
                        ? _detectedRisksCard()
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // ── ROW 9: Decision Impact Tracker ──
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 1050),
                  child: DecisionTracker(result: result),
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
        _buildFloatingBubble(constraints),
        if (_chatOpen) _buildChatOverlay(constraints),
      ],
    );
      },
    );
  }

  Widget _row({
    required bool wide,
    required Widget left,
    Widget? right,
    int leftFlex = 1,
    int rightFlex = 1,
  }) {
    if (!wide || right == null) {
      return Column(
        children: [
          left,
          if (right != null) ...[const SizedBox(height: 20), right],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: leftFlex, child: left),
          const SizedBox(width: 20),
          Expanded(flex: rightFlex, child: right),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HERO SECTION — Animated gauge + risk bars + decorative orbs
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _heroSection(bool wide) {
    final riskColor = _riskColor(result.riskScores.riskLevel);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C1240),
            Color(0xFF130F22),
            Color(0xFF0D0B15),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF2A1F5E).withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
            blurRadius: 48,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: riskColor.withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative gradient orbs ──
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    riskColor.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 36 : 20,
              vertical: wide ? 32 : 24,
            ),
            child: wide ? _heroWide(riskColor) : _heroNarrow(riskColor),
          ),
        ],
      ),
    );
  }

  Widget _heroWide(Color riskColor) {
    return Row(
      children: [
        // Left: Animated gauge + labels
        Expanded(
          flex: 2,
          child: Column(
            children: [
              ZoomIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 300),
                child: AnimatedGauge(
                  score: result.riskScores.overallRiskScore,
                  color: riskColor,
                  size: 180,
                ),
              ),
              const SizedBox(height: 16),
              _heroLabels(riskColor),
            ],
          ),
        ),

        // Gradient divider
        Container(
          width: 1,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF2A1F5E).withValues(alpha: 0.0),
                const Color(0xFF2A1F5E).withValues(alpha: 0.6),
                const Color(0xFF2A1F5E).withValues(alpha: 0.0),
              ],
            ),
          ),
        ),

        // Right: Risk gauges
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('RISK BREAKDOWN',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  )),
              const SizedBox(height: 20),
              RiskGauge(
                  label: 'Legal Risk',
                  score: result.riskScores.legalRiskScore,
                  icon: Icons.gavel_rounded),
              const SizedBox(height: 18),
              RiskGauge(
                  label: 'Financial Burden',
                  score: result.riskScores.financialBurdenScore,
                  icon: Icons.account_balance_wallet_rounded),
              const SizedBox(height: 18),
              RiskGauge(
                  label: 'Poverty Vulnerability',
                  score: result.riskScores.povertyVulnerabilityScore,
                  icon: Icons.people_rounded,
                  sdgLabel: 'SDG 1'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroNarrow(Color riskColor) {
    return Column(
      children: [
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 300),
          child: AnimatedGauge(
            score: result.riskScores.overallRiskScore,
            color: riskColor,
            size: 160,
          ),
        ),
        const SizedBox(height: 16),
        _heroLabels(riskColor),
        const SizedBox(height: 24),
        _heroGradientDivider(),
        const SizedBox(height: 24),
        RiskGauge(
            label: 'Legal Risk',
            score: result.riskScores.legalRiskScore,
            icon: Icons.gavel_rounded),
        const SizedBox(height: 16),
        RiskGauge(
            label: 'Financial Burden',
            score: result.riskScores.financialBurdenScore,
            icon: Icons.account_balance_wallet_rounded),
        const SizedBox(height: 16),
        RiskGauge(
            label: 'Poverty Vulnerability',
            score: result.riskScores.povertyVulnerabilityScore,
            icon: Icons.people_rounded,
            sdgLabel: 'SDG 1'),
      ],
    );
  }

  Widget _heroLabels(Color riskColor) {
    return Column(
      children: [
        // Risk level badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                riskColor.withValues(alpha: 0.15),
                riskColor.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: riskColor.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: riskColor.withValues(alpha: 0.15),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_riskIcon(result.riskScores.riskLevel),
                  color: riskColor, size: 14),
              const SizedBox(width: 6),
              Text('${result.riskScores.riskLevel} Risk',
                  style: TextStyle(
                      color: riskColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Decision badge
        DecisionBadge(
            overallRiskScore: result.riskScores.overallRiskScore),
        const SizedBox(height: 10),
        // Agreement type + status
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_rounded,
                size: 12, color: Color(0xFF64748B)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(result.agreementType,
                  style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34D399),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34D399).withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Text('Complete',
                style: TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 12),
        // Score transparency popup button
        GestureDetector(
          onTap: _showScoreDialog,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
              border: Border.all(
                  color:
                      const Color(0xFF8B5CF6).withValues(alpha: 0.22)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics_rounded,
                    color: Color(0xFF8B5CF6), size: 12),
                SizedBox(width: 6),
                Text('How is this score calculated?',
                    style: TextStyle(
                        color: Color(0xFFA78BFA),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 4),
                Icon(Icons.open_in_new_rounded,
                    color: Color(0xFF8B5CF6), size: 11),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _heroGradientDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A1F5E).withValues(alpha: 0.0),
            const Color(0xFF2A1F5E).withValues(alpha: 0.5),
            const Color(0xFF2A1F5E).withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AI SUMMARY (purple accent)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _summaryCard() {
    return _Card(
      glowColor: const Color(0xFF8B5CF6),
      accentColor: const Color(0xFF8B5CF6),
      gradientColors: const [Color(0xFF16102A), Color(0xFF0F0D18)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _CardIcon(
                  icon: Icons.auto_awesome, color: Color(0xFF8B5CF6)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('AI Summary',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.08),
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
                        color: const Color(0xFFA78BFA),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFA78BFA)
                                .withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('AI Generated',
                        style: TextStyle(
                            color: Color(0xFFA78BFA),
                            fontSize: 10,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SummaryBody(summary: result.plainLanguageSummary),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EXTRACTED CLAUSES
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _clausesCard() {
    return _Card(
      glowColor: const Color(0xFF06B6D4),
      accentColor: const Color(0xFF06B6D4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _CardIcon(
                  icon: Icons.article_rounded, color: Color(0xFF06B6D4)),
              const SizedBox(width: 12),
              const Text('Extracted Clauses',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 18),
          ClauseCard(clauses: result.extractedClauses),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RISK SIMULATION
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _simulationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF97316).withValues(alpha: 0.15),
                      const Color(0xFFF97316).withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: const Icon(Icons.timeline_rounded,
                    size: 14, color: Color(0xFFF97316)),
              ),
              const SizedBox(width: 8),
              const Text('Risk Simulation',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFF97316).withValues(alpha: 0.08),
                ),
                child: const Text('What-If',
                    style: TextStyle(
                        color: Color(0xFFF97316),
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        SimulationTimeline(simulation: result.narrativeSimulation),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DETECTED RISKS (amber accent)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _detectedRisksCard() {
    return _Card(
      glowColor: const Color(0xFFF59E0B),
      accentColor: const Color(0xFFF59E0B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _CardIcon(
                  icon: Icons.warning_amber_rounded,
                  color: Color(0xFFF59E0B)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Detected Risks',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF59E0B).withValues(alpha: 0.18),
                      const Color(0xFFF59E0B).withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: Text('${result.detectedRisks.length}',
                    style: const TextStyle(
                        color: Color(0xFFFBBF24),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...result.detectedRisks.asMap().entries.map((entry) {
            final isLast = entry.key == result.detectedRisks.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFBBF24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFBBF24)
                              .withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(entry.value,
                        style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 12,
                            height: 1.6)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  // ── Floating chat bubble ────────────────────────────────────────────────────

  Widget _buildFloatingBubble(BoxConstraints c) {
    return Positioned(
      left: _bubbleOffset.dx.clamp(0, c.maxWidth - 90),
      top: _bubbleOffset.dy.clamp(0, c.maxHeight - 90),
      child: GestureDetector(
        onPanUpdate: (d) => setState(() {
          _bubbleOffset = Offset(
            (_bubbleOffset.dx + d.delta.dx).clamp(0, c.maxWidth - 90),
            (_bubbleOffset.dy + d.delta.dy).clamp(0, c.maxHeight - 90),
          );
        }),
        onTap: () => setState(() => _chatOpen = !_chatOpen),
        child: _RobotAvatar(isOpen: _chatOpen),
      ),
    );
  }

  Widget _buildChatOverlay(BoxConstraints c) {
    const panelW = 380.0;
    const panelH = 520.0;
    final isRight = _bubbleOffset.dx > c.maxWidth / 2;
    final left = isRight
        ? (_bubbleOffset.dx - panelW - 8).clamp(8.0, c.maxWidth - panelW - 8)
        : (_bubbleOffset.dx + 72).clamp(8.0, c.maxWidth - panelW - 8);
    final top = (_bubbleOffset.dy - panelH / 2 + 35)
        .clamp(8.0, c.maxHeight - panelH - 8);

    return Positioned(
      left: left,
      top: top,
      width: panelW,
      height: panelH,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1035), Color(0xFF0F0D18)],
            ),
            border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.22),
                blurRadius: 40,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                // Header bar
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                        const Color(0xFF6366F1).withValues(alpha: 0.08),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                          color: const Color(0xFF8B5CF6)
                              .withValues(alpha: 0.20)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B5CF6),
                              Color(0xFF6366F1)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.smart_toy_rounded,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FinGuard AI',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                            Text('Ask about this agreement',
                                style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _chatOpen = false),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFF2A2A3E),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Color(0xFF94A3B8), size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                // Chat content
                Expanded(
                  child: AgreementChatPanel(result: result),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 600, maxHeight: 580),
          child: SingleChildScrollView(
            child: ScoreTransparency(
                result: result, initiallyExpanded: true),
          ),
        ),
      ),
    );
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

// =============================================================================
// SUMMARY BODY — bullet key insights + expandable detail
// =============================================================================
class _SummaryBody extends StatefulWidget {
  final String summary;
  const _SummaryBody({required this.summary});

  @override
  State<_SummaryBody> createState() => _SummaryBodyState();
}

class _SummaryBodyState extends State<_SummaryBody> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bullets = FinancialCalculator.extractKeyInsights(widget.summary);
    final remaining = FinancialCalculator.remainingSummary(widget.summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key insights label
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA78BFA),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.5),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Text('Key Insights',
                style: TextStyle(
                    color: Color(0xFFA78BFA),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.3)),
          ],
        ),
        const SizedBox(height: 12),

        // Bullet points
        ...bullets.map((sentence) => Padding(
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
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(sentence,
                        style: const TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 12,
                            height: 1.6,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            )),

        // Expandable detail
        if (remaining.isNotEmpty) ...[
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(remaining,
                  style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      height: 1.7,
                      fontSize: 12)),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _expanded ? 'Show less' : 'Read full summary',
                  style: const TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w600,
                      fontSize: 11),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF8B5CF6),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// REUSABLE CARD — hover effect, gradient bg, accent bar, glow
// =============================================================================
class _Card extends StatefulWidget {
  final Widget child;
  final Color? glowColor;
  final Color? accentColor;
  final List<Color>? gradientColors;

  const _Card({
    required this.child,
    this.glowColor,
    this.accentColor,
    this.gradientColors,
  });

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor;
    final hoverBorder =
        glow?.withValues(alpha: 0.35) ?? const Color(0xFF2A2A3E);
    final restBorder =
        glow?.withValues(alpha: 0.18) ?? const Color(0xFF1E1E2E);

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
          gradient: widget.gradientColors != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.gradientColors!,
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF151520), Color(0xFF0F0F18)],
                ),
          border:
              Border.all(color: _hovering ? hoverBorder : restBorder),
          boxShadow: [
            BoxShadow(
              color: (glow ?? const Color(0xFF000000))
                  .withValues(alpha: _hovering ? 0.18 : 0.08),
              blurRadius: _hovering ? 36 : 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.accentColor != null)
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accentColor!,
                      widget.accentColor!.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ROBOT AVATAR — draggable floating chat bubble button
// =============================================================================
class _RobotAvatar extends StatefulWidget {
  final bool isOpen;
  const _RobotAvatar({required this.isOpen});

  @override
  State<_RobotAvatar> createState() => _RobotAvatarState();
}

class _RobotAvatarState extends State<_RobotAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        final glow = widget.isOpen ? 0.0 : _pulse.value * 0.35;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            if (!widget.isOpen)
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF8B5CF6)
                        .withValues(alpha: glow),
                    width: 2,
                  ),
                ),
              ),
            // Main button
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isOpen
                      ? [const Color(0xFF4F46E5), const Color(0xFF6366F1)]
                      : [
                          const Color(0xFF8B5CF6),
                          const Color(0xFF6366F1)
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6)
                        .withValues(alpha: widget.isOpen ? 0.25 : 0.50),
                    blurRadius: widget.isOpen ? 12 : 24,
                    spreadRadius: widget.isOpen ? 0 : 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.isOpen
                    ? Icons.close_rounded
                    : Icons.smart_toy_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            // "FinGuard AI" badge
            if (!widget.isOpen)
              Positioned(
                right: -6,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF34D399), Color(0xFF059669)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF34D399)
                            .withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Text('FinGuard AI',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3)),
                ),
              ),
          ],
        );
      },
    );
  }
}

// =============================================================================
// CARD ICON — gradient background with glow
// =============================================================================
class _CardIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _CardIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 15),
    );
  }
}
