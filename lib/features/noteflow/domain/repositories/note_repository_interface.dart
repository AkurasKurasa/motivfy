import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';

/// Repository interface for note operations
abstract class NoteRepositoryInterface {
  /// Get all active (non-deleted) notes
  Future<List<NoteEntity>> getNotes();

  /// Get all deleted notes
  Future<List<NoteEntity>> getDeletedNotes();

  /// Save a new note
  Future<void> saveNote(NoteEntity note);

  /// Update an existing note
  Future<void> updateNote(NoteEntity note);

  /// Soft delete a note (move to trash)
  Future<void> deleteNote(String noteId);

  /// Permanently delete a note
  Future<void> permanentlyDeleteNote(String noteId);

  /// Restore a deleted note
  Future<void> restoreNote(String noteId);

  /// Get a specific note by ID
  Future<NoteEntity?> getNoteById(String noteId);

  /// Delete multiple notes at once
  Future<void> deleteMultipleNotes(List<String> noteIds);

  /// Restore multiple notes at once
  Future<void> restoreMultipleNotes(List<String> noteIds);

  /// Permanently delete multiple notes at once
  Future<void> permanentlyDeleteMultipleNotes(List<String> noteIds);
}
