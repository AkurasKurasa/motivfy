import 'package:flutter/material.dart';

/// Optimized image widget for better performance
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade300,
              child: const Icon(Icons.error_outline, color: Colors.grey),
            ),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 200), // Fast fade-in
            child: child,
          );
        },
      ),
    );
  }
}

/// Optimized avatar widget with caching
class OptimizedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Widget? child;

  const OptimizedAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey.shade300,
        backgroundImage: imageUrl != null ? AssetImage(imageUrl!) : null,
        child: child,
      ),
    );
  }
}
