import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:motiv_fy/core/services/user/user_data.dart' as user_data;
import 'package:motiv_fy/core/services/user/user_data_manager.dart';
import 'package:motiv_fy/core/utils/device_utils.dart';
import '../../utils/performance_monitor.dart';

/// State management for Pomodoro Timer functionality
/// Using ChangeNotifier for state management following the app's existing pattern
class PomodoroService extends ChangeNotifier {
  static final PomodoroService _instance = PomodoroService._internal();
  factory PomodoroService() => _instance;
  PomodoroService._internal();

  // Disposal guard
  bool _disposed = false;

  // Timer state
  Timer? _timer;
  Duration _currentTime = const Duration(minutes: 25);
  Duration _totalTime = const Duration(minutes: 25);
  bool _isRunning = false;
  bool _isWorkTime = true;
  int _sessionsCompleted = 0;
  int _currentCycle = 0; // Track cycles for long breaks

  // Settings (loaded from user data)
  Duration _workDuration = const Duration(minutes: 25);
  Duration _shortBreakDuration = const Duration(minutes: 5);
  Duration _longBreakDuration = const Duration(minutes: 15);
  int _sessionsBeforeLongBreak = 4;

  // Presets for quick switching
  final List<PomodoroPreset> _presets = [
    PomodoroPreset(
      name: 'Classic',
      icon: '🍅',
      workDuration: const Duration(minutes: 25),
      breakDuration: const Duration(minutes: 5),
    ),
    PomodoroPreset(
      name: 'Short Focus',
      icon: '⚡',
      workDuration: const Duration(minutes: 15),
      breakDuration: const Duration(minutes: 3),
    ),
    PomodoroPreset(
      name: 'Deep Work',
      icon: '🎯',
      workDuration: const Duration(minutes: 45),
      breakDuration: const Duration(minutes: 10),
    ),
    PomodoroPreset(
      name: 'Study Session',
      icon: '📚',
      workDuration: const Duration(minutes: 50),
      breakDuration: const Duration(minutes: 10),
    ),
  ];

  int _selectedPresetIndex = 0;
  bool _adaptiveModeEnabled = false;

  // Getters
  Duration get currentTime => _currentTime;
  Duration get totalTime => _totalTime;
  bool get isRunning => _isRunning;
  bool get isWorkTime => _isWorkTime;
  int get sessionsCompleted => _sessionsCompleted;
  Duration get workDuration => _workDuration;
  Duration get shortBreakDuration => _shortBreakDuration;
  Duration get longBreakDuration => _longBreakDuration;
  List<PomodoroPreset> get presets => _presets;
  int get selectedPresetIndex => _selectedPresetIndex;
  bool get adaptiveModeEnabled => _adaptiveModeEnabled;

  double get progress => 1.0 - (_currentTime.inSeconds / _totalTime.inSeconds);

  String get currentModeTitle => _isWorkTime ? 'Focus Time' : 'Break Time';
  String get currentModeSubtitle => _isWorkTime
      ? 'Stay focused on your task'
      : _isLongBreak
      ? 'Take a longer break'
      : 'Take a short break';

  bool get _isLongBreak =>
      !_isWorkTime && (_currentCycle % _sessionsBeforeLongBreak == 0);

  /// Initialize service with user settings
  Future<void> initialize() async {
    try {
      final userManager = UserDataManager();
      final userData = await userManager.getUserData();
      final pomodoroSettings = userData.pomodoroSettings;

      _workDuration = Duration(minutes: pomodoroSettings.workDurationMinutes);
      _shortBreakDuration = Duration(
        minutes: pomodoroSettings.shortBreakDurationMinutes,
      );
      _longBreakDuration = Duration(
        minutes: pomodoroSettings.longBreakDurationMinutes,
      );
      _sessionsBeforeLongBreak = pomodoroSettings.sessionsBeforeLongBreak;

      // Initialize current time with work duration
      _currentTime = _workDuration;
      _totalTime = _workDuration;

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize Pomodoro settings: $e');
    }
  }

  /// Start the timer
  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    notifyListeners();

