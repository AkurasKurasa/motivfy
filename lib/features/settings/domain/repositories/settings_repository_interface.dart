import '../entities/settings_entity.dart';

/// Repository interface for settings operations
abstract class SettingsRepositoryInterface {
  /// Get current app settings
  Future<SettingsEntity> getSettings();

  /// Update app settings
  Future<void> updateSettings(SettingsEntity settings);

  /// Reset settings to default values
  Future<void> resetToDefault();

  /// Save settings to persistent storage
  Future<void> saveSettings(SettingsEntity settings);

  /// Check if settings exist
  Future<bool> settingsExist();

  /// Get default settings
  Future<SettingsEntity> getDefaultSettings();

  /// Export settings to JSON
  Future<Map<String, dynamic>> exportSettings();

  /// Import settings from JSON
  Future<void> importSettings(Map<String, dynamic> settingsJson);

  /// Watch for settings changes
  Stream<SettingsEntity> watchSettings();
}
