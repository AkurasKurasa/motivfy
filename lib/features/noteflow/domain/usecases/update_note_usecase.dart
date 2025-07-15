import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';
import 'package:motiv_fy/features/noteflow/domain/repositories/note_repository_interface.dart';

/// Use case for updating an existing note
class UpdateNoteUseCase {
  final NoteRepositoryInterface repository;

  UpdateNoteUseCase(this.repository);

  /// Execute the use case to update a note
  Future<void> execute(NoteEntity note) async {
    await repository.updateNote(note);
  }
}
