import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum AppThemeType {
  light,
  dark,
  sepia;

  bool get isLight => this == AppThemeType.light;
  bool get isDark => this == AppThemeType.dark;
  bool get isSepia => this == AppThemeType.sepia;
}

@immutable
class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = AppThemeType.dark,
    this.activeAiProvider = 'mock',
    this.activeAiModel = 'gemini-1.5-flash',
    this.geminiApiKey = '',
    this.grokApiKey = '',
    this.alibabaApiKey = '',
    this.localLlmBaseUrl = 'http://localhost:11434',
    this.customEndpoint = '',
    this.customApiKey = '',
    this.systemPrompt = 'You are a helpful, expert AI assistant.',
  });

  final AppThemeType themeMode;
  final String activeAiProvider;
  final String activeAiModel;
  final String geminiApiKey;
  final String grokApiKey;
  final String alibabaApiKey;
  final String localLlmBaseUrl;
  final String customEndpoint;
  final String customApiKey;
  final String systemPrompt;

  AppSettings copyWith({
    AppThemeType? themeMode,
    String? activeAiProvider,
    String? activeAiModel,
    String? geminiApiKey,
    String? grokApiKey,
    String? alibabaApiKey,
    String? localLlmBaseUrl,
    String? customEndpoint,
    String? customApiKey,
    String? systemPrompt,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      activeAiProvider: activeAiProvider ?? this.activeAiProvider,
      activeAiModel: activeAiModel ?? this.activeAiModel,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      grokApiKey: grokApiKey ?? this.grokApiKey,
      alibabaApiKey: alibabaApiKey ?? this.alibabaApiKey,
      localLlmBaseUrl: localLlmBaseUrl ?? this.localLlmBaseUrl,
      customEndpoint: customEndpoint ?? this.customEndpoint,
      customApiKey: customApiKey ?? this.customApiKey,
      systemPrompt: systemPrompt ?? this.systemPrompt,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        activeAiProvider,
        activeAiModel,
        geminiApiKey,
        grokApiKey,
        alibabaApiKey,
        localLlmBaseUrl,
        customEndpoint,
        customApiKey,
        systemPrompt,
      ];
}
