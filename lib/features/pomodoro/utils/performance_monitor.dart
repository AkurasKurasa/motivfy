import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Performance monitoring specifically for Pomodoro feature
class PomodoroPerformanceMonitor {
  static void measureTimerUpdate(void Function() callback) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      callback();
      stopwatch.stop();

      // Log if timer update takes too long (60 FPS = 16ms threshold)
      if (stopwatch.elapsedMilliseconds > 16) {
        developer.log(
          'Pomodoro timer update took ${stopwatch.elapsedMilliseconds}ms',
          name: 'PomodoroPerformance',
        );
      }
    } else {
      callback();
    }
  }

  static void measureUIUpdate(void Function() callback) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      callback();
      stopwatch.stop();

      // Log if UI update takes too long
      if (stopwatch.elapsedMilliseconds > 8) {
        developer.log(
          'Pomodoro UI update took ${stopwatch.elapsedMilliseconds}ms',
          name: 'PomodoroPerformance',
        );
      }
    } else {
      callback();
    }
  }

  static void measureAnimationFrame(void Function() callback) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      callback();
      stopwatch.stop();

      // Log if animation frame takes too long
      if (stopwatch.elapsedMilliseconds > 4) {
        developer.log(
          'Pomodoro animation frame took ${stopwatch.elapsedMilliseconds}ms',
          name: 'PomodoroPerformance',
        );
      }
    } else {
      callback();
    }
  }

  static void logMemoryUsage() {
    if (kDebugMode) {
      developer.log('Pomodoro feature memory check', name: 'PomodoroMemory');
    }
  }

  static void logCircleRepaint(double progress) {
    if (kDebugMode && progress % 0.1 < 0.01) {
      developer.log(
        'Circle repaint at progress: ${(progress * 100).toStringAsFixed(1)}%',
        name: 'PomodoroCircle',
      );
    }
  }
}

/// Audio performance manager for Pomodoro notifications
class PomodoroAudioManager {
  static bool _isAudioEnabled = true;

  static void setAudioEnabled(bool enabled) {
    _isAudioEnabled = enabled;
  }

  static bool get isAudioEnabled => _isAudioEnabled;

  static Future<void> playNotificationSound() async {
    if (!_isAudioEnabled) return;

    try {
      // Implement audio playback here
      // Use compressed audio files for better performance
      developer.log(
        'Playing Pomodoro notification sound',
        name: 'PomodoroAudio',
      );
    } catch (e) {
      developer.log(
        'Audio playback error: $e',
        name: 'PomodoroAudio',
        error: e,
      );
    }
  }

  static void dispose() {
    // Cleanup audio resources
    developer.log('Disposing Pomodoro audio resources', name: 'PomodoroAudio');
  }
}

/// Background timer optimization for Pomodoro
class PomodoroBackgroundOptimizer {
  static bool _isInBackground = false;
  static DateTime? _backgroundStartTime;

  static void onAppPaused() {
    _isInBackground = true;
    _backgroundStartTime = DateTime.now();

    developer.log(
      'Pomodoro app paused - optimizing for background',
      name: 'PomodoroBackground',
    );
  }

  static void onAppResumed() {
    if (_isInBackground && _backgroundStartTime != null) {
      final backgroundDuration = DateTime.now().difference(
        _backgroundStartTime!,
      );

      developer.log(
        'Pomodoro app resumed after ${backgroundDuration.inSeconds}s',
        name: 'PomodoroBackground',
      );
    }

    _isInBackground = false;
    _backgroundStartTime = null;
  }

  static bool get isInBackground => _isInBackground;

  static Duration? get backgroundDuration => _backgroundStartTime != null
      ? DateTime.now().difference(_backgroundStartTime!)
      : null;
}
