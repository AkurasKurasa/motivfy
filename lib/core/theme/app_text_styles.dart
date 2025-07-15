import 'package:flutter/material.dart';
import 'app_font_families.dart';

/// Central text style definitions for the Motivfy application.
/// Provides a scalable typography system based on Helvetica fonts with optimized line heights.
///
/// This class follows Feature-Based Clean Architecture principles by centralizing
/// text styles that can be reused throughout the application without coupling
/// to specific features or components.
///
/// Color handling is intentionally excluded - use AppColors for color management.
class AppTextStyles {
  // ================== PRIVATE CONSTRUCTOR ==================
  /// Private constructor to prevent instantiation
  AppTextStyles._();

  // ================== FONT WEIGHT CONSTANTS ==================

  /// Light font weight (FontWeight.w300)
  static const FontWeight light = FontWeight.w300;

  /// Regular font weight (FontWeight.w400)
  static const FontWeight regular = FontWeight.w400;

  /// Medium font weight (FontWeight.w500)
  static const FontWeight medium = FontWeight.w500;

  /// Bold font weight (FontWeight.w700)
  static const FontWeight bold = FontWeight.w700;

  // ================== HEADLINE TEXT STYLES ==================

  /// Headline 32pt Bold - Large display text
  /// Font: Helvetica Bold, Size: 32, Line Height: 1.25
  static const TextStyle headline32Bold = TextStyle(
    fontSize: 32,
    fontWeight: bold,
    fontFamily: AppFontFamilies.bold,
    height: 1.25,
  );

  /// Headline 28pt Regular - Large header text
  /// Font: Helvetica Regular, Size: 28, Line Height: 1.29
  static const TextStyle headline28Regular = TextStyle(
    fontSize: 28,
    fontWeight: regular,
    fontFamily: AppFontFamilies.regular,
    height: 1.29,
  );

  /// Headline 24pt Light - Medium header text
  /// Font: Helvetica Light, Size: 24, Line Height: 1.33
  static const TextStyle headline24Light = TextStyle(
    fontSize: 24,
    fontWeight: light,
    fontFamily: AppFontFamilies.light,
    height: 1.33,
  );

  /// Headline 20pt Rounded - Small header text with rounded font
  /// Font: Helvetica Rounded, Size: 20, Line Height: 1.4
  static const TextStyle headline20Rounded = TextStyle(
    fontSize: 20,
    fontWeight: medium,
    fontFamily: AppFontFamilies.rounded,
    height: 1.4,
  );

  /// Headline 18pt Compressed - Compact header text
  /// Font: Helvetica Compressed, Size: 18, Line Height: 1.44
  static const TextStyle headline18Compressed = TextStyle(
    fontSize: 18,
    fontWeight: medium,
    fontFamily: AppFontFamilies.compressed,
    height: 1.44,
  );

  // ================== BODY TEXT STYLES ==================

