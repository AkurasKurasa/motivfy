import '../entities/profile_entity.dart';
import '../repositories/profile_repository_interface.dart';

class UpdateProfileUseCase {
  final ProfileRepositoryInterface repository;

  UpdateProfileUseCase(this.repository);

  Future<void> execute(ProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
