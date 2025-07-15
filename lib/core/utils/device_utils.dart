import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Utility class for device-specific performance optimizations
class DeviceUtils {
  static bool? _isLowEndDevice;
  static bool? _overrideIsLowEndDevice; // For testing

  /// Override device detection for testing
  static void overrideIsLowEndDevice(bool? override) {
    _overrideIsLowEndDevice = override;
    _isLowEndDevice = null; // Reset cache
  }

  /// Detect if device is low-end to apply performance optimizations
  static bool get isLowEndDevice {
    if (_overrideIsLowEndDevice != null) return _overrideIsLowEndDevice!;
    if (_isLowEndDevice != null) return _isLowEndDevice!;

    // Use kIsWeb for web detection, and handle test environment
    if (kIsWeb) {
      _isLowEndDevice = false; // Web is generally high-end
    } else {
      try {
        // More sophisticated detection for better accuracy
        if (Platform.isAndroid) {
          // Conservative approach - you can enhance with device_info_plus later
          _isLowEndDevice = true; // Default to optimization for Android
        } else if (Platform.isIOS) {
          // iOS devices generally have better performance
          _isLowEndDevice = false;
        } else {
          _isLowEndDevice = false;
        }
      } catch (e) {
        // In test environment, Platform might not be available
        _isLowEndDevice = false; // Default to high-end for tests
      }
    }

    return _isLowEndDevice!;
  }

  /// Should reduce animations for better performance
  static bool get shouldReduceAnimations => isLowEndDevice;

  /// Should reduce image quality for better performance
  static bool get shouldReduceImageQuality => isLowEndDevice;

  /// Get animation duration based on device capability
  static Duration getAnimationDuration(Duration normalDuration) {
    if (shouldReduceAnimations) {
      return Duration(
        milliseconds: (normalDuration.inMilliseconds * 0.7).round(),
      );
    }
    return normalDuration;
  }

  /// Get optimized cache size based on device capability
  static int getOptimalCacheSize() {
    return isLowEndDevice ? 50 : 100;
  }

  /// Get optimal timer update frequency for performance
  static Duration getTimerUpdateInterval() {
    return isLowEndDevice
        ? const Duration(milliseconds: 100) // Less frequent for low-end
        : const Duration(milliseconds: 16); // 60 FPS for high-end
  }

  /// Get optimal animation update frequency
  static Duration getAnimationUpdateInterval() {
    return isLowEndDevice
        ? const Duration(milliseconds: 500) // Much less frequent
        : const Duration(milliseconds: 100); // Standard update rate
  }
}

/// Performance monitoring utility for debugging
class PerformanceMonitor {
  static void startTimer(String name) {
    developer.Timeline.startSync(name);
  }

  static void endTimer() {
    developer.Timeline.finishSync();
  }

  static T measureSync<T>(String name, T Function() function) {
    developer.Timeline.startSync(name);
    try {
      return function();
    } finally {
      developer.Timeline.finishSync();
    }
  }

  static Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    developer.Timeline.startSync(operationName);
    try {
      return await operation();
    } finally {
      developer.Timeline.finishSync();
    }
  }

  static void logMemoryUsage(String location) {
    developer.log('Memory usage at $location');
  }

  static void measureFeatureLoad(String featureName, void Function() function) {
    developer.Timeline.startSync('$featureName-load');
    try {
      function();
    } finally {
      developer.Timeline.finishSync();
    }
  }
}

/// Memory management utility
class MemoryManager {
  static void clearFeatureCache(String featureName) {
    switch (featureName) {
      case 'pomodoro':
        // Clear pomodoro-specific cache
        break;
      case 'notes':
        // Clear notes cache
        break;
      case 'tasks':
        // Clear tasks cache
        break;
    }
  }

  static void onMemoryPressure() {
    // Clear all feature caches
    clearFeatureCache('pomodoro');
    clearFeatureCache('notes');
    clearFeatureCache('tasks');

    // Clear Flutter image cache
    // This will be called from main app lifecycle
  }
}
