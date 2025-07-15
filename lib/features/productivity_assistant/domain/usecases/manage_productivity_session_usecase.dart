import '../entities/productivity_session_entity.dart';
import '../repositories/productivity_repository_interface.dart';

class ManageProductivitySessionUseCase {
  final ProductivityRepositoryInterface repository;

  ManageProductivitySessionUseCase(this.repository);

  Future<String> startSession({String? taskId, String? category}) {
    return repository.startProductivitySession(
      taskId: taskId,
      category: category,
    );
  }

  Future<void> endSession(
    String sessionId, {
    double? focusRating,
    String? notes,
  }) {
    return repository.endProductivitySession(
      sessionId,
      focusRating: focusRating,
      notes: notes,
    );
  }

  Future<void> recordDistraction(String sessionId, String distractionSource) {
    return repository.recordDistraction(sessionId, distractionSource);
  }

  Future<List<ProductivitySessionEntity>> getSessions() {
    return repository.getProductivitySessions();
  }

  Future<List<ProductivitySessionEntity>> getSessionsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return repository.getProductivitySessionsForDateRange(startDate, endDate);
  }
}
