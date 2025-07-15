import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/assets/animations.dart';
import 'message_bubble.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, String>> messages;
  final ScrollController scrollController;

  const ChatList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1000),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryYellow,
                            AppColors.primaryOrange,
                            AppColors.secondaryElectricBlue,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryYellow.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 3,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: AppColors.secondaryElectricBlue.withOpacity(
                              0.3,
                            ),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Lottie.asset(
                            AppAnimations.motivfyLogo,
                            fit: BoxFit.cover,
                            repeat: true,
                            animate: true,
                            errorBuilder: (context, error, stackTrace) {
                              print('Lottie error: $error');
                              // Fallback to original icon if Lottie fails
                              return Icon(
                                Icons.auto_awesome_rounded,
                                color: AppColors.white,
                                size: 60,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppColors.white,
                          AppColors.primaryYellow.withOpacity(0.8),
                          AppColors.white,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(bounds),
                      child: Text(
                        'Start a conversation with Motiv-fy',
                        style: AppTextStyles.headline20Rounded.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ask me anything about productivity, motivation,\nor how I can help you achieve your goals.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body16Regular.copyWith(
                        color: AppColors.white.withOpacity(0.75),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message['role'] == 'user';
        final isFirst = index == 0;
        final isLast = index == messages.length - 1;

        return MessageBubble(
          isUser: isUser,
          text: message['text'] ?? '',
          isFirst: isFirst,
          isLast: isLast,
        );
      },
    );
  }
}
