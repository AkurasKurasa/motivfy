import 'package:flutter/material.dart';
import '../services/logger_service.dart';

/// A widget that catches errors in its child widget tree and displays a fallback UI.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundary({super.key, required this.child, this.fallback});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Set a custom error handler for this widget
    FlutterError.onError = (FlutterErrorDetails details) {
      LoggerService().error(
        'Error caught by ErrorBoundary',
        details.exception,
        details.stack,
      );

      setState(() {
        _hasError = true;
        _errorMessage = details.exception.toString();
      });
    };
  }

  @override
  void dispose() {
    // Reset to default error handler
    FlutterError.onError = FlutterError.presentError;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _errorMessage = '';
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
    }

    // If no error, display the child widget
    return widget.child;
  }
}
