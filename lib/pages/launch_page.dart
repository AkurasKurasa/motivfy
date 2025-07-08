import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildFeatureCard(String asset, String label, double iconSize) {
    return _HoverCard(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: const Color(0xFF505050)),
          borderRadius: BorderRadius.circular(9),
        ),
        width: 125,
        height: 125,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: iconSize, width: iconSize, child: SvgPicture.asset(asset)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.quicksand(
                color: const Color(0xFF878787),
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SlideTransition(
        position: _offsetAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(32, 56, 32, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        "Hello, John!",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(height: 24, width: 24, child: SvgPicture.asset('envelope.svg')),
                    ],
                  ),
                  SizedBox(height: 32, width: 32, child: SvgPicture.asset('assets/double-arrow.svg')),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Opacity(
              opacity: 0.5,
              child: Container(
                margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0x73FFFFFF), Color(0x00FFFFFF)],
                    stops: [0, 1.0],
                    begin: Alignment(1, -1),
                    end: Alignment(-1, 1),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: double.infinity,
                height: 175,
              ),
            ),

            const SizedBox(height: 56),

            Container(
              margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Discover",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildFeatureCard('timer.svg', 'Pomodoro\nTimer', 32),
                      const SizedBox(width: 8),
                      buildFeatureCard('analyze.svg', 'Procrastination\nAnalysis', 40),
                      const SizedBox(width: 8),
                      buildFeatureCard('block.svg', 'Block\nList', 40),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildFeatureCard('timer.svg', 'Done\nList', 32),
                      const SizedBox(width: 8),
                      buildFeatureCard('analyze.svg', 'Note\nFlow', 40),
                      const SizedBox(width: 8),
                      buildFeatureCard('block.svg', 'Productivity\nAssistant', 40),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: widget.child,
      ),
    );
  }
}
