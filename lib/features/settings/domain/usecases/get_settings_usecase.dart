import '../entities/settings_entity.dart';
import '../repositories/settings_repository_interface.dart';

class GetSettingsUseCase {
  final SettingsRepositoryInterface repository;

  GetSettingsUseCase(this.repository);

  Future<SettingsEntity> execute() {
    return repository.getSettings();
  }
}
