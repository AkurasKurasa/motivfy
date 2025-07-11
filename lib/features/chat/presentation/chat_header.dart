import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const ChatHeader({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              Text(
                "Chat One",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuPressed,
          ),
        ],
      ),
    );
  }
}
