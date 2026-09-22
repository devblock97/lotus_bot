import 'package:drift/drift.dart';

class AppSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
  TextColumn get activeAiProvider =>
      text().withDefault(const Constant('mock'))();
  TextColumn get activeAiModel =>
      text().withDefault(const Constant('gemini-1.5-flash'))();
  TextColumn get geminiApiKey => text().withDefault(const Constant(''))();
  TextColumn get grokApiKey => text().withDefault(const Constant(''))();
  TextColumn get alibabaApiKey => text().withDefault(const Constant(''))();
  TextColumn get localLlmBaseUrl =>
      text().withDefault(const Constant('http://localhost:11434'))();
  TextColumn get customEndpoint => text().withDefault(const Constant(''))();
  TextColumn get customApiKey => text().withDefault(const Constant(''))();
  TextColumn get systemPrompt => text().withDefault(
        const Constant('You are a helpful, expert AI assistant.'),
      )();

  @override
  Set<Column> get primaryKey => {id};
}
