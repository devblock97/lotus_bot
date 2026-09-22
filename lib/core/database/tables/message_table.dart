import 'package:drift/drift.dart';
import 'package:lotus_ai/core/database/tables/conversation_table.dart';

class MessageTable extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId =>
      text().references(ConversationTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get senderRole => text()();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isError => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('sent'))();
  TextColumn get replyToId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
