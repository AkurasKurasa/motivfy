import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;

  const NotificationSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.quicksand(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
