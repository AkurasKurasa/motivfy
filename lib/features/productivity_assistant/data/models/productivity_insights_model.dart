import '../../domain/entities/productivity_insights_entity.dart';

/// Data model for productivity insights with JSON serialization capabilities
class ProductivityInsightsModel extends ProductivityInsightsEntity {
  const ProductivityInsightsModel({
    required super.productivityScore,
    required super.focusStreakDays,
    required super.tasksCompletedToday,
    required super.totalFocusHoursToday,
    required super.sessionsCompletedToday,
    required super.recommendations,
    required super.appUsageBreakdown,
    required super.weeklyTrends,
    required super.averageSessionDuration,
    required super.totalDistractionsToday,
  });

  /// Create a ProductivityInsightsModel from an entity
  factory ProductivityInsightsModel.fromEntity(
    ProductivityInsightsEntity entity,
  ) {
    return ProductivityInsightsModel(
      productivityScore: entity.productivityScore,
      focusStreakDays: entity.focusStreakDays,
      tasksCompletedToday: entity.tasksCompletedToday,
      totalFocusHoursToday: entity.totalFocusHoursToday,
      sessionsCompletedToday: entity.sessionsCompletedToday,
      recommendations: entity.recommendations,
      appUsageBreakdown: entity.appUsageBreakdown,
      weeklyTrends: entity.weeklyTrends,
      averageSessionDuration: entity.averageSessionDuration,
      totalDistractionsToday: entity.totalDistractionsToday,
    );
  }

  /// Create from JSON
  factory ProductivityInsightsModel.fromJson(Map<String, dynamic> json) {
    return ProductivityInsightsModel(
      productivityScore: json['productivityScore']?.toDouble() ?? 0.0,
      focusStreakDays: json['focusStreakDays'] ?? 0,
      tasksCompletedToday: json['tasksCompletedToday'] ?? 0,
      totalFocusHoursToday: json['totalFocusHoursToday']?.toDouble() ?? 0.0,
      sessionsCompletedToday: json['sessionsCompletedToday'] ?? 0,
      recommendations:
          (json['recommendations'] as List?)
              ?.map((e) => ProductivityRecommendationModel.fromJson(e))
              .cast<ProductivityRecommendation>()
              .toList() ??
          [],
      appUsageBreakdown:
          (json['appUsageBreakdown'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toDouble()),
          ) ??
          {},
      weeklyTrends:
          (json['weeklyTrends'] as List?)
              ?.map((e) => ProductivityTrendModel.fromJson(e))
              .cast<ProductivityTrend>()
              .toList() ??
          [],
      averageSessionDuration: json['averageSessionDuration']?.toDouble() ?? 0.0,
      totalDistractionsToday: json['totalDistractionsToday'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'productivityScore': productivityScore,
      'focusStreakDays': focusStreakDays,
      'tasksCompletedToday': tasksCompletedToday,
      'totalFocusHoursToday': totalFocusHoursToday,
      'sessionsCompletedToday': sessionsCompletedToday,
      'recommendations': recommendations
          .map((r) => ProductivityRecommendationModel.fromEntity(r).toJson())
          .toList(),
      'appUsageBreakdown': appUsageBreakdown,
      'weeklyTrends': weeklyTrends
          .map((t) => ProductivityTrendModel.fromEntity(t).toJson())
          .toList(),
      'averageSessionDuration': averageSessionDuration,
      'totalDistractionsToday': totalDistractionsToday,
    };
  }

  /// Create empty insights
  factory ProductivityInsightsModel.empty() {
    return const ProductivityInsightsModel(
      productivityScore: 0.0,
      focusStreakDays: 0,
      tasksCompletedToday: 0,
      totalFocusHoursToday: 0.0,
      sessionsCompletedToday: 0,
      recommendations: [],
      appUsageBreakdown: {},
      weeklyTrends: [],
      averageSessionDuration: 0.0,
      totalDistractionsToday: 0,
    );
  }

  @override
  ProductivityInsightsModel copyWith({
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
    return ProductivityInsightsModel(
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
}

/// Data model for productivity recommendations
class ProductivityRecommendationModel extends ProductivityRecommendation {
  const ProductivityRecommendationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.priority,
    super.actionText,
    super.actionRoute,
  });

  factory ProductivityRecommendationModel.fromEntity(
    ProductivityRecommendation entity,
  ) {
    return ProductivityRecommendationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      type: entity.type,
      priority: entity.priority,
      actionText: entity.actionText,
      actionRoute: entity.actionRoute,
    );
  }

  factory ProductivityRecommendationModel.fromJson(Map<String, dynamic> json) {
    return ProductivityRecommendationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ProductivityRecommendationType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      priority: json['priority'],
      actionText: json['actionText'],
      actionRoute: json['actionRoute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'priority': priority,
      'actionText': actionText,
      'actionRoute': actionRoute,
    };
  }
}

/// Data model for productivity trends
class ProductivityTrendModel extends ProductivityTrend {
  const ProductivityTrendModel({
    required super.date,
    required super.score,
    required super.focusHours,
    required super.tasksCompleted,
    required super.sessionsCompleted,
  });

  factory ProductivityTrendModel.fromEntity(ProductivityTrend entity) {
    return ProductivityTrendModel(
      date: entity.date,
      score: entity.score,
      focusHours: entity.focusHours,
      tasksCompleted: entity.tasksCompleted,
      sessionsCompleted: entity.sessionsCompleted,
    );
  }

  factory ProductivityTrendModel.fromJson(Map<String, dynamic> json) {
    return ProductivityTrendModel(
      date: DateTime.parse(json['date']),
      score: json['score']?.toDouble() ?? 0.0,
      focusHours: json['focusHours']?.toDouble() ?? 0.0,
      tasksCompleted: json['tasksCompleted'] ?? 0,
      sessionsCompleted: json['sessionsCompleted'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'score': score,
      'focusHours': focusHours,
      'tasksCompleted': tasksCompleted,
      'sessionsCompleted': sessionsCompleted,
    };
  }
}
