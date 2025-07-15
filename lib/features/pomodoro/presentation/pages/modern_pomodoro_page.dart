import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/services/pomodoro_service.dart';
import '../widgets/modern_timer_circle.dart';
import '../widgets/preset_selector.dart';
import '../widgets/modern_control_buttons.dart';
import '../widgets/mindfulness_widget.dart';
import '../widgets/timer_header.dart';
import '../widgets/adaptive_mode_toggle.dart';
import '../../../../core/utils/device_utils.dart';

/// Modern redesigned Pomodoro Timer page with glassmorphic design and advanced features
class ModernPomodoroPage extends StatefulWidget {
  const ModernPomodoroPage({super.key});

  @override
  State<ModernPomodoroPage> createState() => _ModernPomodoroPageState();
}

class _ModernPomodoroPageState extends State<ModernPomodoroPage>
    with TickerProviderStateMixin {
  late PomodoroService _pomodoroService;
  late AnimationController _pageController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize service
    _pomodoroService = PomodoroService();
    _pomodoroService.addListener(_onServiceUpdate);
    _pomodoroService.initialize();

    // Page animations with device-optimized durations
    _pageController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 800),
      ),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 10000),
      ),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pageController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
        );

    // Start page animation
    _pageController.forward();

    // Only repeat background animation on high-end devices
    if (!DeviceUtils.shouldReduceAnimations) {
      _backgroundController.repeat();
    }
  }

  void _onServiceUpdate() {
    if (mounted) {
      // Batch state updates for better performance
      PerformanceMonitor.measureSync('pomodoro-ui-update', () {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _pomodoroService.removeListener(_onServiceUpdate);
    // Don't dispose the singleton service - just remove our listener
    _pageController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Color get _currentAccentColor {
    return _pomodoroService.isWorkTime
        ? const Color(0xFFEF5350) // Red for work
        : const Color(0xFF66BB6A); // Green for break
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenHeight < 700 || screenWidth < 400;
    final spacing = isCompact ? 20.0 : 40.0;
    final smallSpacing = isCompact ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: RepaintBoundary(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF181818),
                const Color(0xFF1A1A1A),
                const Color(0xFF1C1C1C),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SafeArea(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Responsive top spacer
                        SliverToBoxAdapter(
                          child: SizedBox(height: isCompact ? 30 : 40),
                        ),

                        // Header
                        SliverToBoxAdapter(
                          child: RepaintBoundary(
                            child: TimerHeader(
                              sessionsCompleted:
                                  _pomodoroService.sessionsCompleted,
                              isWorkTime: _pomodoroService.isWorkTime,
                              currentModeTitle:
                                  _pomodoroService.currentModeTitle,
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(child: SizedBox(height: spacing)),

                        // Preset Selector
                        SliverToBoxAdapter(
                          child: PresetSelector(
                            pomodoroService: _pomodoroService,
                          ),
                        ),

                        SliverToBoxAdapter(child: SizedBox(height: spacing)),

                        // Main Timer Circle
                        SliverToBoxAdapter(
                          child: RepaintBoundary(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Responsive timer circle size with device optimization
                                final baseSize = isCompact ? 280.0 : 320.0;
                                final optimizedSize = DeviceUtils.isLowEndDevice
                                    ? baseSize *
                                          0.9 // Slightly smaller for performance
                                    : baseSize;
                                final availableWidth =
                                    constraints.maxWidth -
                                    48; // Account for padding
                                final timerSize = availableWidth < optimizedSize
                                    ? availableWidth
                                    : optimizedSize;

                                return Center(
                                  child: SizedBox(
                                    width: timerSize,
                                    height: timerSize,
                                    child: ModernTimerCircle(
                                      progress: _pomodoroService.progress,
                                      time: _pomodoroService.formatTime(
                                        _pomodoroService.currentTime,
                                      ),
                                      color: _currentAccentColor,
                                      isRunning: _pomodoroService.isRunning,
                                      modeTitle:
                                          _pomodoroService.currentModeTitle,
                                      modeSubtitle:
                                          _pomodoroService.currentModeSubtitle,
                                      onTap: _showTimerSettings,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(child: SizedBox(height: spacing)),

                        // Control Buttons
                        SliverToBoxAdapter(
                          child: RepaintBoundary(
                            child: ModernControlButtons(
                              isRunning: _pomodoroService.isRunning,
                              onPlayPause: _onPlayPause,
                              onReset: _onReset,
                              onSkip: _onSkip,
                              accentColor: _currentAccentColor,
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: SizedBox(height: smallSpacing),
                        ),

                        // Mindfulness Widget (shown during breaks)
                        SliverToBoxAdapter(
                          child: MindfulnessWidget(
                            isVisible: !_pomodoroService.isWorkTime,
                            isLongBreak:
                                !_pomodoroService.isWorkTime &&
                                _pomodoroService.sessionsCompleted % 4 == 0,
                            sessionNumber: _pomodoroService.sessionsCompleted,
                          ),
                        ),

                        if (!_pomodoroService.isWorkTime)
                          SliverToBoxAdapter(
                            child: SizedBox(height: smallSpacing),
                          ),

                        // Adaptive Mode Toggle
                        SliverToBoxAdapter(
                          child: AdaptiveModeToggle(
                            pomodoroService: _pomodoroService,
                          ),
                        ),

                        // Responsive bottom spacer
                        SliverToBoxAdapter(
                          child: SizedBox(height: isCompact ? 20 : 40),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPlayPause() {
    HapticFeedback.mediumImpact();

    if (_pomodoroService.isRunning) {
      _pomodoroService.pauseTimer();
    } else {
      _pomodoroService.startTimer();
    }
  }

  void _onReset() {
    HapticFeedback.lightImpact();
    _pomodoroService.resetTimer();

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Timer reset'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onSkip() {
    HapticFeedback.lightImpact();
    _pomodoroService.skipSession();

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _pomodoroService.isWorkTime
              ? 'Switched to work session'
              : 'Switched to break session',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showTimerSettings() {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTimerSettingsModal(),
    );
  }

  Widget _buildTimerSettingsModal() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.9),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                'Timer Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // Quick duration buttons
              Text(
                'Quick Durations',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                children: [5, 10, 15, 25, 30, 45, 60].map((minutes) {
                  return GestureDetector(
                    onTap: () {
                      final duration = Duration(minutes: minutes);
                      if (_pomodoroService.isWorkTime) {
                        _pomodoroService.updateWorkDuration(duration);
                      } else {
                        _pomodoroService.updateBreakDuration(duration);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${minutes}m',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
