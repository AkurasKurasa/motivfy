import '../entities/productivity_insights_entity.dart';
import '../repositories/productivity_repository_interface.dart';

class GetProductivityRecommendationsUseCase {
  final ProductivityRepositoryInterface repository;

  GetProductivityRecommendationsUseCase(this.repository);

  Future<List<ProductivityRecommendation>> execute() {
    return repository.getRecommendations();
  }

  Future<void> markRecommendationCompleted(String recommendationId) {
    return repository.updateRecommendationStatus(recommendationId, true);
  }

  Future<void> dismissRecommendation(String recommendationId) {
    return repository.updateRecommendationStatus(recommendationId, false);
  }
}
