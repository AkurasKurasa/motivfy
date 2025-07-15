import 'dart:async';
import '../../domain/entities/productivity_insights_entity.dart';
import '../../domain/entities/productivity_session_entity.dart';
import '../../domain/repositories/productivity_repository_interface.dart';
import '../models/productivity_insights_model.dart';
import '../models/productivity_session_model.dart';
import '../../../../core/services/user/user_data_manager.dart';
import '../../../../core/services/user/user_data.dart';

/// Implementation of the productivity repository
class ProductivityRepository implements ProductivityRepositoryInterface {
  final UserDataManager _userDataManager;
  final StreamController<ProductivityInsightsEntity> _insightsController =
      StreamController<ProductivityInsightsEntity>.broadcast();

  ProductivityRepository(this._userDataManager);

  @override
  Future<ProductivityInsightsEntity> getProductivityInsights() async {
    final userData = await _userDataManager.getUserData();
    final productivityData = userData.productivityData;

    // Calculate today's stats
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    final todayStats = productivityData.dailyStats
        .where((stat) => stat.date == todayStr)
        .firstOrNull;

    // Get recent sessions for average calculation
    final recentSessions = productivityData.sessions
        .where(
          (session) => session.startTime.isAfter(
            today.subtract(const Duration(days: 7)),
          ),
        )
        .toList();

    final averageSessionDuration = recentSessions.isNotEmpty
        ? recentSessions.map((s) => s.durationMinutes).reduce((a, b) => a + b) /
              recentSessions.length
        : 0.0;

    // Generate recommendations
    final recommendations = await _generateRecommendations(productivityData);

    // Get weekly trends
    final weeklyTrends = _getWeeklyTrends(productivityData);

    return ProductivityInsightsModel(
      productivityScore: productivityData.productivityScore,
      focusStreakDays: productivityData.focusStreakDays,
      tasksCompletedToday: productivityData.tasksCompletedToday,
      totalFocusHoursToday: todayStats?.totalFocusTimeHours ?? 0.0,
      sessionsCompletedToday: todayStats?.sessionsCompleted ?? 0,
      recommendations: recommendations,
      appUsageBreakdown: productivityData.appUsageTimeInHours,
      weeklyTrends: weeklyTrends,
      averageSessionDuration: averageSessionDuration,
      totalDistractionsToday: _getTodayDistractions(productivityData),
    );
  }

  @override
  Future<ProductivityInsightsEntity> getProductivityInsightsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final userData = await _userDataManager.getUserData();
    final productivityData = userData.productivityData;

    // Filter sessions for date range
    final rangeSessions = productivityData.sessions
        .where(
          (session) =>
              session.startTime.isAfter(startDate) &&
              session.startTime.isBefore(endDate),
        )
        .toList();

    // Calculate metrics for the range
    final totalFocusHours = rangeSessions
        .map((s) => s.durationMinutes / 60.0)
        .fold(0.0, (a, b) => a + b);

    final averageSessionDuration = rangeSessions.isNotEmpty
        ? rangeSessions.map((s) => s.durationMinutes).reduce((a, b) => a + b) /
              rangeSessions.length
        : 0.0;

    final totalDistractions = rangeSessions
        .map((s) => s.distractionCount)
        .fold(0, (a, b) => a + b);

