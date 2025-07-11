import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/notification_header.dart';
import 'presentation/notification_section_header.dart';
import 'presentation/notification_item.dart';

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

      _controllers.add(controller);

      _slideAnimations.add(Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      )));

      _fadeAnimations.add(Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      )));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Column(
        children: [
          const NotificationHeader(),
          const SizedBox(height: 48),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 0, 36, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NotificationSectionHeader(title: "Today"),
                  const SizedBox(height: 24),
                  for (int i = 0; i < todayCount; i++) ...[
                    NotificationItem(
                      slideAnimation: _slideAnimations[i],
                      fadeAnimation: _fadeAnimations[i],
                    ),
                    const SizedBox(height: 32),
                  ],
                  const SizedBox(height: 16),
                  const NotificationSectionHeader(title: "Yesterday"),
                  const SizedBox(height: 24),
                  for (int i = todayCount; i < todayCount + yesterdayCount; i++) ...[
                    NotificationItem(
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
