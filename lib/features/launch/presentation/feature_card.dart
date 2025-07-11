import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hover_card.dart';

class FeatureCard extends StatelessWidget {
  final String asset;
  final String label;
  final double iconSize;

  const FeatureCard({
    super.key,
    required this.asset,
    required this.label,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: const Color(0xFF505050)),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: iconSize, width: iconSize, child: SvgPicture.asset(asset)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                color: const Color(0xFF878787),
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
