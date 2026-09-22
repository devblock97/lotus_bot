import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class SettingsUpdatedEvent extends SettingsEvent {
  const SettingsUpdatedEvent(this.settings);
  final AppSettings settings;

  @override
  List<Object?> get props => [settings];
}

class ChangeAiProviderEvent extends SettingsEvent {
  const ChangeAiProviderEvent(this.providerId);
  final String providerId;

  @override
  List<Object?> get props => [providerId];
}

class ChangeAiModelEvent extends SettingsEvent {
  const ChangeAiModelEvent(this.model);
  final String model;

  @override
  List<Object?> get props => [model];
}

class UpdateApiKeyConfigEvent extends SettingsEvent {
  const UpdateApiKeyConfigEvent({
    this.geminiApiKey,
    this.grokApiKey,
    this.alibabaApiKey,
    this.localLlmBaseUrl,
    this.customEndpoint,
    this.customApiKey,
    this.systemPrompt,
  });

  final String? geminiApiKey;
  final String? grokApiKey;
  final String? alibabaApiKey;
  final String? localLlmBaseUrl;
  final String? customEndpoint;
  final String? customApiKey;
  final String? systemPrompt;

  @override
  List<Object?> get props => [
        geminiApiKey,
        grokApiKey,
        alibabaApiKey,
        localLlmBaseUrl,
        customEndpoint,
        customApiKey,
        systemPrompt,
      ];
}

class ChangeThemeModeEvent extends SettingsEvent {
  const ChangeThemeModeEvent(this.themeMode);
  final AppThemeType themeMode;

  @override
  List<Object?> get props => [themeMode];
}

class TestConnectionEvent extends SettingsEvent {
  const TestConnectionEvent();
}
