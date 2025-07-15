import 'package:flutter_test/flutter_test.dart';
import 'package:motiv_fy/core/utils/device_utils.dart';
import 'package:motiv_fy/features/pomodoro/domain/services/pomodoro_service.dart';
import 'package:motiv_fy/features/pomodoro/utils/performance_monitor.dart';
import 'dart:math' as math;

void main() {
  group('Pomodoro Performance Tests', () {
    setUp(() {
      // Reset device detection for each test
      DeviceUtils.overrideIsLowEndDevice(null);
    });

    tearDown(() {
      // Clean up after each test
      DeviceUtils.overrideIsLowEndDevice(null);
    });

    test('DeviceUtils should provide optimized values for low-end devices', () {
      // Test with low-end device simulation
      DeviceUtils.overrideIsLowEndDevice(true);

      expect(DeviceUtils.isLowEndDevice, isTrue);
      expect(DeviceUtils.getOptimalCacheSize(), lessThan(100));
      expect(
        DeviceUtils.getTimerUpdateInterval().inMilliseconds,
        greaterThan(50),
      );

      // Test with high-end device simulation
      DeviceUtils.overrideIsLowEndDevice(false);

      expect(DeviceUtils.isLowEndDevice, isFalse);
      expect(DeviceUtils.getOptimalCacheSize(), equals(100));
      expect(
        DeviceUtils.getTimerUpdateInterval().inMilliseconds,
        lessThanOrEqualTo(16),
      );
    });

    test('DeviceUtils should handle test environment gracefully', () {
      // Test default behavior in test environment
      expect(DeviceUtils.getOptimalCacheSize(), isA<int>());
      expect(DeviceUtils.getTimerUpdateInterval(), isA<Duration>());
      expect(DeviceUtils.getAnimationUpdateInterval(), isA<Duration>());
    });

    test('PomodoroService timer updates should be efficient', () async {
      final service = PomodoroService();
      await service.initialize();

      // Measure timer start performance
      final stopwatch = Stopwatch()..start();
      service.startTimer();
      stopwatch.stop();

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(10),
        reason: 'Timer start should be fast',
      );

      service.pauseTimer();
    });

    test('Performance monitor should track timing accurately', () {
      var callbackExecuted = false;

      PomodoroPerformanceMonitor.measureTimerUpdate(() {
        callbackExecuted = true;
        // Simulate some work
        for (int i = 0; i < 1000; i++) {
          math.sqrt(i);
        }
      });

      expect(callbackExecuted, isTrue);
    });

    test('Memory management should handle cleanup properly', () {
      // Test that memory manager doesn't throw errors
      expect(
        () => MemoryManager.clearFeatureCache('pomodoro'),
        returnsNormally,
      );
      expect(() => MemoryManager.onMemoryPressure(), returnsNormally);
    });

    test('Animation durations should be optimized for device capability', () {
      const originalDuration = Duration(milliseconds: 1000);
      final optimizedDuration = DeviceUtils.getAnimationDuration(
        originalDuration,
      );

      if (DeviceUtils.shouldReduceAnimations) {
        expect(
          optimizedDuration.inMilliseconds,
          lessThan(originalDuration.inMilliseconds),
        );
      } else {
        expect(optimizedDuration, equals(originalDuration));
      }
    });

    test('Audio manager should handle enable/disable correctly', () {
      PomodoroAudioManager.setAudioEnabled(false);
      expect(PomodoroAudioManager.isAudioEnabled, isFalse);

      PomodoroAudioManager.setAudioEnabled(true);
      expect(PomodoroAudioManager.isAudioEnabled, isTrue);
    });

    test('Background optimizer should track app state', () {
      expect(PomodoroBackgroundOptimizer.isInBackground, isFalse);

      PomodoroBackgroundOptimizer.onAppPaused();
      expect(PomodoroBackgroundOptimizer.isInBackground, isTrue);

      PomodoroBackgroundOptimizer.onAppResumed();
      expect(PomodoroBackgroundOptimizer.isInBackground, isFalse);
    });
  });

  group('Performance Benchmarks', () {
    test('Timer circle repaint performance', () {
      // Simulate multiple progress updates
      final stopwatch = Stopwatch()..start();

      for (double progress = 0.0; progress <= 1.0; progress += 0.01) {
        PomodoroPerformanceMonitor.measureAnimationFrame(() {
          // Simulate circle repaint logic
          final shouldRepaint = progress % 0.01 < 0.001;
          if (shouldRepaint) {
            // Simulate repaint work
          }
        });
      }

      stopwatch.stop();

      // Should complete 100 updates in reasonable time
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(100),
        reason: 'Circle updates should be fast',
      );
    });

    test('Timer service performance under load', () async {
      final service = PomodoroService();
      await service.initialize();

      final stopwatch = Stopwatch()..start();

      // Simulate rapid timer updates
      for (int i = 0; i < 100; i++) {
        PomodoroPerformanceMonitor.measureTimerUpdate(() {
          // Simulate timer tick
          service.currentTime;
          service.progress;
        });
      }

      stopwatch.stop();

      // Should handle 100 updates quickly
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(50),
        reason: 'Timer service should handle rapid updates efficiently',
      );
    });
  });
}
