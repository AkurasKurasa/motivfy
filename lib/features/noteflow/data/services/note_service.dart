import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:motiv_fy/features/noteflow/data/models/note.dart';
import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';
import 'package:motiv_fy/features/noteflow/domain/repositories/note_repository_interface.dart';

/// Service to manage notes persistence in the application
class NoteService extends ChangeNotifier implements NoteRepositoryInterface {
  List<Note> _notes = [];
  static final NoteService _instance = NoteService._internal();

  /// Factory constructor to return the same instance every time
  factory NoteService() {
    return _instance;
  }

  /// Private constructor for singleton
  NoteService._internal() {
    _loadNotes();
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    return _notes
        .where((note) => note.deletedAt == null)
        .map((note) => note.toEntity())
        .toList();
  }

  @override
  Future<List<NoteEntity>> getDeletedNotes() async {
    // Filter notes that have been deleted and are not older than 30 days
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return _notes
        .where(
          (note) =>
              note.deletedAt != null && note.deletedAt!.isAfter(thirtyDaysAgo),
        )
        .map((note) => note.toEntity())
        .toList();
  }

  @override
  Future<void> saveNote(NoteEntity noteEntity) async {
    final note = Note.fromEntity(noteEntity);
    _notes.add(note);
    await _saveNotes();
    notifyListeners();
  }

  @override
  Future<void> updateNote(NoteEntity noteEntity) async {
    final index = _notes.indexWhere((note) => note.id == noteEntity.id);
    if (index != -1) {
      _notes[index] = Note.fromEntity(noteEntity);
      await _saveNotes();
      notifyListeners();
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final index = _notes.indexWhere((note) => note.id == noteId);
    if (index != -1) {
      final note = _notes[index];
      final deletedNote = note.copyWith(deletedAt: DateTime.now());
      _notes[index] = deletedNote;
      await _saveNotes();
      notifyListeners();
    }
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    _notes.removeWhere((note) => note.id == noteId);
    await _saveNotes();
    notifyListeners();
  }

  @override
  Future<void> restoreNote(String noteId) async {
    final index = _notes.indexWhere((note) => note.id == noteId);
    if (index != -1) {
      final note = _notes[index];
      final restoredNote = note.copyWith(deletedAt: null);
      _notes[index] = restoredNote;
      await _saveNotes();
      notifyListeners();
    }
  }

  @override
  Future<NoteEntity?> getNoteById(String noteId) async {
    try {
      final note = _notes.firstWhere((note) => note.id == noteId);
      return note.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteMultipleNotes(List<String> noteIds) async {
    for (final noteId in noteIds) {
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        final note = _notes[index];
        final deletedNote = note.copyWith(deletedAt: DateTime.now());
        _notes[index] = deletedNote;
      }
    }
    await _saveNotes();
    notifyListeners();
  }

  @override
  Future<void> restoreMultipleNotes(List<String> noteIds) async {
    for (final noteId in noteIds) {
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        final note = _notes[index];
        final restoredNote = note.copyWith(deletedAt: null);
        _notes[index] = restoredNote;
      }
    }
    await _saveNotes();
    notifyListeners();
  }

  @override
  Future<void> permanentlyDeleteMultipleNotes(List<String> noteIds) async {
    _notes.removeWhere((note) => noteIds.contains(note.id));
    await _saveNotes();
    notifyListeners();
  }

  /// Legacy method for backwards compatibility
  Future<void> addNote(String content, {int textAlignment = 0}) async {
    if (content.trim().isEmpty) return;

    final noteEntity = NoteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      createdAt: DateTime.now(),
      textAlignment: textAlignment,
    );

    await saveNote(noteEntity);
  }

  /// Get active notes for backwards compatibility
  List<Note> get notes =>
      _notes.where((note) => note.deletedAt == null).toList();

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList('notes') ?? [];

      _notes = notesJson
          .map((noteStr) => Note.fromJson(json.decode(noteStr)))
          .toList();

      // Clean up old deleted notes
      _cleanupOldDeletedNotes();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = _notes
          .map((note) => json.encode(note.toJson()))
          .toList();

      await prefs.setStringList('notes', notesJson);
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  /// Clean up notes deleted more than 30 days ago
  void _cleanupOldDeletedNotes() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    _notes.removeWhere(
      (note) =>
          note.deletedAt != null && note.deletedAt!.isBefore(thirtyDaysAgo),
    );
  }
}
