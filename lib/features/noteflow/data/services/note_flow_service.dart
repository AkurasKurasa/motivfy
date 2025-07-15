import 'package:flutter/material.dart';

/// A service to manage state persistence between NoteFlow and Manual pages
class NoteFlowService {
  // Singleton pattern
  static final NoteFlowService _instance = NoteFlowService._internal();
  factory NoteFlowService() => _instance;
  NoteFlowService._internal();

  // Variables to store state
  String noteText = '';
  int textAlignment = 0; // 0: left, 1: center, 2: right, 3: justify

  /// Get TextAlign enum from stored int value
  TextAlign getTextAlignment() {
    switch (textAlignment) {
      case 0:
        return TextAlign.left;
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.right;
      case 3:
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  /// Save all state in one call
  void saveState({required String text, required int alignment}) {
    noteText = text;
    textAlignment = alignment;
    debugPrint(
      'NoteFlowService: Saved state - Text: "$text", Alignment: $alignment',
    );
  }

  /// Clear state (if needed)
  void clearState() {
    noteText = '';
    textAlignment = 0;
    debugPrint('NoteFlowService: Cleared state');
  }
}
