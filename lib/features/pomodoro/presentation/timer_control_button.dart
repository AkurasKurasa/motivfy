import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isRunning;
  final Color backgroundColor;

  const TimerControlButton({
    required this.onPressed,
    required this.isRunning,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        isRunning ? "Pause" : "Start",
        style: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
