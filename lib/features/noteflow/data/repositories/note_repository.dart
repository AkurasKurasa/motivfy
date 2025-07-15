import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';
import 'package:motiv_fy/features/noteflow/domain/repositories/note_repository_interface.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_service.dart';

/// Repository implementation that uses NoteService as the data source
class NoteRepository implements NoteRepositoryInterface {
  final NoteService _noteService;

  NoteRepository(this._noteService);

  @override
  Future<List<NoteEntity>> getNotes() async {
    return await _noteService.getNotes();
  }

  @override
  Future<List<NoteEntity>> getDeletedNotes() async {
    return await _noteService.getDeletedNotes();
  }

  @override
  Future<void> saveNote(NoteEntity note) async {
    await _noteService.saveNote(note);
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await _noteService.updateNote(note);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await _noteService.deleteNote(noteId);
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    await _noteService.permanentlyDeleteNote(noteId);
  }

  @override
  Future<void> restoreNote(String noteId) async {
    await _noteService.restoreNote(noteId);
  }

  @override
  Future<NoteEntity?> getNoteById(String noteId) async {
    return await _noteService.getNoteById(noteId);
  }

  @override
  Future<void> deleteMultipleNotes(List<String> noteIds) async {
    await _noteService.deleteMultipleNotes(noteIds);
  }

  @override
  Future<void> restoreMultipleNotes(List<String> noteIds) async {
    await _noteService.restoreMultipleNotes(noteIds);
  }

  @override
  Future<void> permanentlyDeleteMultipleNotes(List<String> noteIds) async {
    await _noteService.permanentlyDeleteMultipleNotes(noteIds);
  }
}
