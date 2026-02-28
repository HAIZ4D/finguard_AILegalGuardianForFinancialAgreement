import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/finguard_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeBody(),
    );
  }
}

// =============================================================================
// HOME BODY
// =============================================================================
class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Stack(
      children: [
        // ── Full-page dark gradient ──
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0E0B1A), Color(0xFF080810), Color(0xFF060608)],
            ),
          ),
        ),

        // ── Ambient gradient orbs ──
        Positioned(
          top: -140,
          right: -100,
          child: _GlowOrb(
            size: 420,
            color: const Color(0xFF8B5CF6),
            opacity: 0.10,
          ),
        ),
        Positioned(
          top: size.height * 0.35,
          left: -160,
          child: _GlowOrb(
            size: 350,
            color: const Color(0xFF6D28D9),
            opacity: 0.07,
          ),
        ),
        Positioned(
          bottom: -80,
          right: size.width * 0.25,
          child: _GlowOrb(
            size: 280,
            color: const Color(0xFF3B82F6),
            opacity: 0.05,
          ),
        ),

        // ── Grid pattern overlay ──
        Positioned.fill(
          child: CustomPaint(painter: _GridPainter()),
        ),

        // ── Content ──
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Nav bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? size.width * 0.1 : 20,
                    vertical: 16,
                  ),
                  child: _NavBar(isWide: isWide),
                ),

                SizedBox(height: isWide ? 72 : 44),

                // Hero
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? size.width * 0.1 : 24,
                  ),
                  child: _HeroSection(isWide: isWide),
                ),

                SizedBox(height: isWide ? 80 : 56),

                // How it works
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? size.width * 0.1 : 24,
                  ),
                  child: _HowItWorksSection(isWide: isWide),
                ),

                SizedBox(height: isWide ? 96 : 64),

                // SDG Alignment
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? size.width * 0.1 : 24,
                  ),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: _SdgSection(isWide: isWide),
                  ),
                ),

                SizedBox(height: isWide ? 80 : 56),

                // Footer
                _Footer(isWide: isWide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// GRID PATTERN PAINTER (subtle dot grid)
// =============================================================================
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1E2E).withValues(alpha: 0.4)
      ..strokeWidth = 1;

    const gap = 40.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// GLOW ORB
