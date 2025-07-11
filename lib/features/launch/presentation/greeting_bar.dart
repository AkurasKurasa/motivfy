import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingBar extends StatelessWidget {
  const GreetingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                "Hello, John!",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(height: 24, width: 24, child: SvgPicture.asset('envelope.svg')),
            ],
          ),
          SizedBox(height: 32, width: 32, child: SvgPicture.asset('assets/double-arrow.svg')),
        ],
      ),
    );
  }
}
