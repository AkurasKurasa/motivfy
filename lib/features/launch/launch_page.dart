import 'package:flutter/material.dart';
import 'package:motiv_fy/core/theme/app_colors.dart';
import 'package:motiv_fy/core/utils/device_utils.dart';
import 'presentation/greeting_bar.dart';
import 'presentation/background_card.dart';
import 'presentation/section_title.dart';
import 'presentation/feature_grid.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Device-optimized animation controller
    _controller = AnimationController(
      duration: DeviceUtils.getAnimationDuration(
        const Duration(milliseconds: 800),
      ),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Only animate if device supports it
    if (!DeviceUtils.shouldReduceAnimations) {
      _controller.forward();
    } else {
      _controller.value = 1.0; // Skip animation on low-end devices
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isTablet = screenWidth > 600;

            return Stack(
              children: [
                // Background layer for blur effect with device optimization
                RepaintBoundary(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primaryDark.withOpacity(0.95),
                          AppColors.primaryDark.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),

                // Glassmorphic background accents (only on high-end devices)
                if (!DeviceUtils.shouldReduceAnimations) ...[
                  Positioned(
                    top: screenHeight * 0.1,
                    left: -50,
                    child: RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryYellow.withOpacity(0.15),
                                AppColors.primaryOrange.withOpacity(0.08),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: screenHeight * 0.2,
                    right: -30,
                    child: RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.secondaryLightBlue.withOpacity(0.12),
                                AppColors.secondarySkyBlue.withOpacity(0.06),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // Main content with device-optimized animations
                RepaintBoundary(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          physics: DeviceUtils.isLowEndDevice
                              ? const ClampingScrollPhysics()
                              : const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  screenHeight -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: isTablet
                                      ? (DeviceUtils.isLowEndDevice ? 70 : 80)
                                      : (DeviceUtils.isLowEndDevice ? 48 : 56),
                                ),
                                RepaintBoundary(child: const GreetingBar()),
                                SizedBox(
                                  height: isTablet
                                      ? (DeviceUtils.isLowEndDevice ? 28 : 32)
                                      : (DeviceUtils.isLowEndDevice ? 20 : 24),
                                ),
                                RepaintBoundary(child: const BackgroundCard()),
                                SizedBox(
                                  height: isTablet
                                      ? (DeviceUtils.isLowEndDevice ? 60 : 72)
                                      : (DeviceUtils.isLowEndDevice ? 48 : 56),
                                ),
                                RepaintBoundary(child: const SectionTitle()),
                                RepaintBoundary(child: const FeatureGrid()),
                                SizedBox(
                                  height: isTablet
                                      ? (DeviceUtils.isLowEndDevice ? 50 : 60)
                                      : (DeviceUtils.isLowEndDevice ? 32 : 40),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
