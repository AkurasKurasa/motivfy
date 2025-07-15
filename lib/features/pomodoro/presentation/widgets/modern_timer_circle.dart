import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/utils/device_utils.dart';

/// Modern glassmorphic timer circle with advanced animations and visual effects
class ModernTimerCircle extends StatefulWidget {
  final double progress;
  final String time;
  final Color color;
  final VoidCallback onTap;
  final bool isRunning;
  final String modeTitle;
  final String modeSubtitle;

  const ModernTimerCircle({
    required this.progress,
    required this.time,
    required this.color,
    required this.onTap,
    this.isRunning = false,
    this.modeTitle = 'Focus Time',
    this.modeSubtitle = 'Stay focused on your task',
    super.key,
  });

  @override
  State<ModernTimerCircle> createState() => _ModernTimerCircleState();
}

class _ModernTimerCircleState extends State<ModernTimerCircle>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _breathController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for running state with device optimization
    _pulseController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 2000),
      ),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Breathing animation for idle state with device optimization
    _breathController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 4000),
      ),
      vsync: this,
    );
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Ripple animation for tap effect
    _rippleController = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 600),
      ),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _updateAnimations();
  }

  void _updateAnimations() {
    if (widget.isRunning) {
      _breathController.stop();
      // Only run pulse animation on high-end devices
      if (!DeviceUtils.shouldReduceAnimations) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      // Only run breathing animation on high-end devices
      if (!DeviceUtils.shouldReduceAnimations) {
        _breathController.repeat(reverse: true);
      }
    }
  }

  @override
  void didUpdateWidget(ModernTimerCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRunning != widget.isRunning) {
      _updateAnimations();
    }
  }

  void _onTap() {
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    widget.onTap();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Device-optimized sizing
    final circleSize = DeviceUtils.isLowEndDevice ? 260.0 : 280.0;
    final glowSize = DeviceUtils.isLowEndDevice ? 280.0 : 300.0;
    final progressSize = DeviceUtils.isLowEndDevice ? 220.0 : 240.0;
    final innerSize = DeviceUtils.isLowEndDevice ? 200.0 : 220.0;
    final timeTextSize = DeviceUtils.isLowEndDevice ? 42.0 : 48.0;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseAnimation,
            _breathAnimation,
            _rippleAnimation,
          ]),
          builder: (context, child) {
            final scale = widget.isRunning
                ? _pulseAnimation.value
                : _breathAnimation.value;

            return Transform.scale(
              scale: scale,
              child: SizedBox(
                width: circleSize,
                height: circleSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow effect (reduced on low-end devices)
                    if (!DeviceUtils.shouldReduceAnimations)
                      Container(
                        width: glowSize,
                        height: glowSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.3),
                              blurRadius: DeviceUtils.isLowEndDevice ? 15 : 30,
                              spreadRadius: DeviceUtils.isLowEndDevice ? 2 : 5,
                            ),
                          ],
                        ),
                      ),

                    // Ripple effect (only on high-end devices)
                    if (_rippleAnimation.value > 0 &&
                        !DeviceUtils.shouldReduceAnimations)
                      Container(
                        width: circleSize + (_rippleAnimation.value * 40),
                        height: circleSize + (_rippleAnimation.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.color.withOpacity(
                              0.5 * (1 - _rippleAnimation.value),
                            ),
                            width: 2,
                          ),
                        ),
                      ),

                    // Main glassmorphic circle
                    RepaintBoundary(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: DeviceUtils.isLowEndDevice ? 10 : 20,
                            sigmaY: DeviceUtils.isLowEndDevice ? 10 : 20,
                          ),
                          child: Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Progress ring
                                RepaintBoundary(
                                  child: CustomPaint(
                                    size: Size(progressSize, progressSize),
                                    painter: ProgressRingPainter(
                                      progress: widget.progress,
                                      color: widget.color,
                                      strokeWidth: DeviceUtils.isLowEndDevice
                                          ? 6
                                          : 8,
                                    ),
                                  ),
                                ),

                                // Center content
                                RepaintBoundary(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Time display
                                      Text(
                                        widget.time,
                                        style: TextStyle(
                                          fontSize: timeTextSize,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                          letterSpacing: 2,
                                          shadows:
                                              DeviceUtils
                                                  .shouldReduceImageQuality
                                              ? null // No shadow on low-end devices
                                              : [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // Mode title
                                      Text(
                                        widget.modeTitle,
                                        style: TextStyle(
                                          fontSize: DeviceUtils.isLowEndDevice
                                              ? 14
                                              : 16,
                                          fontWeight: FontWeight.w500,
                                          color: widget.color,
                                          letterSpacing: 1,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      // Mode subtitle
                                      Text(
                                        widget.modeSubtitle,
                                        style: TextStyle(
                                          fontSize: DeviceUtils.isLowEndDevice
                                              ? 11
                                              : 12,
                                          color: Colors.white.withOpacity(0.7),
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Inner highlight (only on high-end devices)
                    if (!DeviceUtils.shouldReduceAnimations)
                      Container(
                        width: innerSize,
                        height: innerSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Custom painter for the progress ring with performance optimizations
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle with device optimization
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = DeviceUtils.isLowEndDevice
          ? strokeWidth * 0.8
          : strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc with device optimization
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DeviceUtils.isLowEndDevice
          ? strokeWidth * 0.8
          : strokeWidth
      ..strokeCap = StrokeCap.round;

    if (DeviceUtils.shouldReduceImageQuality) {
      progressPaint.color = color; // Use solid color on low-end devices
    } else {
      progressPaint.shader = LinearGradient(
        colors: [color, color.withOpacity(0.7)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    }

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // Progress end dot (only on high-end devices for performance)
      if (!DeviceUtils.isLowEndDevice) {
        final endAngle = startAngle + sweepAngle;
        final endX = center.dx + radius * math.cos(endAngle);
        final endY = center.dy + radius * math.sin(endAngle);

        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(endX, endY), strokeWidth / 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    // Only repaint if progress changed significantly for better performance
    return (progress - oldDelegate.progress).abs() > 0.01 ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
