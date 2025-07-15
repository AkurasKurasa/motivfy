import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/device_utils.dart';

/// Modern control buttons with glassmorphic design and microinteractions
class ModernControlButtons extends StatefulWidget {
  final bool isRunning;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;
  final Color accentColor;

  const ModernControlButtons({
    required this.isRunning,
    required this.onPlayPause,
    required this.onReset,
    required this.onSkip,
    required this.accentColor,
    super.key,
  });

  @override
  State<ModernControlButtons> createState() => _ModernControlButtonsState();
}

class _ModernControlButtonsState extends State<ModernControlButtons>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late Animation<double> _primaryScale;
  late Animation<double> _secondaryScale;

  @override
  void initState() {
    super.initState();

    // Device-optimized animation durations
    _primaryController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 150),
      ),
      vsync: this,
    );
    _primaryScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeInOut),
    );

    _secondaryController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 150),
      ),
      vsync: this,
    );
    _secondaryScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _secondaryController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Reset Button
            RepaintBoundary(
              child: _buildSecondaryButton(
                icon: Icons.refresh_rounded,
                onTap: () {
                  PerformanceMonitor.measureSync(
                    'reset-button-tap',
                    widget.onReset,
                  );
                },
                size: DeviceUtils.isLowEndDevice ? 50.0 : 56.0,
              ),
            ),

            // Primary Play/Pause Button
            RepaintBoundary(
              child: _buildPrimaryButton(
                icon: widget.isRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                onTap: () {
                  PerformanceMonitor.measureSync(
                    'play-pause-tap',
                    widget.onPlayPause,
                  );
                },
                size: DeviceUtils.isLowEndDevice ? 68.0 : 76.0,
              ),
            ),

            // Skip Button
            RepaintBoundary(
              child: _buildSecondaryButton(
                icon: Icons.skip_next_rounded,
                onTap: () {
                  PerformanceMonitor.measureSync(
                    'skip-button-tap',
                    widget.onSkip,
                  );
                },
                size: DeviceUtils.isLowEndDevice ? 50.0 : 56.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return AnimatedBuilder(
      animation: _primaryScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _primaryScale.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (!DeviceUtils.shouldReduceAnimations) {
                _primaryController.forward();
              }
              HapticFeedback.mediumImpact();
            },
            onTapUp: (_) {
              if (!DeviceUtils.shouldReduceAnimations) {
                _primaryController.reverse();
              }
              onTap();
            },
            onTapCancel: () {
              if (!DeviceUtils.shouldReduceAnimations) {
                _primaryController.reverse();
              }
            },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.accentColor,
                    widget.accentColor.withOpacity(0.8),
                  ],
                ),
                boxShadow: DeviceUtils.shouldReduceImageQuality
                    ? null // No shadows on low-end devices
                    : [
                        BoxShadow(
                          color: widget.accentColor.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: DeviceUtils.isLowEndDevice ? 28 : 32,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return AnimatedBuilder(
      animation: _secondaryScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _secondaryScale.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (!DeviceUtils.shouldReduceAnimations) {
                _secondaryController.forward();
              }
              HapticFeedback.lightImpact();
            },
            onTapUp: (_) {
              if (!DeviceUtils.shouldReduceAnimations) {
                _secondaryController.reverse();
              }
              onTap();
            },
            onTapCancel: () {
              if (!DeviceUtils.shouldReduceAnimations) {
                _secondaryController.reverse();
              }
            },
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: DeviceUtils.isLowEndDevice ? 5 : 10,
                  sigmaY: DeviceUtils.isLowEndDevice ? 5 : 10,
                ),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.8),
                    size: DeviceUtils.isLowEndDevice ? 20 : 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
