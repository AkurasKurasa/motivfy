import 'package:flutter/material.dart';

class TimerCircle extends StatelessWidget {
  final double progress;
  final String time;
  final Color color;
  final VoidCallback onTap;

  const TimerCircle({
    required this.progress,
    required this.time,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: progress),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, _) => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                value: 1.0 - value,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
