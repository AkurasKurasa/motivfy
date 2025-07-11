import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      child: Row(
        children: [
          Text(
            "Discover",
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