    return ProductivityInsightsModel(
      productivityScore: productivityData.productivityScore,
      focusStreakDays: productivityData.focusStreakDays,
      tasksCompletedToday: 0, // Not applicable for date range
      totalFocusHoursToday: totalFocusHours,
      sessionsCompletedToday: rangeSessions.length,
      recommendations: [],
      appUsageBreakdown: productivityData.appUsageTimeInHours,
      weeklyTrends: [],
      averageSessionDuration: averageSessionDuration,
      totalDistractionsToday: totalDistractions,
    );
  }

  @override
  Future<String> startProductivitySession({
    String? taskId,
    String? category,
  }) async {
    final session = ProductivitySessionModel.newSession(
      taskId: taskId,
      category: category,
    );

    final userData = await _userDataManager.getUserData();
    userData.productivityData.sessions.add(
      ProductivitySession(
        startTime: session.startTime,
        endTime: session.endTime,
        durationMinutes: session.durationMinutes,
        taskId: session.taskId,
        category: session.category,
        wasDistracted: session.wasDistracted,
        distractionCount: session.distractionCount,
      ),
    );

    await _userDataManager.saveUserData();
    return session.id;
  }

  @override
  Future<void> endProductivitySession(
    String sessionId, {
    double? focusRating,
    String? notes,
  }) async {
    final userData = await _userDataManager.getUserData();
    final sessions = userData.productivityData.sessions;

    // Find the session (in a real implementation, you'd track active sessions)
    if (sessions.isNotEmpty) {
      final lastSession = sessions.last;
      final now = DateTime.now();
      final duration = now.difference(lastSession.startTime).inMinutes;

      // Update the session
      sessions.removeLast();
      sessions.add(
        ProductivitySession(
          startTime: lastSession.startTime,
          endTime: now,
          durationMinutes: duration,
          taskId: lastSession.taskId,
          category: lastSession.category,
          wasDistracted: lastSession.wasDistracted,
          distractionCount: lastSession.distractionCount,
        ),
      );

      await _userDataManager.saveUserData();

      // Update insights
      await _updateProductivityScore();
    }
  }

  @override
  Future<void> recordDistraction(
    String sessionId,
    String distractionSource,
  ) async {
    final userData = await _userDataManager.getUserData();
    final sessions = userData.productivityData.sessions;

    if (sessions.isNotEmpty) {
      final lastSession = sessions.last;
      sessions.removeLast();
      sessions.add(
        ProductivitySession(
          startTime: lastSession.startTime,
          endTime: lastSession.endTime,
          durationMinutes: lastSession.durationMinutes,
          taskId: lastSession.taskId,
          category: lastSession.category,
          wasDistracted: true,
          distractionCount: lastSession.distractionCount + 1,
        ),
      );

      await _userDataManager.saveUserData();
    }
  }

  @override
  Future<List<ProductivitySessionEntity>> getProductivitySessions() async {
    final userData = await _userDataManager.getUserData();
    return userData.productivityData.sessions
        .map(
          (session) => ProductivitySessionModel(
            id: session.startTime.millisecondsSinceEpoch.toString(),
            startTime: session.startTime,
            endTime: session.endTime,
            durationMinutes: session.durationMinutes,
            taskId: session.taskId,
            category: session.category,
            wasDistracted: session.wasDistracted,
            distractionCount: session.distractionCount,
          ),
        )
        .toList();
  }

  @override
  Future<List<ProductivitySessionEntity>> getProductivitySessionsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sessions = await getProductivitySessions();
    return sessions
        .where(
          (session) =>
              session.startTime.isAfter(startDate) &&
              session.startTime.isBefore(endDate),
        )
        .toList();
  }

  @override
  Future<List<ProductivityRecommendation>> getRecommendations() async {
    final userData = await _userDataManager.getUserData();
    return _generateRecommendations(userData.productivityData);
  }

  @override
  Future<void> updateRecommendationStatus(
    String recommendationId,
    bool completed,
  ) async {
    // In a real implementation, you'd track recommendation status
  }

  @override
  Future<void> trackAppUsage(String packageName, double hoursSpent) async {
    final userData = await _userDataManager.getUserData();
    userData.productivityData.trackAppUsage(packageName, hoursSpent);
    await _userDataManager.saveUserData();
  }

  @override
  Future<Map<String, double>> getAppUsageStats() async {
    final userData = await _userDataManager.getUserData();
    return userData.productivityData.appUsageTimeInHours;
  }

  @override
  Future<double> calculateProductivityScore() async {
    return _updateProductivityScore();
  }

  @override
  Future<void> updateFocusStreak() async {
    // Logic to update focus streak based on daily activity
    await _userDataManager.saveUserData();
  }

  @override
  Future<Map<String, dynamic>> exportProductivityData() async {
    final userData = await _userDataManager.getUserData();
    return userData.productivityData.toJson();
  }

  @override
  Future<void> importProductivityData(Map<String, dynamic> data) async {
    final userData = await _userDataManager.getUserData();
    userData.productivityData = ProductivityData.fromJson(data);
    await _userDataManager.saveUserData();
  }

  @override
  Stream<ProductivityInsightsEntity> watchProductivityInsights() {
    return _insightsController.stream;
  }

  @override
  Future<Map<String, dynamic>> getWeeklyProductivitySummary() async {
    final insights = await getProductivityInsights();
    return {
      'totalFocusHours': insights.weeklyTrends
          .map((t) => t.focusHours)
          .fold(0.0, (a, b) => a + b),
      'averageScore': insights.weeklyTrends.isNotEmpty
          ? insights.weeklyTrends.map((t) => t.score).reduce((a, b) => a + b) /
                insights.weeklyTrends.length
          : 0.0,
      'totalSessions': insights.weeklyTrends
          .map((t) => t.sessionsCompleted)
          .fold(0, (a, b) => a + b),
    };
  }

  @override
  Future<Map<String, dynamic>> getMonthlyProductivitySummary() async {
    // Similar to weekly but for month range
    final insights = await getProductivityInsights();
    return {
      'monthlyScore': insights.productivityScore,
      'focusStreak': insights.focusStreakDays,
      'totalFocusHours': insights.totalFocusHoursToday * 30, // Approximation
    };
  }

  // Helper methods
  Future<List<ProductivityRecommendation>> _generateRecommendations(
    ProductivityData data,
  ) async {
    final recommendations = <ProductivityRecommendation>[];

    // Sample recommendations based on data
    if (data.sessions.isEmpty) {
      recommendations.add(
        const ProductivityRecommendation(
          id: 'start_session',
          title: 'Start Your First Focus Session',
          description: 'Begin tracking your productivity with a focus session.',
          type: ProductivityRecommendationType.startPomodoro,
          priority: 5,
          actionText: 'Start Session',
          actionRoute: '/pomodoro',
        ),
      );
    }

    if (data.focusStreakDays == 0) {
      recommendations.add(
        const ProductivityRecommendation(
          id: 'build_streak',
          title: 'Build Your Focus Streak',
          description: 'Complete one focus session to start your streak.',
          type: ProductivityRecommendationType.setGoals,
          priority: 4,
        ),
      );
    }

    return recommendations;
  }

  List<ProductivityTrend> _getWeeklyTrends(ProductivityData data) {
    final trends = <ProductivityTrend>[];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month}-${date.day}';

      final dayStats = data.dailyStats
          .where((stat) => stat.date == dateStr)
          .firstOrNull;

      trends.add(
        ProductivityTrend(
          date: date,
          score: dayStats?.productivityScore ?? 0.0,
          focusHours: dayStats?.totalFocusTimeHours ?? 0.0,
          tasksCompleted: dayStats?.tasksCompleted ?? 0,
          sessionsCompleted: dayStats?.sessionsCompleted ?? 0,
        ),
      );
    }

    return trends;
  }

  int _getTodayDistractions(ProductivityData data) {
    final today = DateTime.now();
    return data.sessions
        .where(
          (session) =>
              session.startTime.day == today.day &&
              session.startTime.month == today.month &&
              session.startTime.year == today.year,
        )
        .map((s) => s.distractionCount)
        .fold(0, (a, b) => a + b);
  }

  Future<double> _updateProductivityScore() async {
    final userData = await _userDataManager.getUserData();

    // Simple scoring algorithm
    final sessions = userData.productivityData.sessions;
    if (sessions.isEmpty) return 0.0;

    final totalSessions = sessions.length;
    final productiveSessions = sessions
        .where((s) => s.durationMinutes >= 25 && s.distractionCount <= 2)
        .length;

    final score = (productiveSessions / totalSessions) * 100;
    userData.productivityData.productivityScore = score;

    await _userDataManager.saveUserData();
    return score;
  }

  /// Clean up resources
  void dispose() {
    _insightsController.close();
  }
}
