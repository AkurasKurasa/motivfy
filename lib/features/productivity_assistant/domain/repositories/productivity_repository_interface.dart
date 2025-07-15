import '../entities/productivity_insights_entity.dart';
import '../entities/productivity_session_entity.dart';

/// Repository interface for productivity assistant operations
abstract class ProductivityRepositoryInterface {
  /// Get current productivity insights and analytics
  Future<ProductivityInsightsEntity> getProductivityInsights();

  /// Get productivity insights for a specific date range
  Future<ProductivityInsightsEntity> getProductivityInsightsForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Start a new productivity session
  Future<String> startProductivitySession({String? taskId, String? category});

  /// End the current productivity session
  Future<void> endProductivitySession(
    String sessionId, {
    double? focusRating,
    String? notes,
  });

  /// Record a distraction during a session
  Future<void> recordDistraction(String sessionId, String distractionSource);

  /// Get all productivity sessions
  Future<List<ProductivitySessionEntity>> getProductivitySessions();

  /// Get productivity sessions for a specific date range
  Future<List<ProductivitySessionEntity>> getProductivitySessionsForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get productivity recommendations
  Future<List<ProductivityRecommendation>> getRecommendations();

  /// Mark a recommendation as completed or dismissed
  Future<void> updateRecommendationStatus(
    String recommendationId,
    bool completed,
  );

  /// Track app usage time
  Future<void> trackAppUsage(String packageName, double hoursSpent);

  /// Get app usage statistics
  Future<Map<String, double>> getAppUsageStats();

  /// Calculate and update productivity score
  Future<double> calculateProductivityScore();

  /// Update focus streak
  Future<void> updateFocusStreak();

  /// Export productivity data
  Future<Map<String, dynamic>> exportProductivityData();

  /// Import productivity data
  Future<void> importProductivityData(Map<String, dynamic> data);

  /// Watch for real-time productivity updates
  Stream<ProductivityInsightsEntity> watchProductivityInsights();

  /// Get weekly productivity summary
  Future<Map<String, dynamic>> getWeeklyProductivitySummary();

  /// Get monthly productivity summary
  Future<Map<String, dynamic>> getMonthlyProductivitySummary();
}
