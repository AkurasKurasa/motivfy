import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motiv_fy/core/constants/app_icons.dart';
import 'package:motiv_fy/features/home/presentation/widgets/home_dash.dart';
import 'package:motiv_fy/core/widgets/custom_tab_selector.dart';
import 'package:motiv_fy/core/widgets/animated_entry.dart';
import 'package:motiv_fy/core/widgets/navigation_menu.dart';
import 'package:motiv_fy/core/widgets/slide_menu_button.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/task_creation_page.dart';
import 'package:motiv_fy/features/pomodoro/pomodoro_page.dart';
import 'package:motiv_fy/features/productivity_assistant/presentation/pages/productivity_assistant_page.dart';
import 'package:motiv_fy/core/utils/device_utils.dart';

/// Custom ScrollPhysics to prevent overscrolling above the top
class NoOverscrollPhysics extends BouncingScrollPhysics {
  const NoOverscrollPhysics({super.parent});

  /// Adjusts position for new dimensions.
  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required double velocity,
    required bool isScrolling,
  }) {
    // Prevent scrolling above the top (offset <= 0)
    if (newPosition.pixels < 0) {
      return 0.0;
    }
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      velocity: velocity,
      isScrolling: isScrolling,
    );
  }

  /// Determines whether user offset should be accepted.
  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    // Prevent scrolling above the top
    if (position.pixels < 0) {
      return false;
    }
    return super.shouldAcceptUserOffset(position);
  }
}

/// Main page of the application with performance optimizations.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a ScrollController
    final ScrollController scrollController = ScrollController();

    return RepaintBoundary(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image with device optimization
            Positioned.fill(
              child: RepaintBoundary(
                child: Image.asset(
                  'assets/Home_Dark.png',
                  fit: BoxFit.cover,
                  // Optimize image quality based on device
                  filterQuality: DeviceUtils.shouldReduceImageQuality
                      ? FilterQuality.low
                      : FilterQuality.high,
                ),
              ),
            ),

            // Main content with SafeArea and performance optimizations
            SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: DeviceUtils.isLowEndDevice
                    ? const ClampingScrollPhysics() // Less bouncy for performance
                    : const NoOverscrollPhysics(), // Custom physics for high-end
                child: RepaintBoundary(
                  child: Column(
                    children: [
                      SizedBox(height: DeviceUtils.isLowEndDevice ? 30 : 35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21.0),
                        child: Column(
                          children: [
                            RepaintBoundary(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          PerformanceMonitor.measureSync(
                                            'crown-tap',
                                            () {
                                              // Handle crown click
                                            },
                                          );
                                        },
                                        child: RepaintBoundary(
                                          child: SvgPicture.asset(
                                            'assets/Home_Page/HomeDash/crown.svg',
                                            width: DeviceUtils.isLowEndDevice
                                                ? 30
                                                : 35,
                                            height: DeviceUtils.isLowEndDevice
                                                ? 30
                                                : 35,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Level ',
                                        style: TextStyle(
                                          fontSize: DeviceUtils.isLowEndDevice
                                              ? 18
                                              : 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          PerformanceMonitor.measureSync(
                                            'settings-tap',
                                            () {
                                              // Handle settings click
                                            },
                                          );
                                        },
                                        child: RepaintBoundary(
                                          child: SvgPicture.asset(
                                            'assets/settings.svg',
                                            width: DeviceUtils.isLowEndDevice
                                                ? 26
                                                : 30,
                                            height: DeviceUtils.isLowEndDevice
                                                ? 26
                                                : 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          PerformanceMonitor.measureSync(
                                            'profile-tap',
                                            () {
                                              // Handle profile click
                                            },
                                          );
                                        },
                                        child: RepaintBoundary(
                                          child: SvgPicture.asset(
                                            'assets/Profile.svg',
                                            width: DeviceUtils.isLowEndDevice
                                                ? 26
                                                : 30,
                                            height: DeviceUtils.isLowEndDevice
                                                ? 26
                                                : 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            RepaintBoundary(
                              child: AnimatedEntry(
                                delay: DeviceUtils.shouldReduceAnimations
                                    ? 0
                                    : 250,
                                child: Center(
                                  child: CustomTabSelector(
                                    tabs: ["Dashboard", "My Stats", "Ranks"],
                                    onTabChanged: (index) {
                                      PerformanceMonitor.measureSync(
                                        'tab-change',
                                        () {
                                          // Handle tab change
                                        },
                                      );
                                    },
                                    height: DeviceUtils.isLowEndDevice
                                        ? 40
                                        : 45,
                                    width: DeviceUtils.isLowEndDevice
                                        ? 280
                                        : 300,
                                    borderRadius: 50,
                                    backgroundColor: const Color(0xFF161616),
                                    selectedTextColor: Colors.white,
                                    unselectedTextColor: Colors.grey,
                                    underlineColor: Colors.grey,
                                    textStyle: TextStyle(
                                      fontSize: DeviceUtils.isLowEndDevice
                                          ? 14
                                          : 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RepaintBoundary(child: HomeDash()),
                      SizedBox(height: DeviceUtils.isLowEndDevice ? 80 : 100),
                    ],
                  ),
                ),
              ),
            ),

            // Slide Menu Button at bottom right with performance optimizations
            Positioned(
              bottom: 150, // Adjusted based on new NavigationMenu position
              right: 18, // Match horizontal padding
              child: RepaintBoundary(
                child: SlideMenuButton(
                  menuIcons: AppIcons.sliderMenuIcons,
                  onIconSelected: (iconPath) {
                    PerformanceMonitor.measureAsync('navigation', () async {
                      final transitionDuration =
                          DeviceUtils.getAnimationDuration(
                            const Duration(milliseconds: 200),
                          );

                      if (iconPath == AppIcons.blockList) {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const HomePage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  if (DeviceUtils.shouldReduceAnimations) {
                                    return child; // No animation for low-end devices
                                  }
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: transitionDuration,
                          ),
                        );
                      } else if (iconPath == AppIcons.noteFlow) {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const TaskCreationPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  if (DeviceUtils.shouldReduceAnimations) {
                                    return child;
                                  }
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: transitionDuration,
                          ),
                        );
                      } else if (iconPath == AppIcons.pomodoroTimer) {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const PomodoroPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  if (DeviceUtils.shouldReduceAnimations) {
                                    return child;
                                  }
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: transitionDuration,
                          ),
                        );
                      } else if (iconPath == AppIcons.productivityAssistant) {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ProductivityAssistantPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  if (DeviceUtils.shouldReduceAnimations) {
                                    return child;
                                  }
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: transitionDuration,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),

            // Navigation Menu positioned higher from bottom
            const Positioned(
              bottom: 1, // Increased from 0 to lift it upwards
              left: 0,
              right: 0,
              child: NavigationMenu(),
            ),
          ],
        ),
      ),
    );
  }
}
