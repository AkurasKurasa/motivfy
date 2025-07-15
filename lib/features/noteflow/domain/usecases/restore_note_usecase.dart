import 'package:motiv_fy/features/noteflow/domain/repositories/note_repository_interface.dart';

/// Use case for restoring deleted notes
class RestoreNoteUseCase {
  final NoteRepositoryInterface repository;

  RestoreNoteUseCase(this.repository);

  /// Execute the use case to restore a single note
  Future<void> execute(String noteId) async {
    await repository.restoreNote(noteId);
  }

  /// Execute the use case to restore multiple notes
  Future<void> executeMultiple(List<String> noteIds) async {
    await repository.restoreMultipleNotes(noteIds);
  }
}
