import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/animated_return_button.dart';
import 'package:motiv_fy/core/services/universal_navigation_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'glassmorphic_container.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const ChatHeader({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: GlassmorphicContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.18,
                  blur: 25,
                  borderColor: AppColors.white.withOpacity(0.35),
                  borderWidth: 1.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 1000),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutQuart,
                              builder: (context, buttonValue, child) {
                                return Transform.rotate(
                                  angle: (1 - buttonValue) * 0.5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.white.withOpacity(0.15),
                                          AppColors.white.withOpacity(0.05),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(
                                          0.25,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryYellow
                                              .withOpacity(0.2),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: AnimatedReturnButton(
                                      padding: const EdgeInsets.all(0),
                                      size: 44,
                                      onPressed: () =>
                                          UniversalNavigationService.navigateToHome(
                                            context,
                                          ),
                                      tooltip: 'Return to Home',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 1200),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutBack,
                              builder: (context, textValue, child) {
                                return Transform.translate(
                                  offset: Offset((1 - textValue) * 30, 0),
                                  child: Opacity(
                                    opacity: textValue.clamp(0.0, 1.0),
                                    child: Flexible(
                                      child: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                              colors: [
                                                AppColors.white,
                                                AppColors.primaryYellow
                                                    .withOpacity(0.8),
                                                AppColors.white,
                                              ],
                                              stops: const [0.0, 0.5, 1.0],
                                            ).createShader(bounds),
                                        child: Text(
                                          "Motiv-fy Chat",
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.headline24Light
                                              .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.8,
                                                shadows: [
                                                  Shadow(
                                                    color: AppColors
                                                        .primaryYellow
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 900),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, menuValue, child) {
                          return Transform.scale(
                            scale: menuValue,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.white.withOpacity(0.25),
                                    AppColors.white.withOpacity(0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.35),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryYellow.withOpacity(
                                      0.15,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: onMenuPressed,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.menu_rounded,
                                      color: AppColors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
