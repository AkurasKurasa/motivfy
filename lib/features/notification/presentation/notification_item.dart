import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationItem extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;

  const NotificationItem({
    super.key,
    required this.slideAnimation,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Row(
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF383838),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt",
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF888888),
                      fontSize: 12,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE83E3E),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "1 minute ago",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
