import '../entities/productivity_insights_entity.dart';
import '../repositories/productivity_repository_interface.dart';

class GetProductivityInsightsUseCase {
  final ProductivityRepositoryInterface repository;

  GetProductivityInsightsUseCase(this.repository);

  Future<ProductivityInsightsEntity> execute() {
    return repository.getProductivityInsights();
  }

  Future<ProductivityInsightsEntity> executeForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return repository.getProductivityInsightsForDateRange(startDate, endDate);
  }
}
