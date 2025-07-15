import '../entities/profile_entity.dart';

/// Repository interface for profile operations
abstract class ProfileRepositoryInterface {
  /// Get user profile information
  Future<ProfileEntity> getProfile();

  /// Update user profile information
  Future<void> updateProfile(ProfileEntity profile);

  /// Update profile picture
  Future<void> updateProfilePicture(String imagePath);

  /// Delete profile picture
  Future<void> deleteProfilePicture();

  /// Check if profile exists
  Future<bool> profileExists();

  /// Reset profile to default values
  Future<void> resetProfile();
}
