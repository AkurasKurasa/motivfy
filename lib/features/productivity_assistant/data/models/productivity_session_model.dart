import '../../domain/entities/productivity_session_entity.dart';

/// Data model for productivity session with JSON serialization capabilities
class ProductivitySessionModel extends ProductivitySessionEntity {
  const ProductivitySessionModel({
    required super.id,
    required super.startTime,
    required super.endTime,
    required super.durationMinutes,
    super.taskId,
    super.category,
    required super.wasDistracted,
    required super.distractionCount,
    super.focusRating,
    super.distractionSources,
    super.notes,
  });

  /// Create a ProductivitySessionModel from an entity
  factory ProductivitySessionModel.fromEntity(
    ProductivitySessionEntity entity,
  ) {
    return ProductivitySessionModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationMinutes: entity.durationMinutes,
      taskId: entity.taskId,
      category: entity.category,
      wasDistracted: entity.wasDistracted,
      distractionCount: entity.distractionCount,
      focusRating: entity.focusRating,
      distractionSources: entity.distractionSources,
      notes: entity.notes,
    );
  }

  /// Create from JSON
  factory ProductivitySessionModel.fromJson(Map<String, dynamic> json) {
    return ProductivitySessionModel(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      durationMinutes: json['durationMinutes'],
      taskId: json['taskId'],
      category: json['category'],
      wasDistracted: json['wasDistracted'] ?? false,
      distractionCount: json['distractionCount'] ?? 0,
      focusRating: json['focusRating']?.toDouble(),
      distractionSources: (json['distractionSources'] as List?)?.cast<String>(),
      notes: json['notes'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'taskId': taskId,
      'category': category,
      'wasDistracted': wasDistracted,
      'distractionCount': distractionCount,
      'focusRating': focusRating,
      'distractionSources': distractionSources,
      'notes': notes,
    };
  }

  /// Create a new session
  factory ProductivitySessionModel.newSession({
    String? taskId,
    String? category,
  }) {
    final now = DateTime.now();
    return ProductivitySessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: now,
      endTime: now,
      durationMinutes: 0,
      taskId: taskId,
      category: category,
      wasDistracted: false,
      distractionCount: 0,
    );
  }

  @override
  ProductivitySessionModel copyWith({
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
    return ProductivitySessionModel(
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
}
