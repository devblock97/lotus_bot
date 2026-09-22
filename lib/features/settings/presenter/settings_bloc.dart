import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/logging/app_logger.dart';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';
import 'package:lotus_ai/features/settings/interactor/settings_interactor.dart';
import 'package:lotus_ai/features/settings/presenter/settings_event.dart';
import 'package:lotus_ai/features/settings/presenter/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsInteractor interactor,
  })  : _interactor = interactor,
        super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SettingsUpdatedEvent>(_onSettingsUpdated);
    on<ChangeAiProviderEvent>(_onChangeAiProvider);
    on<ChangeAiModelEvent>(_onChangeAiModel);
    on<UpdateApiKeyConfigEvent>(_onUpdateApiKeyConfig);
    on<ChangeThemeModeEvent>(_onChangeThemeMode);
    on<TestConnectionEvent>(_onTestConnection);

    add(const LoadSettingsEvent());
  }

  final SettingsInteractor _interactor;
  StreamSubscription<AppSettings>? _settingsSubscription;

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _settingsSubscription?.cancel();

    _settingsSubscription = _interactor.watchSettings().listen((settings) {
      add(SettingsUpdatedEvent(settings));
    });
  }

  void _onSettingsUpdated(
    SettingsUpdatedEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      settings: event.settings,
      isLoading: false,
    ));
  }

  Future<void> _onChangeAiProvider(
    ChangeAiProviderEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Find default model for new provider
    final descriptor = AiProviderRegistry.supportedProviders.firstWhere(
      (p) => p.id == event.providerId,
      orElse: () => AiProviderRegistry.supportedProviders.first,
    );

    final updated = state.settings.copyWith(
      activeAiProvider: event.providerId,
      activeAiModel: descriptor.defaultModel,
    );

    emit(state.copyWith(settings: updated, testStatus: TestStatus.initial));
    await _interactor.updateSettings(updated);
  }

  Future<void> _onChangeAiModel(
    ChangeAiModelEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(activeAiModel: event.model);
    emit(state.copyWith(settings: updated));
    await _interactor.updateSettings(updated);
  }

  Future<void> _onUpdateApiKeyConfig(
    UpdateApiKeyConfigEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(
      geminiApiKey: event.geminiApiKey,
      grokApiKey: event.grokApiKey,
      alibabaApiKey: event.alibabaApiKey,
      localLlmBaseUrl: event.localLlmBaseUrl,
      customEndpoint: event.customEndpoint,
      customApiKey: event.customApiKey,
      systemPrompt: event.systemPrompt,
    );

    emit(state.copyWith(settings: updated));
    await _interactor.updateSettings(updated);
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(themeMode: event.themeMode);
    emit(state.copyWith(settings: updated));
    await _interactor.updateSettings(updated);
  }

  Future<void> _onTestConnection(
    TestConnectionEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(
      testStatus: TestStatus.testing,
      testResult: 'Testing connection to ${state.settings.activeAiProvider}...',
    ));

    try {
      final result = await _interactor.testConnection(state.settings);
      final isSuccess = result.contains('successfully') || result.contains('OK');
      emit(state.copyWith(
        testStatus: isSuccess ? TestStatus.success : TestStatus.error,
        testResult: result,
      ));
    } catch (e, st) {
      AppLogger.error('Connection test failed', e, st);
      emit(state.copyWith(
        testStatus: TestStatus.error,
        testResult: 'Connection failed: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
