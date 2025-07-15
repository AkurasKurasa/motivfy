import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository_interface.dart';
import '../models/profile_model.dart';
import '../../../../core/services/user/user_data_manager.dart';

/// Repository implementation for profile operations using UserDataManager
class ProfileRepository implements ProfileRepositoryInterface {
  final UserDataManager _userDataManager;

  ProfileRepository(this._userDataManager);

  @override
  Future<ProfileEntity> getProfile() async {
    final userData = await _userDataManager.getUserData();
    final profileModel = ProfileModel.fromPersonalInfo(userData.personalInfo);
    return profileModel.toEntity();
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final profileModel = ProfileModel.fromEntity(profile);
    final personalInfo = profileModel.toPersonalInfo();
    await _userDataManager.updatePersonalInfo(personalInfo);
  }

  @override
  Future<void> updateProfilePicture(String imagePath) async {
    final currentProfile = await getProfile();
    final updatedProfile = currentProfile.copyWith(profilePicture: imagePath);
    await updateProfile(updatedProfile);
  }

  @override
  Future<void> deleteProfilePicture() async {
    final currentProfile = await getProfile();
    final updatedProfile = currentProfile.copyWith(profilePicture: null);
    await updateProfile(updatedProfile);
  }

  @override
  Future<bool> profileExists() async {
    final profile = await getProfile();
    return profile.isComplete;
  }

  @override
  Future<void> resetProfile() async {
    const emptyProfile = ProfileEntity();
    await updateProfile(emptyProfile);
  }
}
