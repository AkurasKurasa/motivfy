import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';
import 'package:motiv_fy/features/noteflow/domain/repositories/note_repository_interface.dart';

/// Use case for creating a new note
class CreateNoteUseCase {
  final NoteRepositoryInterface repository;

  CreateNoteUseCase(this.repository);

  /// Execute the use case to create a note
  Future<void> execute(String content, {int textAlignment = 0}) async {
    final note = NoteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      createdAt: DateTime.now(),
      textAlignment: textAlignment,
    );

    await repository.saveNote(note);
  }
}
