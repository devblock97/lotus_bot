import 'package:drift/drift.dart';

class ConversationTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  TextColumn get modelName =>
      text().withDefault(const Constant('gemini-1.5-flash'))();
  TextColumn get draftMessage => text().nullable()();
  TextColumn get systemPrompt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
