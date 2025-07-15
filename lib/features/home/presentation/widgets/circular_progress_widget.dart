import 'package:flutter/material.dart';

/// Represents a circular progress indicator widget.
class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final String label;
  final double size;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.label = 'Today',
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = progress.clamp(0.0, 100.0); // Validate progress
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: effectiveProgress / 100,
              strokeWidth: 10,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${effectiveProgress.round()}%',
                style: TextStyle(
                  fontSize: size * 0.2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: size * 0.1, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
