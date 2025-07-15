import '../entities/settings_entity.dart';
import '../repositories/settings_repository_interface.dart';

class UpdateSettingsUseCase {
  final SettingsRepositoryInterface repository;

  UpdateSettingsUseCase(this.repository);

  Future<void> execute(SettingsEntity settings) {
    return repository.updateSettings(settings);
  }
}
