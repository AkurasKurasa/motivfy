import 'package:flutter/material.dart';

/// Central color definitions for the Motivfy application.
/// Provides a consistent and scalable color palette across all features.
///
/// This class follows Feature-Based Clean Architecture principles by centralizing
/// color constants that can be reused throughout the application without coupling
/// to specific features or components.
class AppColors {
  // ================== PRIVATE CONSTRUCTOR ==================
  /// Private constructor to prevent instantiation
  AppColors._();

  // ================== WHITE & BLACK ==================

  /// Pure black color
  static const Color black = Color(0xFF000000);

  /// Dark gray color
  static const Color darkGray = Color(0xFF666666);

  /// Standard gray color
  static const Color gray = Color(0xFF525252);

  /// Medium gray color
  static const Color mediumGray = Color(0xFF636363);

  /// Light gray color
  static const Color lightGray = Color(0xFFD3D3D3);

  /// Pure white color
  static const Color white = Color(0xFFFFFFFF);

  // ================== PRIMARY COLORS ==================

  /// Primary dark color
  static const Color primaryDark = Color(0xFF181818);

  /// Primary medium color
  static const Color primaryMedium = Color(0xFF525252);

  /// Primary gray color
  static const Color primaryGray = Color(0xFF636363);

  /// Primary light gray color
  static const Color primaryLightGray = Color(0xFFD3D3D3);

  /// Primary yellow color
  static const Color primaryYellow = Color(0xFFEBBE3B);

  /// Primary orange color
  static const Color primaryOrange = Color(0xFFFE9932);

  // ================== SECONDARY COLORS ==================

  /// Secondary dark blue color
  static const Color secondaryDarkBlue = Color(0xFF093DB8);

  /// Secondary sky blue color
  static const Color secondarySkyBlue = Color(0xFF0F5FD7);

  /// Secondary electric blue color
  static const Color secondaryElectricBlue = Color(0xFF0E5ED6);

  /// Secondary steel blue color
  static const Color secondarySteelBlue = Color(0xFF3068A1);

  /// Secondary light blue color
  static const Color secondaryLightBlue = Color(0xFF4AA2FA);

  // ================== BUTTON BORDERS ==================

  /// Button border yellow color
  static const Color buttonBorderYellow = Color(0xFFFFB32B);

  /// Button border red color
  static const Color buttonBorderRed = Color(0xFFD02222);

  // ================== SUCCESS COLORS ==================

  /// Light success color
  static const Color successLight = Color(0xFF6ED37D);

  /// Standard success green color
  static const Color successGreen = Color(0xFF2EB542);

  /// Dark success green color
  static const Color successDarkGreen = Color(0xFF008B15);

  // ================== WARNING & ERROR COLORS ==================

  /// Warning color
  static const Color warning = Color(0xFFFF9933);

  /// Error color
  static const Color error = Color(0xFFFF0000);

  /// Danger color
  static const Color danger = Color(0xFFFF6666);

  // ================== SEMANTIC COLOR GROUPS ==================

  /// Grouped colors for easy access in themes
  static const List<Color> primaryColors = [
    primaryDark,
    primaryMedium,
    primaryGray,
    primaryLightGray,
    primaryYellow,
    primaryOrange,
  ];

  /// Grouped secondary colors
  static const List<Color> secondaryColors = [
    secondaryDarkBlue,
    secondarySkyBlue,
    secondaryElectricBlue,
    secondarySteelBlue,
    secondaryLightBlue,
  ];

  /// Grouped neutral colors
  static const List<Color> neutralColors = [
    black,
    darkGray,
    gray,
    mediumGray,
    lightGray,
    white,
  ];

  /// Grouped success colors
  static const List<Color> successColors = [
    successLight,
    successGreen,
    successDarkGreen,
  ];

  // ================== UTILITY METHODS ==================

  /// Get color with opacity
  ///
  /// Example:
  /// ```dart
  /// Color semiTransparentBlack = AppColors.withOpacity(AppColors.black, 0.5);
  /// ```
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get a lighter shade of the given color
  ///
  /// Example:
  /// ```dart
  /// Color lighterPrimary = AppColors.lighten(AppColors.primaryDark, 0.2);
  /// ```
  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Get a darker shade of the given color
  ///
  /// Example:
  /// ```dart
  /// Color darkerPrimary = AppColors.darken(AppColors.primaryYellow, 0.2);
  /// ```
  static Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Check if a color is considered dark
  ///
  /// Example:
  /// ```dart
  /// bool isDark = AppColors.isDarkColor(AppColors.primaryDark); // true
  /// ```
  static bool isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// Get contrasting text color (black or white) for given background
  ///
  /// Example:
  /// ```dart
  /// Color textColor = AppColors.getContrastingTextColor(AppColors.primaryYellow);
  /// ```
  static Color getContrastingTextColor(Color backgroundColor) {
    return isDarkColor(backgroundColor) ? white : black;
  }

  /// Get color by name string (useful for dynamic theming)
  ///
  /// Example:
  /// ```dart
  /// Color? color = AppColors.getColorByName('primaryYellow');
  /// ```
  static Color? getColorByName(String colorName) {
    switch (colorName.toLowerCase()) {
      // White & Black
      case 'black':
        return black;
      case 'darkgray':
        return darkGray;
      case 'gray':
        return gray;
      case 'mediumgray':
        return mediumGray;
      case 'lightgray':
        return lightGray;
      case 'white':
        return white;

      // Primary
      case 'primarydark':
        return primaryDark;
      case 'primarymedium':
        return primaryMedium;
      case 'primarygray':
        return primaryGray;
      case 'primarylightgray':
        return primaryLightGray;
      case 'primaryyellow':
        return primaryYellow;
      case 'primaryorange':
        return primaryOrange;

      // Secondary
      case 'secondarydarkblue':
        return secondaryDarkBlue;
      case 'secondaryskyblue':
        return secondarySkyBlue;
      case 'secondaryelectricblue':
        return secondaryElectricBlue;
      case 'secondarysteelblue':
        return secondarySteelBlue;
      case 'secondarylightblue':
        return secondaryLightBlue;

      // Button Borders
      case 'buttonborderyellow':
        return buttonBorderYellow;
      case 'buttonborderred':
        return buttonBorderRed;

      // Success
      case 'successlight':
        return successLight;
      case 'successgreen':
        return successGreen;
      case 'successdarkgreen':
        return successDarkGreen;

      // Warning & Error
      case 'warning':
        return warning;
      case 'error':
        return error;
      case 'danger':
        return danger;

      default:
        return null;
    }
  }

  /// Get all available color names
  ///
  /// Useful for debugging or building dynamic color pickers
  static List<String> getAllColorNames() {
    return [
      'black',
      'darkGray',
      'gray',
      'mediumGray',
      'lightGray',
      'white',
      'primaryDark',
      'primaryMedium',
      'primaryGray',
      'primaryLightGray',
      'primaryYellow',
      'primaryOrange',
      'secondaryDarkBlue',
      'secondarySkyBlue',
      'secondaryElectricBlue',
      'secondarySteelBlue',
      'secondaryLightBlue',
      'buttonBorderYellow',
      'buttonBorderRed',
      'successLight',
      'successGreen',
      'successDarkGreen',
      'warning',
      'error',
      'danger',
    ];
  }
}
