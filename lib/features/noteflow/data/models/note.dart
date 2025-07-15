import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';

/// Data model representing a note in the persistence layer
class Note {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final int textAlignment; // 0: left, 1: center, 2: right, 3: justify

  Note({
    required this.id,
    required this.content,
    required this.createdAt,
    this.deletedAt,
    this.textAlignment = 0, // Default to left alignment
  });

  /// Convert note to JSON format for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'textAlignment': textAlignment,
    };
  }

  /// Create a note from JSON format
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      textAlignment:
          json['textAlignment'] ?? 0, // Default to left if not present
    );
  }

  /// Convert to domain entity
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      content: content,
      createdAt: createdAt,
      deletedAt: deletedAt,
      textAlignment: textAlignment,
    );
  }

  /// Create from domain entity
  factory Note.fromEntity(NoteEntity entity) {
    return Note(
      id: entity.id,
      content: entity.content,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      textAlignment: entity.textAlignment,
    );
  }

  /// Create a copy with modified fields
  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? deletedAt,
    int? textAlignment,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      textAlignment: textAlignment ?? this.textAlignment,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note &&
        other.id == id &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt &&
        other.textAlignment == textAlignment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode ^
        textAlignment.hashCode;
  }

  @override
  String toString() {
    return 'Note(id: $id, content: $content, createdAt: $createdAt, deletedAt: $deletedAt, textAlignment: $textAlignment)';
  }
}
