import 'package:drift/drift.dart';
import 'package:lotus_ai/core/database/app_database.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';

abstract class ChatLocalDataSource {
  Stream<List<Conversation>> watchConversations();
  Future<List<Conversation>> getConversations();
  Future<Conversation?> getConversation(String id);
  Future<Conversation> createConversation({
    required String title,
    String? modelName,
    String? id,
  });
  Future<void> renameConversation(String id, String newTitle);
  Future<void> deleteConversation(String id);
  Future<void> togglePin(String id);
  Future<void> toggleFavourite(String id);
  Future<void> saveDraft(String id, String draft);

  Stream<List<Message>> watchMessages(String conversationId);
  Future<List<Message>> getMessages(String conversationId);
  Future<void> saveMessage(Message message);
  Future<void> deleteMessage(String messageId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  ChatLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Conversation>> watchConversations() {
    final query = _db.select(_db.conversationTable)
      ..orderBy([
        (t) => OrderingTerm.desc(t.isPinned),
        (t) => OrderingTerm.desc(t.updatedAt),
      ]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => Conversation(
                  id: row.id,
                  title: row.title,
                  createdAt: row.createdAt,
                  updatedAt: row.updatedAt,
                  isPinned: row.isPinned,
                  isFavourite: row.isFavourite,
                  modelName: row.modelName,
                  draftMessage: row.draftMessage,
                  systemPrompt: row.systemPrompt,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<Conversation>> getConversations() async {
    final query = _db.select(_db.conversationTable)
      ..orderBy([
        (t) => OrderingTerm.desc(t.isPinned),
        (t) => OrderingTerm.desc(t.updatedAt),
      ]);

    final rows = await query.get();
    return rows
        .map(
          (row) => Conversation(
            id: row.id,
            title: row.title,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
            isPinned: row.isPinned,
            isFavourite: row.isFavourite,
            modelName: row.modelName,
            draftMessage: row.draftMessage,
            systemPrompt: row.systemPrompt,
          ),
        )
        .toList();
  }

  @override
  Future<Conversation?> getConversation(String id) async {
    final query = _db.select(_db.conversationTable)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return Conversation(
      id: row.id,
      title: row.title,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isPinned: row.isPinned,
      isFavourite: row.isFavourite,
      modelName: row.modelName,
      draftMessage: row.draftMessage,
      systemPrompt: row.systemPrompt,
    );
  }

  @override
  Future<Conversation> createConversation({
    required String title,
    String? modelName,
    String? id,
  }) async {
    final now = DateTime.now();
    final conversationId = id ?? now.millisecondsSinceEpoch.toString();
    final conv = Conversation(
      id: conversationId,
      title: title,
      createdAt: now,
      updatedAt: now,
      modelName: modelName ?? 'gemini-1.5-flash',
    );

    await _db.into(_db.conversationTable).insert(
          ConversationTableCompanion.insert(
            id: conv.id,
            title: conv.title,
            createdAt: conv.createdAt,
            updatedAt: conv.updatedAt,
            modelName: Value(conv.modelName),
          ),
        );
    return conv;
  }

  @override
  Future<void> renameConversation(String id, String newTitle) async {
    await (_db.update(_db.conversationTable)..where((tbl) => tbl.id.equals(id)))
        .write(
      ConversationTableCompanion(
        title: Value(newTitle),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteConversation(String id) async {
    await (_db.delete(_db.conversationTable)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<void> togglePin(String id) async {
    final current = await (_db.select(_db.conversationTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (current != null) {
      await (_db.update(_db.conversationTable)
            ..where((tbl) => tbl.id.equals(id)))
          .write(
        ConversationTableCompanion(
          isPinned: Value(!current.isPinned),
        ),
      );
    }
  }

  @override
  Future<void> toggleFavourite(String id) async {
    final current = await (_db.select(_db.conversationTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (current != null) {
      await (_db.update(_db.conversationTable)
            ..where((tbl) => tbl.id.equals(id)))
          .write(
        ConversationTableCompanion(
          isFavourite: Value(!current.isFavourite),
        ),
      );
    }
  }

  @override
  Future<void> saveDraft(String id, String draft) async {
    await (_db.update(_db.conversationTable)..where((tbl) => tbl.id.equals(id)))
        .write(
      ConversationTableCompanion(
        draftMessage: Value(draft),
      ),
    );
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.conversationId.equals(conversationId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => Message(
                  id: row.id,
                  conversationId: row.conversationId,
                  role: MessageRole.values.firstWhere(
                    (e) => e.name == row.senderRole,
                    orElse: () => MessageRole.assistant,
                  ),
                  content: row.content,
                  timestamp: row.timestamp,
                  isError: row.isError,
                  status: MessageStatus.values.firstWhere(
                    (e) => e.name == row.status,
                    orElse: () => MessageStatus.sent,
                  ),
                  replyToId: row.replyToId,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.conversationId.equals(conversationId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]);

    final rows = await query.get();
    return rows
        .map(
          (row) => Message(
            id: row.id,
            conversationId: row.conversationId,
            role: MessageRole.values.firstWhere(
              (e) => e.name == row.senderRole,
              orElse: () => MessageRole.assistant,
            ),
            content: row.content,
            timestamp: row.timestamp,
            isError: row.isError,
            status: MessageStatus.values.firstWhere(
              (e) => e.name == row.status,
              orElse: () => MessageStatus.sent,
            ),
            replyToId: row.replyToId,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveMessage(Message message) async {
    await _db.into(_db.messageTable).insertOnConflictUpdate(
          MessageTableCompanion.insert(
            id: message.id,
            conversationId: message.conversationId,
            senderRole: message.role.name,
            content: message.content,
            timestamp: message.timestamp,
            isError: Value(message.isError),
            status: Value(message.status.name),
            replyToId: Value(message.replyToId),
          ),
        );

    // Also update parent conversation's updatedAt timestamp
    await (_db.update(_db.conversationTable)
          ..where((tbl) => tbl.id.equals(message.conversationId)))
        .write(
      ConversationTableCompanion(
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await (_db.delete(_db.messageTable)..where((t) => t.id.equals(messageId)))
        .go();
  }
}
