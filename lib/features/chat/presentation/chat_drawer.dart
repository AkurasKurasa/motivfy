import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF222222),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Hi, John!',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Chats',
                style: GoogleFonts.inter(
                  color: Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.white24, thickness: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: 6,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.chat_bubble_outline, color: Colors.white70),
                  title: Text('Chat ${index + 1}', style: const TextStyle(color: Colors.white)),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A3A3A),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text('New Chat', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.w600)),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
