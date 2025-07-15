/// Font family constants for the Motivfy application.
/// Provides centralized font family definitions following Feature-Based Clean Architecture.
///
/// This class defines Helvetica font family variants that can be used throughout
/// the application for consistent typography without coupling to specific features.
class AppFontFamilies {
  // ================== PRIVATE CONSTRUCTOR ==================
  /// Private constructor to prevent instantiation
  AppFontFamilies._();

  // ================== HELVETICA FONT FAMILIES ==================

  /// Helvetica Regular font family
  static const String regular = 'Helvetica-Regular';

  /// Helvetica Bold font family
  static const String bold = 'Helvetica-Bold';

  /// Helvetica Light font family
  static const String light = 'Helvetica-Light';

  /// Helvetica Rounded font family
  static const String rounded = 'Helvetica-Rounded';

  /// Helvetica Compressed font family
  static const String compressed = 'Helvetica-Compressed';

  // ================== FONT FAMILY COLLECTIONS ==================

  /// All available font families for iteration or validation
  static const List<String> allFontFamilies = [
    regular,
    bold,
    light,
    rounded,
    compressed,
  ];

  // ================== UTILITY METHODS ==================

  /// Validate if a font family exists in our defined set
  ///
  /// Example:
  /// ```dart
  /// bool isValid = AppFontFamilies.isValidFontFamily('Helvetica-Bold'); // true
  /// ```
  static bool isValidFontFamily(String fontFamily) {
    return allFontFamilies.contains(fontFamily);
  }

  /// Get font family by name (useful for dynamic font selection)
  ///
  /// Example:
  /// ```dart
  /// String? fontFamily = AppFontFamilies.getFontFamilyByName('bold');
  /// ```
  static String? getFontFamilyByName(String name) {
    switch (name.toLowerCase()) {
      case 'regular':
        return regular;
      case 'bold':
        return bold;
      case 'light':
        return light;
      case 'rounded':
        return rounded;
      case 'compressed':
        return compressed;
      default:
        return null;
    }
  }

  /// Get all font family names for debugging or UI components
  static List<String> getAllFontFamilyNames() {
    return ['regular', 'bold', 'light', 'rounded', 'compressed'];
  }
}
