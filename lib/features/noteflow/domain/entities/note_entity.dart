/// Domain entity representing a note in the application
class NoteEntity {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final int textAlignment; // 0: left, 1: center, 2: right, 3: justify

  const NoteEntity({
    required this.id,
    required this.content,
    required this.createdAt,
    this.deletedAt,
    this.textAlignment = 0, // Default to left alignment
  });

  /// Create a copy of this entity with modified fields
  NoteEntity copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? deletedAt,
    int? textAlignment,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      textAlignment: textAlignment ?? this.textAlignment,
    );
  }

  /// Check if this note is deleted
  bool get isDeleted => deletedAt != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteEntity &&
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
    return 'NoteEntity(id: $id, content: $content, createdAt: $createdAt, deletedAt: $deletedAt, textAlignment: $textAlignment)';
  }
}
