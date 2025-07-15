import '../repositories/settings_repository_interface.dart';

class ResetSettingsUseCase {
  final SettingsRepositoryInterface repository;

  ResetSettingsUseCase(this.repository);

  Future<void> execute() {
    return repository.resetToDefault();
  }
}
