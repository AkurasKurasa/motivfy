import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern timer header with session info and statistics
class TimerHeader extends StatelessWidget {
  final int sessionsCompleted;
  final bool isWorkTime;
  final String currentModeTitle;

  const TimerHeader({
    required this.sessionsCompleted,
    required this.isWorkTime,
    required this.currentModeTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    final isVeryCompact = screenWidth < 350;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Main title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pomodoro Timer',
                  style: TextStyle(
                    fontSize: isVeryCompact ? 22 : (isCompact ? 24 : 28),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                SizedBox(height: isVeryCompact ? 2 : 4),

                Text(
                  currentModeTitle,
                  style: TextStyle(
                    fontSize: isVeryCompact ? 12 : (isCompact ? 14 : 16),
                    color: isWorkTime
                        ? const Color(0xFFEF5350)
                        : const Color(0xFF66BB6A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Sessions completed badge
          if (sessionsCompleted > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(isVeryCompact ? 12 : 16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryCompact ? 10 : (isCompact ? 12 : 16),
                    vertical: isVeryCompact ? 8 : (isCompact ? 10 : 12),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                      isVeryCompact ? 12 : 16,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$sessionsCompleted',
                        style: TextStyle(
                          fontSize: isVeryCompact ? 16 : (isCompact ? 18 : 20),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        sessionsCompleted == 1 ? 'session' : 'sessions',
                        style: TextStyle(
                          fontSize: isVeryCompact ? 8 : (isCompact ? 9 : 10),
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: isVeryCompact ? 12 : 16),
          ],

          // Return button (moved to the right side)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.9),
              size: isVeryCompact ? 24 : 28,
            ),
          ),
        ],
      ),
    );
  }
}
