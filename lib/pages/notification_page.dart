import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = [];
  late final List<Animation<Offset>> _slideAnimations = [];
  late final List<Animation<double>> _fadeAnimations = [];

  final int todayCount = 2;
  final int yesterdayCount = 6;

  @override
  void initState() {
    super.initState();

    final totalItems = todayCount + yesterdayCount;

    for (int i = 0; i < totalItems; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      _controllers.add(controller);
      _slideAnimations.add(slideAnimation);
      _fadeAnimations.add(fadeAnimation);

      // Staggered animation start
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 26,
                  width: 26,
                  child: SvgPicture.asset('arrow-back.svg'),
                ),
                const SizedBox(width: 24),
                Text(
                  "Notifications",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  )
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                    "Mark All As Read",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                  )
                )
                
              ],
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 0, 36, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Today"),
                  const SizedBox(height: 24),
                  for (int i = 0; i < todayCount; i++) ...[
                    _NotificationItem(
                      slideAnimation: _slideAnimations[i],
                      fadeAnimation: _fadeAnimations[i],
                    ),
                    const SizedBox(height: 32),
                  ],
                  const SizedBox(height: 16),
                  _buildSectionHeader("Yesterday"),
                  const SizedBox(height: 24),
                  for (int i = todayCount; i < todayCount + yesterdayCount; i++) ...[
                    _NotificationItem(
                      slideAnimation: _slideAnimations[i],
                      fadeAnimation: _fadeAnimations[i],
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;

  const _NotificationItem({
    required this.slideAnimation,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Row(
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF383838),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt",
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF888888),
                      fontSize: 12,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE83E3E),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "1 minute ago",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
