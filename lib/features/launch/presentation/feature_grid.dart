import 'package:flutter/material.dart';
import 'feature_card.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FeatureCard(asset: 'timer.svg', label: 'Pomodoro\nTimer', iconSize: 32),
              SizedBox(width: 8),
              FeatureCard(asset: 'analyze.svg', label: 'Procrastination\nAnalysis', iconSize: 40),
              SizedBox(width: 8),
              FeatureCard(asset: 'block.svg', label: 'Block\nList', iconSize: 40),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FeatureCard(asset: 'timer.svg', label: 'Done\nList', iconSize: 32),
              SizedBox(width: 8),
              FeatureCard(asset: 'analyze.svg', label: 'Note\nFlow', iconSize: 40),
              SizedBox(width: 8),
              FeatureCard(asset: 'block.svg', label: 'Productivity\nAssistant', iconSize: 40),
            ],
          ),
        ],
      ),
    );
  }
}
