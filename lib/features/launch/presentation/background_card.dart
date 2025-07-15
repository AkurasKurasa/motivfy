import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motiv_fy/core/theme/app_colors.dart';

class BackgroundCard extends StatefulWidget {
  const BackgroundCard({super.key});

  @override
  State<BackgroundCard> createState() => _BackgroundCardState();
}

class _BackgroundCardState extends State<BackgroundCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<String> _lottieAssets = [
    'assets/AnimatedScenes/Working with laptop.json',
    'assets/AnimatedScenes/Working with Computer.json',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        _nextAnimation();
      }
    });
  }

  void _nextAnimation() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _lottieAssets.length;
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth > 600 ? 40.0 : 24.0;
        final cardHeight = screenWidth > 600
            ? 280.0
            : 240.0; // More rectangular proportions
        final lottieSize = screenWidth > 600 ? 200.0 : 170.0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          height: cardHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              16,
            ), // Less rounded for rectangular look
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.white.withOpacity(0.1),
                      AppColors.white.withOpacity(0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Matching border radius
                  border: Border.all(
                    color: AppColors.primaryLightGray.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Simplified Lottie Carousel
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Center(
                        child: SizedBox(
                          width: lottieSize,
                          height: lottieSize,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return RadialGradient(
                                center: Alignment.center,
                                radius: 0.85,
                                colors: const [
                                  Colors.white,
                                  Colors.white,
                                  Color(0x80FFFFFF),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.4, 0.8, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Stack(
                              children: List.generate(_lottieAssets.length, (
                                index,
                              ) {
                                final isActive = _currentIndex == index;
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  opacity: isActive ? 1.0 : 0.0,
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOut,
                                    scale: isActive ? 1.0 : 0.95,
                                    child: Lottie.asset(
                                      _lottieAssets[index],
                                      fit: BoxFit.contain,
                                      repeat: true,
                                      animate: true,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Simplified Page Indicators
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _lottieAssets.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 18 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? AppColors.primaryYellow.withOpacity(0.9)
                                  : AppColors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