    // Timer should always update every second for accurate timekeeping
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) {
        _timer?.cancel();
        return;
      }

      // Measure timer performance for debugging
      PerformanceMonitor.measureSync('timer-update', () {
        if (_currentTime.inSeconds > 0) {
          // Decrement by 1 second
          _currentTime -= const Duration(seconds: 1);
          notifyListeners();
        } else {
          _completeCurrentSession();
        }
      });
    });
  }

  /// Pause the timer
  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  /// Reset the timer
  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _currentTime = _isWorkTime
        ? _workDuration
        : (_isLongBreak ? _longBreakDuration : _shortBreakDuration);
    _totalTime = _currentTime;
    notifyListeners();
  }

  /// Reset everything: timer, sessions count, and cycles
  void resetAll() {
    _timer?.cancel();
    _isRunning = false;
    _isWorkTime = true; // Reset to work mode
    _sessionsCompleted = 0; // Reset session count
    _currentCycle = 0; // Reset cycles
    _currentTime = _workDuration; // Reset to work duration
    _totalTime = _currentTime;
    notifyListeners();
  }

  /// Complete current session and transition
  void _completeCurrentSession() {
    _timer?.cancel();
    _isRunning = false;

    if (_isWorkTime) {
      _sessionsCompleted++;
      _currentCycle++;

      // Save completed session
      _saveCompletedSession();
    }

    // Switch modes
    _isWorkTime = !_isWorkTime;

    // Set next duration
    if (_isWorkTime) {
      _currentTime = _workDuration;
    } else {
      _currentTime = _isLongBreak ? _longBreakDuration : _shortBreakDuration;
    }

    _totalTime = _currentTime;
    notifyListeners();

    // Auto-start if enabled in settings
    // For now, we'll let user manually start
  }

  /// Skip current session
  void skipSession() {
    _timer?.cancel();
    _isRunning = false;

    if (_isWorkTime) {
      _currentCycle++;
      _sessionsCompleted++; // Increment sessions when skipping from work
    }

    _isWorkTime = !_isWorkTime;

    if (_isWorkTime) {
      _currentTime = _workDuration;
    } else {
      _currentTime = _isLongBreak ? _longBreakDuration : _shortBreakDuration;
    }

    _totalTime = _currentTime;
    notifyListeners();
  }

  /// Switch to a different preset
  void selectPreset(int index) {
    if (index < 0 || index >= _presets.length) return;

    final preset = _presets[index];
    _selectedPresetIndex = index;
    _workDuration = preset.workDuration;
    _shortBreakDuration = preset.breakDuration;

    // Reset timer with new durations
    resetTimer();
    notifyListeners();
  }

  /// Toggle adaptive mode
  void toggleAdaptiveMode() {
    _adaptiveModeEnabled = !_adaptiveModeEnabled;
    notifyListeners();
  }

  /// Update work duration
  void updateWorkDuration(Duration duration) {
    _workDuration = duration;
    if (_isWorkTime) {
      _currentTime = duration;
      _totalTime = duration;
    }
    _saveSettings();
    notifyListeners();
  }

  /// Update break duration
  void updateBreakDuration(Duration duration) {
    _shortBreakDuration = duration;
    if (!_isWorkTime && !_isLongBreak) {
      _currentTime = duration;
      _totalTime = duration;
    }
    _saveSettings();
    notifyListeners();
  }

  /// Save settings to user data
  void _saveSettings() {
    try {
      final userManager = UserDataManager();
      userManager.getUserData().then((userData) {
        userData.pomodoroSettings.workDurationMinutes = _workDuration.inMinutes;
        userData.pomodoroSettings.shortBreakDurationMinutes =
            _shortBreakDuration.inMinutes;
        userData.pomodoroSettings.longBreakDurationMinutes =
            _longBreakDuration.inMinutes;
        userManager.saveUserData();
      });
    } catch (e) {
      debugPrint('Failed to save Pomodoro settings: $e');
    }
  }

  /// Save completed session to history
  void _saveCompletedSession() {
    try {
      final userManager = UserDataManager();
      userManager.getUserData().then((userData) {
        // Create session using the existing PomodoroSession from user_data.dart
        final newSession = user_data.PomodoroSession(
          startTime: DateTime.now().subtract(_workDuration),
          endTime: DateTime.now(),
          durationMinutes: _workDuration.inMinutes,
          sessionType: 'work',
        );

        userData.pomodoroSettings.history.add(newSession);
        userData.pomodoroSettings.totalSessionsCompleted++;
        userData.pomodoroSettings.totalWorkTimeInHours +=
            _workDuration.inMinutes / 60.0;

        userManager.saveUserData();
      });
    } catch (e) {
      debugPrint('Failed to save Pomodoro session: $e');
    }
  }

  /// Format duration for display
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _timer?.cancel();
      super.dispose();
    }
  }
}

/// Represents a pomodoro preset configuration
class PomodoroPreset {
  final String name;
  final String icon;
  final Duration workDuration;
  final Duration breakDuration;

  const PomodoroPreset({
    required this.name,
    required this.icon,
    required this.workDuration,
    required this.breakDuration,
  });
}

/// Represents different types of pomodoro sessions
enum PomodoroSessionType { work, shortBreak, longBreak }
