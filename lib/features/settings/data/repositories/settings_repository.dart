import 'dart:async';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository_interface.dart';
import '../models/settings_model.dart';
import '../../../../core/services/user/user_data_manager.dart';
import '../../../../core/services/user/user_data.dart';

/// Implementation of the settings repository
class SettingsRepository implements SettingsRepositoryInterface {
  final UserDataManager _userDataManager;
  final StreamController<SettingsEntity> _settingsController =
      StreamController<SettingsEntity>.broadcast();

  SettingsRepository(this._userDataManager);

  @override
  Future<SettingsEntity> getSettings() async {
    final userData = await _userDataManager.getUserData();
    return SettingsModel.fromJson(userData.settings.toJson());
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    final settingsModel = SettingsModel.fromEntity(settings);

    // Create new AppSettings object
    final newAppSettings = AppSettings(
      isDarkMode: settingsModel.isDarkMode,
      accentColor: settingsModel.accentColor,
      fontSize: settingsModel.fontSize,
      enableNotifications: settingsModel.enableNotifications,
      enableSounds: settingsModel.enableSounds,
      enableVibration: settingsModel.enableVibration,
      collectAnalytics: settingsModel.collectAnalytics,
      showTasksOnLockScreen: settingsModel.showTasksOnLockScreen,
      language: settingsModel.language,
      autoSync: settingsModel.autoSync,
      syncFrequency: settingsModel.syncFrequency,
      startupScreen: settingsModel.startupScreen,
      defaultTaskPriority: settingsModel.defaultTaskPriority,
      defaultTaskView: settingsModel.defaultTaskView,
    );

    // Update the settings in user data
    await _userDataManager.updateAppSettings(newAppSettings);

    // Emit the updated settings
    _settingsController.add(settings);
  }

  @override
  Future<void> resetToDefault() async {
    final defaultSettings = SettingsModel.defaultSettings();
    await updateSettings(defaultSettings);
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    await updateSettings(settings);
  }

  @override
  Future<bool> settingsExist() async {
    try {
      await getSettings();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<SettingsEntity> getDefaultSettings() async {
    return SettingsModel.defaultSettings();
  }

  @override
  Future<Map<String, dynamic>> exportSettings() async {
    final settings = await getSettings();
    final settingsModel = SettingsModel.fromEntity(settings);
    return settingsModel.toJson();
  }

  @override
  Future<void> importSettings(Map<String, dynamic> settingsJson) async {
    final settings = SettingsModel.fromJson(settingsJson);
    await updateSettings(settings);
  }

  @override
  Stream<SettingsEntity> watchSettings() {
    return _settingsController.stream;
  }

  /// Clean up resources
  void dispose() {
    _settingsController.close();
  }
}
