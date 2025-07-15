/// Productivity insights entity representing analytics and recommendations
class ProductivityInsightsEntity {
  final double productivityScore; // 0-100
  final int focusStreakDays;
  final int tasksCompletedToday;
  final double totalFocusHoursToday;
  final int sessionsCompletedToday;
  final List<ProductivityRecommendation> recommendations;
  final Map<String, double> appUsageBreakdown;
  final List<ProductivityTrend> weeklyTrends;
  final double averageSessionDuration;
  final int totalDistractionsToday;

  const ProductivityInsightsEntity({
    required this.productivityScore,
    required this.focusStreakDays,
    required this.tasksCompletedToday,
    required this.totalFocusHoursToday,
    required this.sessionsCompletedToday,
    required this.recommendations,
    required this.appUsageBreakdown,
    required this.weeklyTrends,
    required this.averageSessionDuration,
    required this.totalDistractionsToday,
  });

  /// Create a copy with updated values
  ProductivityInsightsEntity copyWith({
    double? productivityScore,
    int? focusStreakDays,
    int? tasksCompletedToday,
    double? totalFocusHoursToday,
    int? sessionsCompletedToday,
    List<ProductivityRecommendation>? recommendations,
    Map<String, double>? appUsageBreakdown,
    List<ProductivityTrend>? weeklyTrends,
    double? averageSessionDuration,
    int? totalDistractionsToday,
  }) {
    return ProductivityInsightsEntity(
      productivityScore: productivityScore ?? this.productivityScore,
      focusStreakDays: focusStreakDays ?? this.focusStreakDays,
      tasksCompletedToday: tasksCompletedToday ?? this.tasksCompletedToday,
      totalFocusHoursToday: totalFocusHoursToday ?? this.totalFocusHoursToday,
      sessionsCompletedToday:
          sessionsCompletedToday ?? this.sessionsCompletedToday,
      recommendations: recommendations ?? this.recommendations,
      appUsageBreakdown: appUsageBreakdown ?? this.appUsageBreakdown,
      weeklyTrends: weeklyTrends ?? this.weeklyTrends,
      averageSessionDuration:
          averageSessionDuration ?? this.averageSessionDuration,
      totalDistractionsToday:
          totalDistractionsToday ?? this.totalDistractionsToday,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductivityInsightsEntity &&
        other.productivityScore == productivityScore &&
        other.focusStreakDays == focusStreakDays &&
        other.tasksCompletedToday == tasksCompletedToday &&
        other.totalFocusHoursToday == totalFocusHoursToday &&
        other.sessionsCompletedToday == sessionsCompletedToday &&
        other.averageSessionDuration == averageSessionDuration &&
        other.totalDistractionsToday == totalDistractionsToday;
  }

  @override
  int get hashCode {
    return productivityScore.hashCode ^
        focusStreakDays.hashCode ^
        tasksCompletedToday.hashCode ^
        totalFocusHoursToday.hashCode ^
        sessionsCompletedToday.hashCode ^
        averageSessionDuration.hashCode ^
        totalDistractionsToday.hashCode;
  }
}

/// Productivity recommendation entity
class ProductivityRecommendation {
  final String id;
  final String title;
  final String description;
  final ProductivityRecommendationType type;
  final int priority; // 1-5, 5 being highest
  final String? actionText;
  final String? actionRoute;

  const ProductivityRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    this.actionText,
    this.actionRoute,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductivityRecommendation &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.priority == priority &&
        other.actionText == actionText &&
        other.actionRoute == actionRoute;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        type.hashCode ^
        priority.hashCode ^
        actionText.hashCode ^
        actionRoute.hashCode;
  }
}

/// Types of productivity recommendations
enum ProductivityRecommendationType {
  takeBreak,
  startPomodoro,
  reviewTasks,
  reduceDistractions,
  improveHabits,
  setGoals,
  analyzePatterns,
}

/// Productivity trend entity
class ProductivityTrend {
  final DateTime date;
  final double score;
  final double focusHours;
  final int tasksCompleted;
  final int sessionsCompleted;

  const ProductivityTrend({
    required this.date,
    required this.score,
    required this.focusHours,
    required this.tasksCompleted,
    required this.sessionsCompleted,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductivityTrend &&
        other.date == date &&
        other.score == score &&
        other.focusHours == focusHours &&
        other.tasksCompleted == tasksCompleted &&
        other.sessionsCompleted == sessionsCompleted;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        score.hashCode ^
        focusHours.hashCode ^
        tasksCompleted.hashCode ^
        sessionsCompleted.hashCode;
  }
}
