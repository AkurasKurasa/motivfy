import 'package:flutter/material.dart';

class GlassmorphicBackground extends StatelessWidget {
  final Widget child;

  const GlassmorphicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000000), // Pure black at top
            Color(0xFF000000), // Black continues
            Color(0xFF111111), // Very subtle grey transition
            Color(0xFF1A1A1A), // Slightly lighter grey at bottom
          ],
          stops: [0.0, 0.5, 0.8, 1.0],
        ),
      ),
      child: child,
    );
  }
}