// =============================================================================
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// =============================================================================
// NAV BAR
// =============================================================================
class _NavBar extends StatelessWidget {
  final bool isWide;
  const _NavBar({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF0D0B16).withValues(alpha: 0.7),
          border: Border.all(
            color: const Color(0xFF1E1E2E).withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo
            const FinGuardLogo(size: 30),
            const SizedBox(width: 10),
            const Text('FinGuard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                )),
            if (isWide) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: const Text('v1.0',
                    style: TextStyle(
                        color: Color(0xFFA78BFA),
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],

            const Spacer(),

            // Nav actions
            _NavButton(
              icon: Icons.history_rounded,
              label: isWide ? 'History' : null,
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            const SizedBox(width: 8),
            _NavCtaButton(
              label: isWide ? 'Analyze' : null,
              onTap: () => Navigator.pushNamed(context, '/upload'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  const _NavButton({required this.icon, this.label, required this.onTap});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: _hovering
              ? const Color(0xFF1E1E2E)
              : const Color(0xFF12121E).withValues(alpha: 0.5),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF2A2A3E)
                : const Color(0xFF1A1A28),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(9),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.label != null ? 14 : 10,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon,
                      color: _hovering
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                      size: 15),
                  if (widget.label != null) ...[
                    const SizedBox(width: 6),
                    Text(widget.label!,
                        style: TextStyle(
                          color: _hovering
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCtaButton extends StatefulWidget {
  final String? label;
  final VoidCallback onTap;
  const _NavCtaButton({this.label, required this.onTap});

  @override
  State<_NavCtaButton> createState() => _NavCtaButtonState();
}

class _NavCtaButtonState extends State<_NavCtaButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          gradient: LinearGradient(
            colors: _hovering
                ? [const Color(0xFF8B5CF6), const Color(0xFF9D6FFF)]
                : [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6)
                  .withValues(alpha: _hovering ? 0.4 : 0.2),
              blurRadius: _hovering ? 16 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(9),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.label != null ? 16 : 10,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.document_scanner_rounded,
                      color: Colors.white, size: 15),
                  if (widget.label != null) ...[
                    const SizedBox(width: 6),
                    Text(widget.label!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HERO SECTION
// =============================================================================
class _HeroSection extends StatelessWidget {
  final bool isWide;
  const _HeroSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated shield with pulse ring
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: _PulsingShield(size: isWide ? 130.0 : 100.0),
        ),

        const SizedBox(height: 36),

        // Title
        FadeInDown(
          delay: const Duration(milliseconds: 300),
          duration: const Duration(milliseconds: 600),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFE2E8F0),
                Color(0xFFA78BFA),
              ],
              stops: [0.0, 0.6, 1.0],
            ).createShader(bounds),
            child: Text(
              'Your AI Financial\nGuardian',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWide ? 56 : 34,
                fontWeight: FontWeight.w800,
                height: 1.1,
                color: Colors.white,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Subtitle
        FadeInDown(
          delay: const Duration(milliseconds: 450),
          duration: const Duration(milliseconds: 500),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              'Understand your financial contracts before you sign. '
              'AI-powered clause extraction, risk scoring, and narrative '
              'simulation to protect your financial future.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: isWide ? 16 : 13.5,
                height: 1.7,
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // CTAs
        FadeInUp(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 500),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: [
              _PrimaryCta(
                label: 'Analyze Agreement',
                icon: Icons.document_scanner_rounded,
                onTap: () => Navigator.pushNamed(context, '/upload'),
                isWide: isWide,
              ),
              _SecondaryCta(
                label: 'View History',
                icon: Icons.history_rounded,
                onTap: () => Navigator.pushNamed(context, '/history'),
                isWide: isWide,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PULSING SHIELD (hero icon with animated ring)
// =============================================================================
class _PulsingShield extends StatefulWidget {
  final double size;
  const _PulsingShield({required this.size});

  @override
  State<_PulsingShield> createState() => _PulsingShieldState();
}

class _PulsingShieldState extends State<_PulsingShield>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + 40,
      height: widget.size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse ring
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = 1.0 + (_controller.value * 0.35);
              final opacity = (1.0 - _controller.value) * 0.25;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          const Color(0xFF8B5CF6).withValues(alpha: opacity),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Inner glow
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.03),
                  Colors.transparent,
                ],
              ),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // Shield logo
          FinGuardLogo(size: widget.size * 0.6),
        ],
      ),
    );
  }
}

// =============================================================================
// CTA BUTTONS
// =============================================================================
class _PrimaryCta extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isWide;

  const _PrimaryCta({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isWide,
  });

  @override
  State<_PrimaryCta> createState() => _PrimaryCtaState();
}

class _PrimaryCtaState extends State<_PrimaryCta> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.03 : 1.0, _hovering ? 1.03 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: _hovering
                ? [const Color(0xFF8B5CF6), const Color(0xFF9D6FFF)]
                : [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED)
                  .withValues(alpha: _hovering ? 0.5 : 0.3),
              blurRadius: _hovering ? 28 : 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWide ? 32 : 24,
                vertical: widget.isWide ? 16 : 14,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.isWide ? 15 : 14,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryCta extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isWide;

  const _SecondaryCta({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isWide,
  });

  @override
  State<_SecondaryCta> createState() => _SecondaryCtaState();
}

class _SecondaryCtaState extends State<_SecondaryCta> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.03 : 1.0, _hovering ? 1.03 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: _hovering
              ? const Color(0xFF1A1A2E)
              : const Color(0xFF12121E),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.3)
                : const Color(0xFF2A2A3E),
          ),
          boxShadow: [
            if (_hovering)
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWide ? 32 : 24,
                vertical: widget.isWide ? 16 : 14,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon,
                      color: _hovering
                          ? const Color(0xFFA78BFA)
                          : const Color(0xFF94A3B8),
                      size: 18),
                  const SizedBox(width: 10),
                  Text(widget.label,
                      style: TextStyle(
                        color: _hovering
                            ? const Color(0xFFA78BFA)
                            : const Color(0xFF94A3B8),
                        fontSize: widget.isWide ? 15 : 14,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HOW IT WORKS SECTION
// =============================================================================
class _HowItWorksSection extends StatelessWidget {
  final bool isWide;
  const _HowItWorksSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: _sectionHeader(
            tag: 'PROCESS',
            title: 'How It Works',
            subtitle: 'Three simple steps to financial clarity.',
          ),
        ),
        const SizedBox(height: 40),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 500),
          child: isWide
              ? Row(
                  children: [
                    Expanded(
                        child: _StepCard(
                      step: 1,
                      icon: Icons.upload_file_rounded,
                      title: 'Upload Agreement',
                      desc:
                          'Upload your PDF or paste the contract text directly into the analyzer.',
                      color: const Color(0xFF8B5CF6),
                    )),
                    _stepConnector(),
                    Expanded(
                        child: _StepCard(
                      step: 2,
                      icon: Icons.auto_awesome_rounded,
                      title: 'AI Analyzes',
                      desc:
                          'Gemini AI extracts clauses, runs simulations, and scores all risks.',
                      color: const Color(0xFF3B82F6),
                    )),
                    _stepConnector(),
                    Expanded(
                        child: _StepCard(
                      step: 3,
                      icon: Icons.insights_rounded,
                      title: 'Get Insights',
                      desc:
                          'Review your comprehensive guardian report with actionable recommendations.',
                      color: const Color(0xFF10B981),
                    )),
                  ],
                )
              : Column(
                  children: [
                    _StepCard(
                      step: 1,
                      icon: Icons.upload_file_rounded,
                      title: 'Upload Agreement',
                      desc:
                          'Upload your PDF or paste the contract text directly.',
                      color: const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(height: 12),
                    _StepCard(
                      step: 2,
                      icon: Icons.auto_awesome_rounded,
                      title: 'AI Analyzes',
                      desc:
                          'Gemini 2.0 Flash extracts clauses and scores risks.',
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 12),
                    _StepCard(
                      step: 3,
                      icon: Icons.insights_rounded,
                      title: 'Get Insights',
                      desc:
                          'Review your guardian report with recommendations.',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  static Widget _stepConnector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 40,
        child: Center(
          child: Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2A2A3E).withValues(alpha: 0.0),
                  const Color(0xFF2A2A3E),
                  const Color(0xFF2A2A3E).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  final int step;
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
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
          ..scale(_hovering ? 1.02 : 1.0, _hovering ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _hovering
                  ? widget.color.withValues(alpha: 0.06)
                  : const Color(0xFF111120),
              const Color(0xFF0D0D18),
            ],
          ),
          border: Border.all(
            color: _hovering
                ? widget.color.withValues(alpha: 0.22)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color
                  .withValues(alpha: _hovering ? 0.08 : 0.0),
              blurRadius: _hovering ? 20 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Step number
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.18),
                        widget.color.withValues(alpha: 0.06),
                      ],
                    ),
                    border: Border.all(
                      color: widget.color.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Center(
                    child: Text('${widget.step}',
                        style: TextStyle(
                            color: widget.color,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: widget.color.withValues(alpha: 0.08),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(widget.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
            const SizedBox(height: 8),
            Text(widget.desc,
                style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.6)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SDG SECTION
// =============================================================================
class _SdgSection extends StatelessWidget {
  final bool isWide;
  const _SdgSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWide ? 32 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111120), Color(0xFF0D0D16)],
        ),
        border: Border.all(
          color: const Color(0xFF1E1E2E).withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.public_rounded,
                  color: Color(0xFF64748B), size: 16),
              const SizedBox(width: 8),
              Text('ALIGNED WITH UN SUSTAINABLE DEVELOPMENT GOALS',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: isWide ? 11 : 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  )),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _SdgBadge(
                number: '1',
                label: 'No Poverty',
                color: const Color(0xFFE5243B),
                desc:
                    'Protecting vulnerable populations from predatory financial agreements',
                isWide: isWide,
              ),
              _SdgBadge(
                number: '16',
                label: 'Peace, Justice & Strong Institutions',
                color: const Color(0xFF00689D),
                desc:
                    'Promoting access to justice and transparent legal understanding',
                isWide: isWide,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SdgBadge extends StatefulWidget {
  final String number;
  final String label;
  final Color color;
  final String desc;
  final bool isWide;

  const _SdgBadge({
    required this.number,
    required this.label,
    required this.color,
    required this.desc,
    required this.isWide,
  });

  @override
  State<_SdgBadge> createState() => _SdgBadgeState();
}

class _SdgBadgeState extends State<_SdgBadge> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(widget.isWide ? 20 : 16),
        constraints: BoxConstraints(maxWidth: widget.isWide ? 340 : 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: _hovering
              ? widget.color.withValues(alpha: 0.06)
              : widget.color.withValues(alpha: 0.03),
          border: Border.all(
            color: _hovering
                ? widget.color.withValues(alpha: 0.25)
                : widget.color.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.color.withValues(alpha: 0.15),
                border:
                    Border.all(color: widget.color.withValues(alpha: 0.25)),
              ),
              child: Center(
                child: Text(widget.number,
                    style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SDG ${widget.number}',
                      style: TextStyle(
                          color: widget.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(widget.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(widget.desc,
                      style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// FOOTER
// =============================================================================
class _Footer extends StatelessWidget {
  final bool isWide;
  const _Footer({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 60 : 24,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1E1E2E).withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Column(
        children: [
          const Text('Sigma Coders',
              style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

}

// =============================================================================
// SHARED: Section header
// =============================================================================
Widget _sectionHeader({
  required String tag,
  required String title,
  required String subtitle,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
          border: Border.all(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
          ),
        ),
        child: Text(tag,
            style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8)),
      ),
      const SizedBox(height: 14),
      Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 26,
              letterSpacing: -0.5)),
      const SizedBox(height: 8),
      Text(subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF64748B), fontSize: 14, height: 1.5)),
    ],
  );
}
