import 'package:flutter/material.dart';

class CustomTaskProgress extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;

  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets padding;

  final Color textColor;
  final TextStyle? textStyle;

  final Color progressColor;
  final Color progressBackgroundColor;
  final Duration animationDuration;

  const CustomTaskProgress({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    this.width,
    this.height,
    this.backgroundColor, // override gradient if set
    this.borderColor = Colors.grey,
    this.borderWidth = 1.5,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(10),
    this.textColor = Colors.white,
    this.textStyle,
    this.progressColor = const Color(0xFFCDFF3F),
    this.progressBackgroundColor = const Color(0xFF303030),
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalTasks == 0
        ? 0
        : (completedTasks / totalTasks).clamp(0.0, 1.0);

    final screenWidth = MediaQuery.of(context).size.width;
    final double effectiveWidth = width ?? screenWidth * 0.85;
    final double effectiveHeight = height ?? 60.0;

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor, // overrides gradient if set
        gradient: backgroundColor == null
            ? const RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  Color.fromRGBO(11, 11, 11, 0.35), // #0B0B0B @ 35%
                  Color.fromRGBO(38, 38, 38, 0.35), // #262626 @ 35%
                  Color.fromRGBO(121, 116, 116, 0.35), // #797474 @ 35%
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        children: [
          // Task text
          Text(
            "$completedTasks / $totalTasks tasks left",
            style:
                (textStyle?.copyWith(color: textColor) ??
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                )),
          ),
          const SizedBox(width: 12),

          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                children: [
                  Container(height: 16, color: progressBackgroundColor),
                  AnimatedContainer(
                    duration: animationDuration,
                    height: 16,
                    width:
                        (effectiveWidth - padding.horizontal - 100) *
                        progress, // adjust width subtracting label
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
