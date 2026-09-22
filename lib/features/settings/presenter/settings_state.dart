import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';

enum TestStatus { initial, testing, success, error }

@immutable
class SettingsState extends Equatable {
  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoading = false,
    this.testStatus = TestStatus.initial,
    this.testResult = '',
    this.errorMessage,
  });

  final AppSettings settings;
  final bool isLoading;
  final TestStatus testStatus;
  final String testResult;
  final String? errorMessage;

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoading,
    TestStatus? testStatus,
    String? testResult,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      testStatus: testStatus ?? this.testStatus,
      testResult: testResult ?? this.testResult,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        settings,
        isLoading,
        testStatus,
        testResult,
        errorMessage,
      ];
}
