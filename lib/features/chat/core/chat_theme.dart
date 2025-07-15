import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Chat-specific theme constants following Feature-based Clean Architecture.
///
/// This class centralizes all chat-related color and theme constants,
/// ensuring consistency between chat components while maintaining
/// separation of concerns within the chat feature.
class ChatTheme {
  // ================== PRIVATE CONSTRUCTOR ==================
  /// Private constructor to prevent instantiation
  ChatTheme._();

  // ================== BACKGROUND GRADIENTS ==================

  /// Main chat background gradient matching the chat page
  static const List<Color> backgroundGradient = [
    Color(0xFF000000), // Pure black at top
    Color(0xFF000000), // Black continues
    Color(0xFF111111), // Very subtle grey transition
    Color(0xFF1A1A1A), // Slightly lighter grey at bottom
  ];

  /// Background gradient stops
  static const List<double> backgroundGradientStops = [0.0, 0.5, 0.8, 1.0];

  /// Drawer background gradient
  static const List<Color> drawerBackgroundGradient = [
    Color(0xFF000000), // Pure black at top
    Color(0xFF111111), // Very subtle grey transition
    Color(0xFF1A1A1A), // Slightly lighter grey at bottom
  ];

  // ================== GLASSMORPHIC EFFECTS ==================

  /// Glassmorphic container background color
  static Color get glassmorphicBackground => AppColors.black.withOpacity(0.3);

  /// Glassmorphic border color
  static Color get glassmorphicBorder => AppColors.white.withOpacity(0.2);

  /// Glassmorphic border secondary color
  static Color get glassmorphicBorderSecondary =>
      AppColors.white.withOpacity(0.3);

  // ================== ACCENT COLORS ==================

  /// Primary accent gradient colors
  static const List<Color> primaryAccentGradient = [
    Color(0xFF00D4FF), // Cyan
    Color(0xFF9B59B6), // Purple
  ];

  /// Secondary accent gradient colors
  static const List<Color> secondaryAccentGradient = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Violet
  ];

  /// Chat bubble accent colors
  static const List<Color> chatBubbleAccent = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF7C3AED), // Violet
  ];

  // ================== TEXT COLORS ==================

  /// Primary text color
  static const Color primaryText = AppColors.white;

  /// Secondary text color
  static Color get secondaryText => AppColors.white.withOpacity(0.7);

  /// Tertiary text color
  static Color get tertiaryText => AppColors.white.withOpacity(0.6);

  /// Quaternary text color (most subtle)
  static Color get quaternaryText => AppColors.white.withOpacity(0.5);

  // ================== SHADOW COLORS ==================

  /// Primary glow shadow
  static Color get primaryGlow => const Color(0xFF00D4FF).withOpacity(0.3);

  /// Secondary glow shadow
  static Color get secondaryGlow => const Color(0xFF9B59B6).withOpacity(0.3);

  // ================== UTILITY METHODS ==================

  /// Get glassmorphic decoration for containers
  static BoxDecoration getGlassmorphicDecoration({
    double opacity = 0.15,
    double borderOpacity = 0.3,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: AppColors.black.withOpacity(opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.white.withOpacity(borderOpacity),
        width: 1,
      ),
    );
  }

  /// Get primary accent gradient decoration
  static BoxDecoration getPrimaryAccentDecoration({
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      gradient: const LinearGradient(colors: primaryAccentGradient),
      boxShadow:
          boxShadow ??
          [BoxShadow(color: primaryGlow, blurRadius: 10, spreadRadius: 1)],
    );
  }

  /// Get secondary accent gradient decoration
  static BoxDecoration getSecondaryAccentDecoration({
    BorderRadius? borderRadius,
    double opacity = 0.6,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          secondaryAccentGradient[0].withOpacity(opacity),
          secondaryAccentGradient[1].withOpacity(opacity),
        ],
      ),
    );
  }

  /// Get chat bubble decoration
  static BoxDecoration getChatBubbleDecoration({
    BorderRadius? borderRadius,
    double opacity = 0.6,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          chatBubbleAccent[0].withOpacity(opacity),
          chatBubbleAccent[1].withOpacity(opacity),
        ],
      ),
    );
  }
}
