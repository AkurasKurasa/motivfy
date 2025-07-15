import 'package:flutter/material.dart';

class FloatingArrow extends StatefulWidget {
  const FloatingArrow({super.key});

  @override
  State<FloatingArrow> createState() => _FloatingArrowState();
}

class _FloatingArrowState extends State<FloatingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 1500,
      ), // Increased duration for smoother animation
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(
      begin: 0.0,
      end: 8.0, // Slightly larger range for subtle floating effect
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white70,
        size: 24,
      ),
    );
  }
}
