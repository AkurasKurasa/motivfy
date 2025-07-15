/// Productivity session entity representing a focus/work session
class ProductivitySessionEntity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String? taskId;
  final String? category;
  final bool wasDistracted;
  final int distractionCount;
  final double? focusRating; // 1-5 user rating
  final List<String>? distractionSources;
  final String? notes;

  const ProductivitySessionEntity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.taskId,
    this.category,
    required this.wasDistracted,
    required this.distractionCount,
    this.focusRating,
    this.distractionSources,
    this.notes,
  });

  /// Create a copy with updated values
  ProductivitySessionEntity copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? taskId,
    String? category,
    bool? wasDistracted,
    int? distractionCount,
    double? focusRating,
    List<String>? distractionSources,
    String? notes,
  }) {
    return ProductivitySessionEntity(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      taskId: taskId ?? this.taskId,
      category: category ?? this.category,
      wasDistracted: wasDistracted ?? this.wasDistracted,
      distractionCount: distractionCount ?? this.distractionCount,
      focusRating: focusRating ?? this.focusRating,
      distractionSources: distractionSources ?? this.distractionSources,
      notes: notes ?? this.notes,
    );
  }

  /// Calculate focus quality score (0-100)
  double get focusQualityScore {
    if (durationMinutes == 0) return 0;

    double baseScore = 100.0;

    // Reduce score based on distractions
    if (distractionCount > 0) {
      baseScore *= (1 - (distractionCount * 0.1).clamp(0, 0.8));
    }

    // Factor in user rating if available
    if (focusRating != null) {
      final ratingScore = (focusRating! / 5.0) * 100;
      baseScore = (baseScore + ratingScore) / 2;
    }

    return baseScore.clamp(0, 100);
  }

  /// Check if session was productive based on duration and distractions
  bool get wasProductive {
    return durationMinutes >= 15 && distractionCount <= 3;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductivitySessionEntity &&
        other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.durationMinutes == durationMinutes &&
        other.taskId == taskId &&
        other.category == category &&
        other.wasDistracted == wasDistracted &&
        other.distractionCount == distractionCount &&
        other.focusRating == focusRating &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        durationMinutes.hashCode ^
        taskId.hashCode ^
        category.hashCode ^
        wasDistracted.hashCode ^
        distractionCount.hashCode ^
        focusRating.hashCode ^
        notes.hashCode;
  }
}
