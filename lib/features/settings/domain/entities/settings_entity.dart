import 'package:flutter/material.dart';

/// Settings entity representing the app settings domain model
class SettingsEntity {
  // Theme settings
  final bool isDarkMode;
  final Color accentColor;
  final double fontSize;

  // Notification settings
  final bool enableNotifications;
  final bool enableSounds;
  final bool enableVibration;

  // Privacy settings
  final bool collectAnalytics;
  final bool showTasksOnLockScreen;

  // General settings
  final String language;
  final bool autoSync;
  final int syncFrequency; // In minutes
  final bool startupScreen; // Which screen to show on startup

  // Task settings
  final int defaultTaskPriority; // 0: Low, 1: Medium, 2: High
  final String defaultTaskView; // 'list', 'calendar', 'kanban'

  const SettingsEntity({
    required this.isDarkMode,
    required this.accentColor,
    required this.fontSize,
    required this.enableNotifications,
    required this.enableSounds,
    required this.enableVibration,
    required this.collectAnalytics,
    required this.showTasksOnLockScreen,
    required this.language,
    required this.autoSync,
    required this.syncFrequency,
    required this.startupScreen,
    required this.defaultTaskPriority,
    required this.defaultTaskView,
  });

  /// Create a copy of this entity with some values updated
  SettingsEntity copyWith({
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
    return SettingsEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsEntity &&
        other.isDarkMode == isDarkMode &&
        other.accentColor == accentColor &&
        other.fontSize == fontSize &&
        other.enableNotifications == enableNotifications &&
        other.enableSounds == enableSounds &&
        other.enableVibration == enableVibration &&
        other.collectAnalytics == collectAnalytics &&
        other.showTasksOnLockScreen == showTasksOnLockScreen &&
        other.language == language &&
        other.autoSync == autoSync &&
        other.syncFrequency == syncFrequency &&
        other.startupScreen == startupScreen &&
        other.defaultTaskPriority == defaultTaskPriority &&
        other.defaultTaskView == defaultTaskView;
  }

  @override
  int get hashCode {
    return isDarkMode.hashCode ^
        accentColor.hashCode ^
        fontSize.hashCode ^
        enableNotifications.hashCode ^
        enableSounds.hashCode ^
        enableVibration.hashCode ^
        collectAnalytics.hashCode ^
        showTasksOnLockScreen.hashCode ^
        language.hashCode ^
        autoSync.hashCode ^
        syncFrequency.hashCode ^
        startupScreen.hashCode ^
        defaultTaskPriority.hashCode ^
        defaultTaskView.hashCode;
  }
}
