import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
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
    );
  }
}
