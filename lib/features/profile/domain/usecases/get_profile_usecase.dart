import '../entities/profile_entity.dart';
import '../repositories/profile_repository_interface.dart';

class GetProfileUseCase {
  final ProfileRepositoryInterface repository;

  GetProfileUseCase(this.repository);

  Future<ProfileEntity> execute() {
    return repository.getProfile();
  }
}
