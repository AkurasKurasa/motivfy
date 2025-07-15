import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/services/pomodoro_service.dart';

/// Adaptive mode toggle with glassmorphic design
class AdaptiveModeToggle extends StatefulWidget {
  final PomodoroService pomodoroService;

  const AdaptiveModeToggle({required this.pomodoroService, super.key});

  @override
  State<AdaptiveModeToggle> createState() => _AdaptiveModeToggleState();
}

class _AdaptiveModeToggleState extends State<AdaptiveModeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _toggleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _toggleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.white.withOpacity(0.3),
      end: const Color(0xFF4CAF50),
    ).animate(_animationController);

    // Set initial state
    if (widget.pomodoroService.adaptiveModeEnabled) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onToggle() {
    HapticFeedback.selectionClick();

    if (widget.pomodoroService.adaptiveModeEnabled) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    widget.pomodoroService.toggleAdaptiveMode();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 400;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(isCompact ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.psychology_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart Adaptive Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                'AI adjusts timing based on your focus patterns',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Toggle switch
                        GestureDetector(
                          onTap: _onToggle,
                          child: AnimatedBuilder(
                            animation: _toggleAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 52,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: _colorAnimation.value,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                      left:
                                          widget
                                              .pomodoroService
                                              .adaptiveModeEnabled
                                          ? 26
                                          : 2,
                                      top: 2,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          widget
                                                  .pomodoroService
                                                  .adaptiveModeEnabled
                                              ? Icons.check
                                              : Icons.close,
                                          size: 16,
                                          color:
                                              widget
                                                  .pomodoroService
                                                  .adaptiveModeEnabled
                                              ? const Color(0xFF4CAF50)
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Features list
                    if (widget.pomodoroService.adaptiveModeEnabled) ...[
                      _buildFeatureItem(
                        icon: Icons.trending_up,
                        text: 'Learns from your productivity patterns',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        icon: Icons.schedule,
                        text: 'Adjusts break durations automatically',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        icon: Icons.insights,
                        text: 'Provides personalized insights',
                      ),
                    ] else ...[
                      Text(
                        'Enable to unlock AI-powered focus optimization and personalized productivity insights.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
