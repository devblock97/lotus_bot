import 'dart:async';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';
import 'package:lotus_ai/features/settings/interactor/settings_repository.dart';

class SettingsInteractor {
  SettingsInteractor({required SettingsRepository repository})
      : _repository = repository;

  final SettingsRepository _repository;

  Future<AppSettings> getSettings() => _repository.getSettings();

  Stream<AppSettings> watchSettings() => _repository.watchSettings();

  Future<void> updateSettings(AppSettings settings) =>
      _repository.updateSettings(settings);

  Future<String> testConnection(AppSettings settings) =>
      _repository.testConnection(settings);
}
