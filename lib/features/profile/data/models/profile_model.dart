import '../../../../core/services/user/user_data.dart';
import '../../domain/entities/profile_entity.dart';

/// Data model representing profile information for persistence
class ProfileModel {
  final String? name;
  final int? age;
  final String? email;
  final String? profilePicture;
  final DateTime? dateOfBirth;
  final String? phoneNumber;

  ProfileModel({
    this.name,
    this.age,
    this.email,
    this.profilePicture,
    this.dateOfBirth,
    this.phoneNumber,
  });

  /// Convert to JSON format for persistence
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'profilePicture': profilePicture,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phoneNumber': phoneNumber,
    };
  }

  /// Create from JSON format
  factory ProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileModel();
    return ProfileModel(
      name: json['name'],
      age: json['age'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      phoneNumber: json['phoneNumber'],
    );
  }

  /// Convert to domain entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      name: name,
      age: age,
      email: email,
      profilePicture: profilePicture,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
    );
  }

  /// Create from domain entity
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      name: entity.name,
      age: entity.age,
      email: entity.email,
      profilePicture: entity.profilePicture,
      dateOfBirth: entity.dateOfBirth,
      phoneNumber: entity.phoneNumber,
    );
  }

  /// Convert from PersonalInfo (from core user data)
  factory ProfileModel.fromPersonalInfo(PersonalInfo personalInfo) {
    return ProfileModel(
      name: personalInfo.name,
      age: personalInfo.age,
      email: personalInfo.email,
      profilePicture: personalInfo.profilePicture,
      dateOfBirth: personalInfo.dateOfBirth,
      phoneNumber: personalInfo.phoneNumber,
    );
  }

  /// Convert to PersonalInfo (for core user data)
  PersonalInfo toPersonalInfo() {
    return PersonalInfo(
      name: name,
      age: age,
      email: email,
      profilePicture: profilePicture,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel &&
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
    return 'ProfileModel(name: $name, email: $email, age: $age)';
  }
}
