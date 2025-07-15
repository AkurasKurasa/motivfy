import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'glassmorphic_container.dart';

class MessageBubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final bool isFirst;
  final bool isLast;

  const MessageBubble({
    super.key,
    required this.isUser,
    required this.text,
    this.isFirst = false,
    this.isLast = false,
  });

  List<TextSpan> _buildStyledTextSpans(String text) {
    final lines = text.split('\n');

    return [
      for (int i = 0; i < lines.length; i++) ...[
        ..._styledLine(lines[i]),
        if (i != lines.length - 1) const TextSpan(text: '\n'),
      ],
    ];
  }

  List<TextSpan> _styledLine(String line) {
    TextStyle style = isUser
        ? AppTextStyles.body16Regular.copyWith(
            color: AppColors.white.withOpacity(0.95),
            fontWeight: FontWeight.w500,
            height: 1.5,
          )
        : AppTextStyles.body16Regular.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w400,
            height: 1.6,
          );

    if (line.startsWith('#### ')) {
      style = style.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isUser
            ? AppColors.white
            : AppColors.primaryYellow.withOpacity(0.9),
      );
      line = line.replaceFirst('#### ', '');
    } else if (line.startsWith('### ')) {
      style = style.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: isUser ? AppColors.white : AppColors.primaryYellow,
      );
      line = line.replaceFirst('### ', '');
    } else if (line.startsWith('## ')) {
      style = style.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: isUser ? AppColors.white : AppColors.primaryYellow,
      );
      line = line.replaceFirst('## ', '');
    } else if (line.startsWith('# ')) {
      style = style.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isUser ? AppColors.white : AppColors.primaryYellow,
      );
      line = line.replaceFirst('# ', '');
    }

    final parts = line.split('**');
    return [
      for (int i = 0; i < parts.length; i++)
        TextSpan(
          text: parts[i],
          style: i % 2 == 1
              ? style.copyWith(fontWeight: FontWeight.bold)
              : style,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: isFirst ? 600 : 300),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              margin: EdgeInsets.only(
                top: isFirst ? 20 : 12,
                bottom: isLast ? 20 : 4,
                left: isUser ? 60 : 0,
                right: isUser ? 0 : 60,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isUser
                      ? [
                          BoxShadow(
                            color: AppColors.secondaryElectricBlue.withOpacity(
                              0.3,
                            ),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppColors.primaryYellow.withOpacity(0.2),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: GlassmorphicContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  opacity: isUser ? 0.18 : 0.12,
                  blur: 20,
                  borderColor: isUser
                      ? AppColors.secondaryElectricBlue.withOpacity(0.4)
                      : AppColors.white.withOpacity(0.25),
                  borderWidth: isUser ? 1.8 : 1.2,
                  child: Container(
                    decoration: isUser
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.secondaryElectricBlue.withOpacity(
                                  0.15,
                                ),
                                AppColors.secondarySkyBlue.withOpacity(0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          )
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.white.withOpacity(0.05),
                                AppColors.primaryYellow.withOpacity(0.03),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryYellow,
                                        AppColors.primaryOrange,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryYellow
                                            .withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.white,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        RichText(
                          text: TextSpan(children: _buildStyledTextSpans(text)),
                        ),
                      ],
                    ),
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
