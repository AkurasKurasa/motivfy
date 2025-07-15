import 'dart:ui';
import 'package:flutter/material.dart';

/// Represents a customizable widget for displaying content.
class CustomWidget extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final Widget? childWidget;
  final double? width;
  final double? height;
  final TextStyle? titleStyle;
  final AlignmentGeometry contentAlignment;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Color borderColor;
  final double borderOpacity;
  final double borderWidth;
  final Widget? foreground;
  final Color? backgroundColor;

  const CustomWidget({
    super.key,
    this.title,
    this.imagePath,
    this.childWidget,
    this.width,
    this.height,
    this.titleStyle,
    this.contentAlignment = Alignment.center,
    this.padding = const EdgeInsets.all(0.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(7.0)),
    this.borderColor = const Color(0xFF636363),
    this.borderOpacity = 1.0,
    this.borderWidth = 2.0,
    this.foreground,
    this.backgroundColor = const Color(0xFF1C2526),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: borderColor.withOpacity(borderOpacity),
          width: borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge, // Optional: improves performance
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Glassmorphic Blur Effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(color: const Color(0xFF1C1C1C).withOpacity(0.2)),
            ),

            // Content
            if (childWidget != null)
              Padding(padding: padding, child: childWidget!)
            else if (title != null || imagePath != null)
              Align(
                alignment: contentAlignment,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth;
                      final maxHeight = constraints.maxHeight;

                      final textSize = (maxWidth / 50).clamp(12.0, 18.0);
                      final imageHeight = (maxHeight * 0.3).clamp(50.0, 100.0);

                      return SizedBox(
                        width: maxWidth,
                        height: maxHeight,
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                            ),
                            child: Column(
                              crossAxisAlignment: _mapAlignmentToCrossAxis(
                                contentAlignment,
                              ),
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (title != null)
                                  Text(
                                    title!,
                                    style:
                                        titleStyle ??
                                        TextStyle(
                                          fontSize: textSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                if (imagePath != null) ...[
                                  const SizedBox(height: 10),
                                  Image.asset(imagePath!, height: imageHeight),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Optional Foreground
            if (foreground != null) foreground!,
          ],
        ),
      ),
    );
  }

  /// Maps alignment geometry to cross axis alignment for column layout.
  CrossAxisAlignment _mapAlignmentToCrossAxis(AlignmentGeometry alignment) {
    if (alignment == Alignment.center ||
        alignment == Alignment.topCenter ||
        alignment == Alignment.bottomCenter) {
      return CrossAxisAlignment.center;
    } else if (alignment == Alignment.centerLeft ||
        alignment == Alignment.topLeft ||
        alignment == Alignment.bottomLeft) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.end;
    }
  }
}
