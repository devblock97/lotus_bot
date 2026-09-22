import 'package:drift/drift.dart';
import 'package:lotus_ai/core/database/app_database.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Stream<AppSettings> watchSettings();
  Future<void> updateSettings(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._db);

  final AppDatabase _db;
  static const String _singletonId = 'singleton';

  AppSettings _mapRowToEntity(AppSettingsTableData row) {
    final theme = AppThemeType.values.firstWhere(
      (e) => e.name == row.themeMode,
      orElse: () => AppThemeType.dark,
    );

    return AppSettings(
      themeMode: theme,
      activeAiProvider: row.activeAiProvider,
      activeAiModel: row.activeAiModel,
      geminiApiKey: row.geminiApiKey,
      grokApiKey: row.grokApiKey,
      alibabaApiKey: row.alibabaApiKey,
      localLlmBaseUrl: row.localLlmBaseUrl,
      customEndpoint: row.customEndpoint,
      customApiKey: row.customApiKey,
      systemPrompt: row.systemPrompt,
    );
  }

  @override
  Future<AppSettings> getSettings() async {
    final query = _db.select(_db.appSettingsTable)
      ..where((tbl) => tbl.id.equals(_singletonId));
    final row = await query.getSingleOrNull();

    if (row == null) {
      const defaultSettings = AppSettings();
      await _db.into(_db.appSettingsTable).insert(
            AppSettingsTableCompanion.insert(
              id: _singletonId,
              themeMode: Value(defaultSettings.themeMode.name),
              activeAiProvider: Value(defaultSettings.activeAiProvider),
              activeAiModel: Value(defaultSettings.activeAiModel),
              geminiApiKey: Value(defaultSettings.geminiApiKey),
              grokApiKey: Value(defaultSettings.grokApiKey),
              alibabaApiKey: Value(defaultSettings.alibabaApiKey),
              localLlmBaseUrl: Value(defaultSettings.localLlmBaseUrl),
              customEndpoint: Value(defaultSettings.customEndpoint),
              customApiKey: Value(defaultSettings.customApiKey),
              systemPrompt: Value(defaultSettings.systemPrompt),
            ),
          );
      return defaultSettings;
    }

    return _mapRowToEntity(row);
  }

  @override
  Stream<AppSettings> watchSettings() {
    final query = _db.select(_db.appSettingsTable)
      ..where((tbl) => tbl.id.equals(_singletonId));

    return query.watchSingleOrNull().map((row) {
      if (row == null) {
        return const AppSettings();
      }
      return _mapRowToEntity(row);
    });
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    await _db.into(_db.appSettingsTable).insertOnConflictUpdate(
          AppSettingsTableCompanion.insert(
            id: _singletonId,
            themeMode: Value(settings.themeMode.name),
            activeAiProvider: Value(settings.activeAiProvider),
            activeAiModel: Value(settings.activeAiModel),
            geminiApiKey: Value(settings.geminiApiKey),
            grokApiKey: Value(settings.grokApiKey),
            alibabaApiKey: Value(settings.alibabaApiKey),
            localLlmBaseUrl: Value(settings.localLlmBaseUrl),
            customEndpoint: Value(settings.customEndpoint),
            customApiKey: Value(settings.customApiKey),
            systemPrompt: Value(settings.systemPrompt),
          ),
        );
  }
}
