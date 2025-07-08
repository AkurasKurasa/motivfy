import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 26,
                  width: 26,
                  child: SvgPicture.asset('arrow-back.svg'),
                ),
                const SizedBox(width: 24),
                Text(
                  "Notifications",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 0, 36, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Today", showMarkAll: true),
                  const SizedBox(height: 24),
                  _NotificationItem(),
                  const SizedBox(height: 32),
                  _NotificationItem(),
                  const SizedBox(height: 48),
                  _buildSectionHeader("Yesterday"),
                  const SizedBox(height: 24),
                  for (int i = 0; i < 6; i++) ...[
                    _NotificationItem(),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showMarkAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (showMarkAll)
          Text(
            "Mark All As Read",
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem();

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
