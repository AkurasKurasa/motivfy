import 'package:flutter/foundation.dart';

/// A simple logging service for the application
///
/// This service provides methods to log messages with different severity levels:
/// - [info]: for informational messages
/// - [error]: for error messages, with optional exception and stack trace
/// - [warning]: for warning messages
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  /// Log an informational message
  void info(String message) {
    if (kDebugMode) {
      debugPrint('INFO: $message');
    }
  }

  /// Log an error message and optional exception
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('ERROR: $message');
      if (error != null) {
        debugPrint('Exception: $error');
        if (stackTrace != null) {
          debugPrint('StackTrace: $stackTrace');
        }
      }
    }
  }

  /// Log a warning message
  void warning(String message) {
    if (kDebugMode) {
      debugPrint('WARNING: $message');
    }
  }
}
