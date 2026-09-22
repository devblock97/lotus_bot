import 'dart:async';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';
import 'package:lotus_ai/features/settings/interactor/settings_local_data_source.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Stream<AppSettings> watchSettings();
  Future<void> updateSettings(AppSettings settings);
  Future<String> testConnection(AppSettings settings);
}

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required SettingsLocalDataSource localDataSource,
    required AiProviderRegistry aiRegistry,
  })  : _localDataSource = localDataSource,
        _aiRegistry = aiRegistry;

  final SettingsLocalDataSource _localDataSource;
  final AiProviderRegistry _aiRegistry;

  @override
  Future<AppSettings> getSettings() => _localDataSource.getSettings();

  @override
  Stream<AppSettings> watchSettings() => _localDataSource.watchSettings();

  @override
  Future<void> updateSettings(AppSettings settings) =>
      _localDataSource.updateSettings(settings);

  @override
  Future<String> testConnection(AppSettings settings) async {
    final provider = _aiRegistry.getProvider(settings);
    try {
      final response = await provider.sendMessage(
        prompt: 'Hello, respond with "OK" if connected.',
        model: settings.activeAiModel,
      );
      if (response.isEmpty) {
        return 'Empty response from provider';
      }
      return 'Connected successfully! ($response)';
    } catch (e) {
      return 'Connection failed: $e';
    }
  }
}
