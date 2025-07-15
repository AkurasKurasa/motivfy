import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:motiv_fy/core/services/user/user_data_manager.dart';

/// Pomodoro analytics card for the home dashboard
class PomodoroAnalyticsCard extends StatefulWidget {
  const PomodoroAnalyticsCard({super.key});

  @override
  State<PomodoroAnalyticsCard> createState() => _PomodoroAnalyticsCardState();
}

class _PomodoroAnalyticsCardState extends State<PomodoroAnalyticsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int _totalSessions = 0;
  double _totalWorkHours = 0.0;
  int _todaySessions = 0;
  int _currentStreak = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _loadPomodoroStats();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPomodoroStats() async {
    try {
      final userManager = UserDataManager();
      final userData = await userManager.getUserData();
      final pomodoroSettings = userData.pomodoroSettings;

      // Calculate today's sessions
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';

      int todayCount = 0;
      int streak = 0;

      for (final session in pomodoroSettings.history) {
        final sessionDateStr =
            '${session.startTime.year}-${session.startTime.month}-${session.startTime.day}';

        if (sessionDateStr == todayStr && session.sessionType == 'work') {
          todayCount++;
        }
      }

      // Calculate streak (simplified - consecutive days with at least 1 session)
      final reversedHistory = pomodoroSettings.history.reversed.toList();
      String? lastDate;

      for (final session in reversedHistory) {
        if (session.sessionType != 'work') continue;

        final sessionDateStr =
            '${session.startTime.year}-${session.startTime.month}-${session.startTime.day}';

        if (lastDate == null) {
          lastDate = sessionDateStr;
          streak = 1;
        } else if (sessionDateStr != lastDate) {
          // Check if it's the previous day
          final lastDateTime = DateTime.parse('$lastDate 00:00:00');
          final sessionDateTime = DateTime.parse('$sessionDateStr 00:00:00');
          final difference = lastDateTime.difference(sessionDateTime).inDays;

          if (difference == 1) {
            streak++;
            lastDate = sessionDateStr;
          } else {
            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          _totalSessions = pomodoroSettings.totalSessionsCompleted;
          _totalWorkHours = pomodoroSettings.totalWorkTimeInHours;
          _todaySessions = todayCount;
          _currentStreak = streak;
        });
      }
    } catch (e) {
      debugPrint('Error loading Pomodoro stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () {
              // Navigate to Pomodoro page or detailed analytics
              Navigator.pushNamed(context, '/pomodoro');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF636363), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Pomodoro icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEF5350),
                                    Color(0xFFE53935),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🍅',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pomodoro Stats',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),

                                  Text(
                                    'Focus tracking',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Stats grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                label: 'Today',
                                value: '$_todaySessions',
                                subtitle: 'sessions',
                                color: const Color(0xFF4CAF50),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildStatItem(
                                label: 'Streak',
                                value: '$_currentStreak',
                                subtitle: 'days',
                                color: const Color(0xFFFF9800),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                label: 'Total',
                                value: '$_totalSessions',
                                subtitle: 'sessions',
                                color: const Color(0xFF2196F3),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildStatItem(
                                label: 'Hours',
                                value: _totalWorkHours.toStringAsFixed(1),
                                subtitle: 'focused',
                                color: const Color(0xFF9C27B0),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Progress indicator
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (_todaySessions / 8).clamp(
                              0.0,
                              1.0,
                            ), // Goal: 8 sessions per day
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEF5350),
                                    Color(0xFFFF7043),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Daily goal text
                        Text(
                          'Daily goal: ${(_todaySessions / 8 * 100).clamp(0, 100).toInt()}% (${_todaySessions}/8)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),

              const SizedBox(width: 4),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
