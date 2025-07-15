import 'package:motiv_fy/features/noteflow/domain/repositories/note_repository_interface.dart';

/// Use case for deleting a note (soft delete)
class DeleteNoteUseCase {
  final NoteRepositoryInterface repository;

  DeleteNoteUseCase(this.repository);

  /// Execute the use case to delete a single note
  Future<void> execute(String noteId) async {
    await repository.deleteNote(noteId);
  }

  /// Execute the use case to delete multiple notes
  Future<void> executeMultiple(List<String> noteIds) async {
    await repository.deleteMultipleNotes(noteIds);
  }

  /// Execute the use case to permanently delete a note
  Future<void> executePermanent(String noteId) async {
    await repository.permanentlyDeleteNote(noteId);
  }

  /// Execute the use case to permanently delete multiple notes
  Future<void> executePermanentMultiple(List<String> noteIds) async {
    await repository.permanentlyDeleteMultipleNotes(noteIds);
  }
}
