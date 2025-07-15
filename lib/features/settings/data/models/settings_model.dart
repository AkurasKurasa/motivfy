import 'package:flutter/material.dart';
import '../../domain/entities/settings_entity.dart';

/// Data model for settings with JSON serialization capabilities
class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.isDarkMode,
    required super.accentColor,
    required super.fontSize,
    required super.enableNotifications,
    required super.enableSounds,
    required super.enableVibration,
    required super.collectAnalytics,
    required super.showTasksOnLockScreen,
    required super.language,
    required super.autoSync,
    required super.syncFrequency,
    required super.startupScreen,
    required super.defaultTaskPriority,
    required super.defaultTaskView,
  });

  /// Create a SettingsModel from a SettingsEntity
  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      isDarkMode: entity.isDarkMode,
      accentColor: entity.accentColor,
      fontSize: entity.fontSize,
      enableNotifications: entity.enableNotifications,
      enableSounds: entity.enableSounds,
      enableVibration: entity.enableVibration,
      collectAnalytics: entity.collectAnalytics,
      showTasksOnLockScreen: entity.showTasksOnLockScreen,
      language: entity.language,
      autoSync: entity.autoSync,
      syncFrequency: entity.syncFrequency,
      startupScreen: entity.startupScreen,
      defaultTaskPriority: entity.defaultTaskPriority,
      defaultTaskView: entity.defaultTaskView,
    );
  }

  /// Create a SettingsModel from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      isDarkMode: json['isDarkMode'] ?? true,
      accentColor: Color(json['accentColor'] ?? Colors.blue.value),
      fontSize: json['fontSize']?.toDouble() ?? 14.0,
      enableNotifications: json['enableNotifications'] ?? true,
      enableSounds: json['enableSounds'] ?? true,
      enableVibration: json['enableVibration'] ?? true,
      collectAnalytics: json['collectAnalytics'] ?? false,
      showTasksOnLockScreen: json['showTasksOnLockScreen'] ?? false,
      language: json['language'] ?? 'English',
      autoSync: json['autoSync'] ?? true,
      syncFrequency: json['syncFrequency'] ?? 60,
      startupScreen: json['startupScreen'] ?? true,
      defaultTaskPriority: json['defaultTaskPriority'] ?? 1,
      defaultTaskView: json['defaultTaskView'] ?? 'list',
    );
  }

  /// Create default settings
  factory SettingsModel.defaultSettings() {
    return const SettingsModel(
      isDarkMode: true,
      accentColor: Colors.blue,
      fontSize: 14.0,
      enableNotifications: true,
      enableSounds: true,
      enableVibration: true,
      collectAnalytics: false,
      showTasksOnLockScreen: false,
      language: 'English',
      autoSync: true,
      syncFrequency: 60,
      startupScreen: true,
      defaultTaskPriority: 1,
      defaultTaskView: 'list',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'accentColor': accentColor.value,
      'fontSize': fontSize,
      'enableNotifications': enableNotifications,
      'enableSounds': enableSounds,
      'enableVibration': enableVibration,
      'collectAnalytics': collectAnalytics,
      'showTasksOnLockScreen': showTasksOnLockScreen,
      'language': language,
      'autoSync': autoSync,
      'syncFrequency': syncFrequency,
      'startupScreen': startupScreen,
      'defaultTaskPriority': defaultTaskPriority,
      'defaultTaskView': defaultTaskView,
    };
  }

  /// Create a copy with updated values
  @override
  SettingsModel copyWith({
    bool? isDarkMode,
    Color? accentColor,
    double? fontSize,
    bool? enableNotifications,
    bool? enableSounds,
    bool? enableVibration,
    bool? collectAnalytics,
    bool? showTasksOnLockScreen,
    String? language,
    bool? autoSync,
    int? syncFrequency,
    bool? startupScreen,
    int? defaultTaskPriority,
    String? defaultTaskView,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      accentColor: accentColor ?? this.accentColor,
      fontSize: fontSize ?? this.fontSize,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableSounds: enableSounds ?? this.enableSounds,
      enableVibration: enableVibration ?? this.enableVibration,
      collectAnalytics: collectAnalytics ?? this.collectAnalytics,
      showTasksOnLockScreen:
          showTasksOnLockScreen ?? this.showTasksOnLockScreen,
      language: language ?? this.language,
      autoSync: autoSync ?? this.autoSync,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      startupScreen: startupScreen ?? this.startupScreen,
      defaultTaskPriority: defaultTaskPriority ?? this.defaultTaskPriority,
      defaultTaskView: defaultTaskView ?? this.defaultTaskView,
    );
  }
}
