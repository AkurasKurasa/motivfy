import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'presentation/greeting_bar.dart';
import 'presentation/background_card.dart';
import 'presentation/section_title.dart';
import 'presentation/feature_grid.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SlideTransition(
        position: _offsetAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(height: 56),
            GreetingBar(),
            SizedBox(height: 24),
            BackgroundCard(),
            SizedBox(height: 56),
            SectionTitle(),
            FeatureGrid(),
          ],
        ),
      ),
    );
  }
}
