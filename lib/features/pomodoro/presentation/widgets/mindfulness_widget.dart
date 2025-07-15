import 'dart:ui';
import 'package:flutter/material.dart';

/// Mindfulness widget displayed during break times
class MindfulnessWidget extends StatefulWidget {
  final bool isVisible;
  final bool isLongBreak;
  final int sessionNumber; // Add session number to change activities

  const MindfulnessWidget({
    this.isVisible = false,
    this.isLongBreak = false,
    this.sessionNumber = 0, // Default session number
    super.key,
  });

  @override
  State<MindfulnessWidget> createState() => _MindfulnessWidgetState();
}

class _MindfulnessWidgetState extends State<MindfulnessWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _fadeController;
  late Animation<double> _breathAnimation;
  late Animation<double> _fadeAnimation;

  int get _currentActivityIndex {
    // Use session number to cycle through different mindfulness activities
    // sessionNumber represents completed sessions:
    // - 0: No sessions completed yet (no break)
    // - 1: First session completed → First break (show activity 0)
    // - 2: Second session completed → Second break (show activity 1)
    // etc.
    if (widget.sessionNumber <= 0) return 0;
    final index = (widget.sessionNumber - 1) % _activities.length;
    return index;
  }

  final List<MindfulnessActivity> _activities = [
    MindfulnessActivity(
      title: 'Deep Breathing',
      subtitle: 'Take slow, deep breaths',
      icon: '🫁',
      instruction: 'Inhale for 4 seconds, hold for 4, exhale for 4',
      color: const Color(0xFF64B5F6),
    ),
    MindfulnessActivity(
      title: 'Gentle Stretching',
      subtitle: 'Stretch your neck and shoulders',
      icon: '🤸‍♀️',
      instruction: 'Roll your shoulders and stretch your arms',
      color: const Color(0xFF81C784),
    ),
    MindfulnessActivity(
      title: 'Eye Rest',
      subtitle: 'Give your eyes a break',
      icon: '👁️',
      instruction: 'Look at something 20 feet away for 20 seconds',
      color: const Color(0xFFFFB74D),
    ),
    MindfulnessActivity(
      title: 'Mindful Moment',
      subtitle: 'Be present in the moment',
      icon: '🧘‍♂️',
      instruction: 'Notice 3 things you can see, hear, and feel',
      color: const Color(0xFFBA68C8),
    ),
    MindfulnessActivity(
      title: 'Hydration',
      subtitle: 'Drink some water',
      icon: '💧',
      instruction: 'Sip water slowly and mindfully',
      color: const Color(0xFF4DD0E1),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _startAnimations();
  }

  @override
  void didUpdateWidget(MindfulnessWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if visibility changed
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _fadeController.forward();
        _startAnimations();
      } else {
        _fadeController.reverse();
        _stopAnimations();
      }
    }

    // Check if session number changed (this will trigger activity change)
    if (widget.sessionNumber != oldWidget.sessionNumber) {
      // Force a rebuild to show the new activity
      setState(() {});
    }
  }

  void _startAnimations() {
    if (widget.isVisible) {
      _breathController.repeat(reverse: true);
    }
  }

  void _stopAnimations() {
    _breathController.stop();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final currentActivity = _activities[_currentActivityIndex];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        currentActivity.color.withOpacity(0.2),
                        currentActivity.color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: currentActivity.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.self_improvement,
                              color: Colors.white.withOpacity(0.9),
                              size: 24,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isLongBreak
                                      ? 'Long Break Activity'
                                      : 'Break Activity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Take care of yourself',
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

                      const SizedBox(height: 24),

                      // Activity content
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildActivityContent(currentActivity),
                      ),

                      const SizedBox(height: 20),

                      // Activity indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _activities.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentActivityIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityContent(MindfulnessActivity activity) {
    return Column(
      key: ValueKey(activity.title),
      children: [
        // Activity icon with breathing animation
        AnimatedBuilder(
          animation: _breathAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _breathAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      activity.color.withOpacity(0.3),
                      activity.color.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    activity.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Activity title
        Text(
          activity.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Activity subtitle
        Text(
          activity.subtitle,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Activity instruction
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            activity.instruction,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Represents a mindfulness activity
class MindfulnessActivity {
  final String title;
  final String subtitle;
  final String icon;
  final String instruction;
  final Color color;

  const MindfulnessActivity({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.instruction,
    required this.color,
  });
}