  /// Body 16pt Regular - Standard body text
  /// Font: Helvetica Regular, Size: 16, Line Height: 1.5
  static const TextStyle body16Regular = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    fontFamily: AppFontFamilies.regular,
    height: 1.5,
  );

  /// Body 14pt Light - Light body text
  /// Font: Helvetica Light, Size: 14, Line Height: 1.57
  static const TextStyle body14Light = TextStyle(
    fontSize: 14,
    fontWeight: light,
    fontFamily: AppFontFamilies.light,
    height: 1.57,
  );

  /// Body 12pt Rounded - Small body text with rounded font
  /// Font: Helvetica Rounded, Size: 12, Line Height: 1.5
  static const TextStyle body12Rounded = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    fontFamily: AppFontFamilies.rounded,
    height: 1.5,
  );

  // ================== TEXT STYLE COLLECTIONS ==================

  /// All headline text styles for iteration or validation
  static const List<TextStyle> headlineStyles = [
    headline32Bold,
    headline28Regular,
    headline24Light,
    headline20Rounded,
    headline18Compressed,
  ];

  /// All body text styles for iteration or validation
  static const List<TextStyle> bodyStyles = [
    body16Regular,
    body14Light,
    body12Rounded,
  ];

  /// All available text styles
  static const List<TextStyle> allTextStyles = [
    ...headlineStyles,
    ...bodyStyles,
  ];

  // ================== UTILITY METHODS ==================

  /// Create a custom text style with color override
  ///
  /// Example:
  /// ```dart
  /// TextStyle styledText = AppTextStyles.withColor(
  ///   AppTextStyles.headline32Bold,
  ///   AppColors.primaryYellow,
  /// );
  /// ```
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }

  /// Create a custom text style with opacity
  ///
  /// Example:
  /// ```dart
  /// TextStyle transparentText = AppTextStyles.withOpacity(
  ///   AppTextStyles.body16Regular,
  ///   0.7,
  /// );
  /// ```
  static TextStyle withOpacity(TextStyle baseStyle, double opacity) {
    return baseStyle.copyWith(
      color: (baseStyle.color ?? const Color(0xFF000000)).withOpacity(opacity),
    );
  }

  /// Create a text style with custom modifications
  ///
  /// Example:
  /// ```dart
  /// TextStyle customStyle = AppTextStyles.custom(
  ///   baseStyle: AppTextStyles.body16Regular,
  ///   color: AppColors.primaryDark,
  ///   fontSize: 18,
  ///   fontWeight: AppTextStyles.bold,
  /// );
  /// ```
  static TextStyle custom({
    required TextStyle baseStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return baseStyle.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Get text style by name (useful for dynamic styling)
  ///
  /// Example:
  /// ```dart
  /// TextStyle? style = AppTextStyles.getStyleByName('headline32Bold');
  /// ```
  static TextStyle? getStyleByName(String styleName) {
    switch (styleName.toLowerCase()) {
      // Headlines
      case 'headline32bold':
        return headline32Bold;
      case 'headline28regular':
        return headline28Regular;
      case 'headline24light':
        return headline24Light;
      case 'headline20rounded':
        return headline20Rounded;
      case 'headline18compressed':
        return headline18Compressed;

      // Body
      case 'body16regular':
        return body16Regular;
      case 'body14light':
        return body14Light;
      case 'body12rounded':
        return body12Rounded;

      default:
        return null;
    }
  }

  /// Get all available text style names
  ///
  /// Useful for debugging or building dynamic text style selectors
  static List<String> getAllStyleNames() {
    return [
      'headline32Bold',
      'headline28Regular',
      'headline24Light',
      'headline20Rounded',
      'headline18Compressed',
      'body16Regular',
      'body14Light',
      'body12Rounded',
    ];
  }

  /// Scale a text style by a factor (useful for responsive design)
  ///
  /// Example:
  /// ```dart
  /// TextStyle scaledStyle = AppTextStyles.scale(
  ///   AppTextStyles.headline32Bold,
  ///   1.2, // 20% larger
  /// );
  /// ```
  static TextStyle scale(TextStyle baseStyle, double scaleFactor) {
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 16) * scaleFactor,
    );
  }

  /// Create a responsive text style based on screen size
  ///
  /// Example:
  /// ```dart
  /// TextStyle responsiveStyle = AppTextStyles.responsive(
  ///   mobile: AppTextStyles.body14Light,
  ///   tablet: AppTextStyles.body16Regular,
  ///   desktop: AppTextStyles.headline20Rounded,
  ///   screenWidth: MediaQuery.of(context).size.width,
  /// );
  /// ```
  static TextStyle responsive({
    required TextStyle mobile,
    required TextStyle tablet,
    required TextStyle desktop,
    required double screenWidth,
    double mobileBreakpoint = 600,
    double tabletBreakpoint = 1024,
  }) {
    if (screenWidth < mobileBreakpoint) {
      return mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return tablet;
    } else {
      return desktop;
    }
  }

  /// Create adaptive text style for different platforms
  ///
  /// Example:
  /// ```dart
  /// TextStyle adaptiveStyle = AppTextStyles.adaptive(
  ///   defaultStyle: AppTextStyles.body16Regular,
  ///   iosStyle: AppTextStyles.body14Light,
  ///   androidStyle: AppTextStyles.body16Regular,
  /// );
  /// ```
  static TextStyle adaptive({
    required TextStyle defaultStyle,
    TextStyle? iosStyle,
    TextStyle? androidStyle,
    TextStyle? webStyle,
    TextStyle? macosStyle,
    TextStyle? windowsStyle,
    TextStyle? linuxStyle,
  }) {
    // This would typically use Platform.isIOS, Platform.isAndroid, etc.
    // For now, return the default style as a placeholder
    return defaultStyle;
  }
}
