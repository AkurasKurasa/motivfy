/// Domain entity representing user profile information
class ProfileEntity {
  final String? name;
  final int? age;
  final String? email;
  final String? profilePicture;
  final DateTime? dateOfBirth;
  final String? phoneNumber;

  const ProfileEntity({
    this.name,
    this.age,
    this.email,
    this.profilePicture,
    this.dateOfBirth,
    this.phoneNumber,
  });

  /// Create a copy of this entity with modified fields
  ProfileEntity copyWith({
    String? name,
    int? age,
    String? email,
    String? profilePicture,
    DateTime? dateOfBirth,
    String? phoneNumber,
  }) {
    return ProfileEntity(
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  /// Check if profile is complete
  bool get isComplete {
    return name != null &&
        name!.isNotEmpty &&
        email != null &&
        email!.isNotEmpty;
  }

  /// Get display name (name or email)
  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    if (email != null && email!.isNotEmpty) {
      return email!;
    }
    return 'User';
  }

  /// Calculate age from date of birth
  int? get calculatedAge {
    if (dateOfBirth == null) return age;

    final now = DateTime.now();
    int calculatedAge = now.year - dateOfBirth!.year;

    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileEntity &&
        other.name == name &&
        other.age == age &&
        other.email == email &&
        other.profilePicture == profilePicture &&
        other.dateOfBirth == dateOfBirth &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        age.hashCode ^
        email.hashCode ^
        profilePicture.hashCode ^
        dateOfBirth.hashCode ^
        phoneNumber.hashCode;
  }

  @override
  String toString() {
    return 'ProfileEntity(name: $name, email: $email, age: $calculatedAge)';
  }
}
