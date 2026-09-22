// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ConversationTableTable extends ConversationTable
    with TableInfo<$ConversationTableTable, ConversationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFavouriteMeta =
      const VerificationMeta('isFavourite');
  @override
  late final GeneratedColumn<bool> isFavourite = GeneratedColumn<bool>(
      'is_favourite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_favourite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('gemini-1.5-flash'));
  static const VerificationMeta _draftMessageMeta =
      const VerificationMeta('draftMessage');
  @override
  late final GeneratedColumn<String> draftMessage = GeneratedColumn<String>(
      'draft_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _systemPromptMeta =
      const VerificationMeta('systemPrompt');
  @override
  late final GeneratedColumn<String> systemPrompt = GeneratedColumn<String>(
      'system_prompt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        createdAt,
        updatedAt,
        isPinned,
        isFavourite,
        modelName,
        draftMessage,
        systemPrompt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConversationTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('is_favourite')) {
      context.handle(
          _isFavouriteMeta,
          isFavourite.isAcceptableOrUnknown(
              data['is_favourite']!, _isFavouriteMeta));
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    }
    if (data.containsKey('draft_message')) {
      context.handle(
          _draftMessageMeta,
          draftMessage.isAcceptableOrUnknown(
              data['draft_message']!, _draftMessageMeta));
    }
    if (data.containsKey('system_prompt')) {
      context.handle(
          _systemPromptMeta,
          systemPrompt.isAcceptableOrUnknown(
              data['system_prompt']!, _systemPromptMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      isFavourite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favourite'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name'])!,
      draftMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}draft_message']),
      systemPrompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_prompt']),
    );
  }

  @override
  $ConversationTableTable createAlias(String alias) {
    return $ConversationTableTable(attachedDatabase, alias);
  }
}

class ConversationTableData extends DataClass
    implements Insertable<ConversationTableData> {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isFavourite;
  final String modelName;
  final String? draftMessage;
  final String? systemPrompt;
  const ConversationTableData(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.updatedAt,
      required this.isPinned,
      required this.isFavourite,
      required this.modelName,
      this.draftMessage,
      this.systemPrompt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_favourite'] = Variable<bool>(isFavourite);
    map['model_name'] = Variable<String>(modelName);
    if (!nullToAbsent || draftMessage != null) {
      map['draft_message'] = Variable<String>(draftMessage);
    }
    if (!nullToAbsent || systemPrompt != null) {
      map['system_prompt'] = Variable<String>(systemPrompt);
    }
    return map;
  }

  ConversationTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationTableCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isPinned: Value(isPinned),
      isFavourite: Value(isFavourite),
      modelName: Value(modelName),
      draftMessage: draftMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(draftMessage),
      systemPrompt: systemPrompt == null && nullToAbsent
          ? const Value.absent()
          : Value(systemPrompt),
    );
  }

  factory ConversationTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isFavourite: serializer.fromJson<bool>(json['isFavourite']),
      modelName: serializer.fromJson<String>(json['modelName']),
      draftMessage: serializer.fromJson<String?>(json['draftMessage']),
      systemPrompt: serializer.fromJson<String?>(json['systemPrompt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isFavourite': serializer.toJson<bool>(isFavourite),
      'modelName': serializer.toJson<String>(modelName),
      'draftMessage': serializer.toJson<String?>(draftMessage),
      'systemPrompt': serializer.toJson<String?>(systemPrompt),
    };
  }

  ConversationTableData copyWith(
          {String? id,
          String? title,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isPinned,
          bool? isFavourite,
          String? modelName,
          Value<String?> draftMessage = const Value.absent(),
          Value<String?> systemPrompt = const Value.absent()}) =>
      ConversationTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isPinned: isPinned ?? this.isPinned,
        isFavourite: isFavourite ?? this.isFavourite,
        modelName: modelName ?? this.modelName,
        draftMessage:
            draftMessage.present ? draftMessage.value : this.draftMessage,
        systemPrompt:
            systemPrompt.present ? systemPrompt.value : this.systemPrompt,
      );
  ConversationTableData copyWithCompanion(ConversationTableCompanion data) {
    return ConversationTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isFavourite:
          data.isFavourite.present ? data.isFavourite.value : this.isFavourite,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      draftMessage: data.draftMessage.present
          ? data.draftMessage.value
          : this.draftMessage,
      systemPrompt: data.systemPrompt.present
          ? data.systemPrompt.value
          : this.systemPrompt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('modelName: $modelName, ')
          ..write('draftMessage: $draftMessage, ')
          ..write('systemPrompt: $systemPrompt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt, isPinned,
      isFavourite, modelName, draftMessage, systemPrompt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isPinned == this.isPinned &&
          other.isFavourite == this.isFavourite &&
          other.modelName == this.modelName &&
          other.draftMessage == this.draftMessage &&
          other.systemPrompt == this.systemPrompt);
}

class ConversationTableCompanion
    extends UpdateCompanion<ConversationTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isPinned;
  final Value<bool> isFavourite;
  final Value<String> modelName;
  final Value<String?> draftMessage;
  final Value<String?> systemPrompt;
  final Value<int> rowid;
  const ConversationTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.modelName = const Value.absent(),
    this.draftMessage = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationTableCompanion.insert({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isPinned = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.modelName = const Value.absent(),
    this.draftMessage = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ConversationTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isPinned,
    Expression<bool>? isFavourite,
    Expression<String>? modelName,
    Expression<String>? draftMessage,
    Expression<String>? systemPrompt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isFavourite != null) 'is_favourite': isFavourite,
      if (modelName != null) 'model_name': modelName,
      if (draftMessage != null) 'draft_message': draftMessage,
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isPinned,
      Value<bool>? isFavourite,
      Value<String>? modelName,
      Value<String?>? draftMessage,
      Value<String?>? systemPrompt,
      Value<int>? rowid}) {
    return ConversationTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isFavourite: isFavourite ?? this.isFavourite,
      modelName: modelName ?? this.modelName,
      draftMessage: draftMessage ?? this.draftMessage,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<bool>(isFavourite.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (draftMessage.present) {
      map['draft_message'] = Variable<String>(draftMessage.value);
    }
    if (systemPrompt.present) {
      map['system_prompt'] = Variable<String>(systemPrompt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('modelName: $modelName, ')
          ..write('draftMessage: $draftMessage, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageTableTable extends MessageTable
    with TableInfo<$MessageTableTable, MessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderRoleMeta =
      const VerificationMeta('senderRole');
  @override
  late final GeneratedColumn<String> senderRole = GeneratedColumn<String>(
      'sender_role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isErrorMeta =
      const VerificationMeta('isError');
  @override
  late final GeneratedColumn<bool> isError = GeneratedColumn<bool>(
      'is_error', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_error" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('sent'));
  static const VerificationMeta _replyToIdMeta =
      const VerificationMeta('replyToId');
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
      'reply_to_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        conversationId,
        senderRole,
        content,
        timestamp,
        isError,
        status,
        replyToId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_table';
  @override
  VerificationContext validateIntegrity(Insertable<MessageTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_role')) {
      context.handle(
          _senderRoleMeta,
          senderRole.isAcceptableOrUnknown(
              data['sender_role']!, _senderRoleMeta));
    } else if (isInserting) {
      context.missing(_senderRoleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_error')) {
      context.handle(_isErrorMeta,
          isError.isAcceptableOrUnknown(data['is_error']!, _isErrorMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
          _replyToIdMeta,
          replyToId.isAcceptableOrUnknown(
              data['reply_to_id']!, _replyToIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      senderRole: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      isError: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_error'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      replyToId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_to_id']),
    );
  }

  @override
  $MessageTableTable createAlias(String alias) {
    return $MessageTableTable(attachedDatabase, alias);
  }
}

class MessageTableData extends DataClass
    implements Insertable<MessageTableData> {
  final String id;
  final String conversationId;
  final String senderRole;
  final String content;
  final DateTime timestamp;
  final bool isError;
  final String status;
  final String? replyToId;
  const MessageTableData(
      {required this.id,
      required this.conversationId,
      required this.senderRole,
      required this.content,
      required this.timestamp,
      required this.isError,
      required this.status,
      this.replyToId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_role'] = Variable<String>(senderRole);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_error'] = Variable<bool>(isError);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    return map;
  }

  MessageTableCompanion toCompanion(bool nullToAbsent) {
    return MessageTableCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      senderRole: Value(senderRole),
      content: Value(content),
      timestamp: Value(timestamp),
      isError: Value(isError),
      status: Value(status),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
    );
  }

  factory MessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTableData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderRole: serializer.fromJson<String>(json['senderRole']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isError: serializer.fromJson<bool>(json['isError']),
      status: serializer.fromJson<String>(json['status']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderRole': serializer.toJson<String>(senderRole),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isError': serializer.toJson<bool>(isError),
      'status': serializer.toJson<String>(status),
      'replyToId': serializer.toJson<String?>(replyToId),
    };
  }

  MessageTableData copyWith(
          {String? id,
          String? conversationId,
          String? senderRole,
          String? content,
          DateTime? timestamp,
          bool? isError,
          String? status,
          Value<String?> replyToId = const Value.absent()}) =>
      MessageTableData(
        id: id ?? this.id,
        conversationId: conversationId ?? this.conversationId,
        senderRole: senderRole ?? this.senderRole,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        isError: isError ?? this.isError,
        status: status ?? this.status,
        replyToId: replyToId.present ? replyToId.value : this.replyToId,
      );
  MessageTableData copyWithCompanion(MessageTableCompanion data) {
    return MessageTableData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderRole:
          data.senderRole.present ? data.senderRole.value : this.senderRole,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isError: data.isError.present ? data.isError.value : this.isError,
      status: data.status.present ? data.status.value : this.status,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderRole: $senderRole, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('isError: $isError, ')
          ..write('status: $status, ')
          ..write('replyToId: $replyToId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, conversationId, senderRole, content,
      timestamp, isError, status, replyToId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTableData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.senderRole == this.senderRole &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.isError == this.isError &&
          other.status == this.status &&
          other.replyToId == this.replyToId);
}

class MessageTableCompanion extends UpdateCompanion<MessageTableData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> senderRole;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<bool> isError;
  final Value<String> status;
  final Value<String?> replyToId;
  final Value<int> rowid;
  const MessageTableCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderRole = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isError = const Value.absent(),
    this.status = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageTableCompanion.insert({
    required String id,
    required String conversationId,
    required String senderRole,
    required String content,
    required DateTime timestamp,
    this.isError = const Value.absent(),
    this.status = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        conversationId = Value(conversationId),
        senderRole = Value(senderRole),
        content = Value(content),
        timestamp = Value(timestamp);
  static Insertable<MessageTableData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? senderRole,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<bool>? isError,
    Expression<String>? status,
    Expression<String>? replyToId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderRole != null) 'sender_role': senderRole,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (isError != null) 'is_error': isError,
      if (status != null) 'status': status,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? conversationId,
      Value<String>? senderRole,
      Value<String>? content,
      Value<DateTime>? timestamp,
      Value<bool>? isError,
      Value<String>? status,
      Value<String?>? replyToId,
      Value<int>? rowid}) {
    return MessageTableCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderRole: senderRole ?? this.senderRole,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
      status: status ?? this.status,
      replyToId: replyToId ?? this.replyToId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderRole.present) {
      map['sender_role'] = Variable<String>(senderRole.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isError.present) {
      map['is_error'] = Variable<bool>(isError.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderRole: $senderRole, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('isError: $isError, ')
          ..write('status: $status, ')
          ..write('replyToId: $replyToId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dark'));
  static const VerificationMeta _activeAiProviderMeta =
      const VerificationMeta('activeAiProvider');
  @override
  late final GeneratedColumn<String> activeAiProvider = GeneratedColumn<String>(
      'active_ai_provider', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('mock'));
  static const VerificationMeta _activeAiModelMeta =
      const VerificationMeta('activeAiModel');
  @override
  late final GeneratedColumn<String> activeAiModel = GeneratedColumn<String>(
      'active_ai_model', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('gemini-1.5-flash'));
  static const VerificationMeta _geminiApiKeyMeta =
      const VerificationMeta('geminiApiKey');
  @override
  late final GeneratedColumn<String> geminiApiKey = GeneratedColumn<String>(
      'gemini_api_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _grokApiKeyMeta =
      const VerificationMeta('grokApiKey');
  @override
  late final GeneratedColumn<String> grokApiKey = GeneratedColumn<String>(
      'grok_api_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _alibabaApiKeyMeta =
      const VerificationMeta('alibabaApiKey');
  @override
  late final GeneratedColumn<String> alibabaApiKey = GeneratedColumn<String>(
      'alibaba_api_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _localLlmBaseUrlMeta =
      const VerificationMeta('localLlmBaseUrl');
  @override
  late final GeneratedColumn<String> localLlmBaseUrl = GeneratedColumn<String>(
      'local_llm_base_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('http://localhost:11434'));
  static const VerificationMeta _customEndpointMeta =
      const VerificationMeta('customEndpoint');
  @override
  late final GeneratedColumn<String> customEndpoint = GeneratedColumn<String>(
      'custom_endpoint', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customApiKeyMeta =
      const VerificationMeta('customApiKey');
  @override
  late final GeneratedColumn<String> customApiKey = GeneratedColumn<String>(
      'custom_api_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _systemPromptMeta =
      const VerificationMeta('systemPrompt');
  @override
  late final GeneratedColumn<String> systemPrompt = GeneratedColumn<String>(
      'system_prompt', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('You are a helpful, expert AI assistant.'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        themeMode,
        activeAiProvider,
        activeAiModel,
        geminiApiKey,
        grokApiKey,
        alibabaApiKey,
        localLlmBaseUrl,
        customEndpoint,
        customApiKey,
        systemPrompt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('active_ai_provider')) {
      context.handle(
          _activeAiProviderMeta,
          activeAiProvider.isAcceptableOrUnknown(
              data['active_ai_provider']!, _activeAiProviderMeta));
    }
    if (data.containsKey('active_ai_model')) {
      context.handle(
          _activeAiModelMeta,
          activeAiModel.isAcceptableOrUnknown(
              data['active_ai_model']!, _activeAiModelMeta));
    }
    if (data.containsKey('gemini_api_key')) {
      context.handle(
          _geminiApiKeyMeta,
          geminiApiKey.isAcceptableOrUnknown(
              data['gemini_api_key']!, _geminiApiKeyMeta));
    }
    if (data.containsKey('grok_api_key')) {
      context.handle(
          _grokApiKeyMeta,
          grokApiKey.isAcceptableOrUnknown(
              data['grok_api_key']!, _grokApiKeyMeta));
    }
    if (data.containsKey('alibaba_api_key')) {
      context.handle(
          _alibabaApiKeyMeta,
          alibabaApiKey.isAcceptableOrUnknown(
              data['alibaba_api_key']!, _alibabaApiKeyMeta));
    }
    if (data.containsKey('local_llm_base_url')) {
      context.handle(
          _localLlmBaseUrlMeta,
          localLlmBaseUrl.isAcceptableOrUnknown(
              data['local_llm_base_url']!, _localLlmBaseUrlMeta));
    }
    if (data.containsKey('custom_endpoint')) {
      context.handle(
          _customEndpointMeta,
          customEndpoint.isAcceptableOrUnknown(
              data['custom_endpoint']!, _customEndpointMeta));
    }
    if (data.containsKey('custom_api_key')) {
      context.handle(
          _customApiKeyMeta,
          customApiKey.isAcceptableOrUnknown(
              data['custom_api_key']!, _customApiKeyMeta));
    }
    if (data.containsKey('system_prompt')) {
      context.handle(
          _systemPromptMeta,
          systemPrompt.isAcceptableOrUnknown(
              data['system_prompt']!, _systemPromptMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      activeAiProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}active_ai_provider'])!,
      activeAiModel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}active_ai_model'])!,
      geminiApiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gemini_api_key'])!,
      grokApiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grok_api_key'])!,
      alibabaApiKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}alibaba_api_key'])!,
      localLlmBaseUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_llm_base_url'])!,
      customEndpoint: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_endpoint'])!,
      customApiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_api_key'])!,
      systemPrompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_prompt'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String id;
  final String themeMode;
  final String activeAiProvider;
  final String activeAiModel;
  final String geminiApiKey;
  final String grokApiKey;
  final String alibabaApiKey;
  final String localLlmBaseUrl;
  final String customEndpoint;
  final String customApiKey;
  final String systemPrompt;
  const AppSettingsTableData(
      {required this.id,
      required this.themeMode,
      required this.activeAiProvider,
      required this.activeAiModel,
      required this.geminiApiKey,
      required this.grokApiKey,
      required this.alibabaApiKey,
      required this.localLlmBaseUrl,
      required this.customEndpoint,
      required this.customApiKey,
      required this.systemPrompt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['active_ai_provider'] = Variable<String>(activeAiProvider);
    map['active_ai_model'] = Variable<String>(activeAiModel);
    map['gemini_api_key'] = Variable<String>(geminiApiKey);
    map['grok_api_key'] = Variable<String>(grokApiKey);
    map['alibaba_api_key'] = Variable<String>(alibabaApiKey);
    map['local_llm_base_url'] = Variable<String>(localLlmBaseUrl);
    map['custom_endpoint'] = Variable<String>(customEndpoint);
    map['custom_api_key'] = Variable<String>(customApiKey);
    map['system_prompt'] = Variable<String>(systemPrompt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      activeAiProvider: Value(activeAiProvider),
      activeAiModel: Value(activeAiModel),
      geminiApiKey: Value(geminiApiKey),
      grokApiKey: Value(grokApiKey),
      alibabaApiKey: Value(alibabaApiKey),
      localLlmBaseUrl: Value(localLlmBaseUrl),
      customEndpoint: Value(customEndpoint),
      customApiKey: Value(customApiKey),
      systemPrompt: Value(systemPrompt),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      activeAiProvider: serializer.fromJson<String>(json['activeAiProvider']),
      activeAiModel: serializer.fromJson<String>(json['activeAiModel']),
      geminiApiKey: serializer.fromJson<String>(json['geminiApiKey']),
      grokApiKey: serializer.fromJson<String>(json['grokApiKey']),
      alibabaApiKey: serializer.fromJson<String>(json['alibabaApiKey']),
      localLlmBaseUrl: serializer.fromJson<String>(json['localLlmBaseUrl']),
      customEndpoint: serializer.fromJson<String>(json['customEndpoint']),
      customApiKey: serializer.fromJson<String>(json['customApiKey']),
      systemPrompt: serializer.fromJson<String>(json['systemPrompt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'activeAiProvider': serializer.toJson<String>(activeAiProvider),
      'activeAiModel': serializer.toJson<String>(activeAiModel),
      'geminiApiKey': serializer.toJson<String>(geminiApiKey),
      'grokApiKey': serializer.toJson<String>(grokApiKey),
      'alibabaApiKey': serializer.toJson<String>(alibabaApiKey),
      'localLlmBaseUrl': serializer.toJson<String>(localLlmBaseUrl),
      'customEndpoint': serializer.toJson<String>(customEndpoint),
      'customApiKey': serializer.toJson<String>(customApiKey),
      'systemPrompt': serializer.toJson<String>(systemPrompt),
    };
  }

  AppSettingsTableData copyWith(
          {String? id,
          String? themeMode,
          String? activeAiProvider,
          String? activeAiModel,
          String? geminiApiKey,
          String? grokApiKey,
          String? alibabaApiKey,
          String? localLlmBaseUrl,
          String? customEndpoint,
          String? customApiKey,
          String? systemPrompt}) =>
      AppSettingsTableData(
        id: id ?? this.id,
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
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      activeAiProvider: data.activeAiProvider.present
          ? data.activeAiProvider.value
          : this.activeAiProvider,
      activeAiModel: data.activeAiModel.present
          ? data.activeAiModel.value
          : this.activeAiModel,
      geminiApiKey: data.geminiApiKey.present
          ? data.geminiApiKey.value
          : this.geminiApiKey,
      grokApiKey:
          data.grokApiKey.present ? data.grokApiKey.value : this.grokApiKey,
      alibabaApiKey: data.alibabaApiKey.present
          ? data.alibabaApiKey.value
          : this.alibabaApiKey,
      localLlmBaseUrl: data.localLlmBaseUrl.present
          ? data.localLlmBaseUrl.value
          : this.localLlmBaseUrl,
      customEndpoint: data.customEndpoint.present
          ? data.customEndpoint.value
          : this.customEndpoint,
      customApiKey: data.customApiKey.present
          ? data.customApiKey.value
          : this.customApiKey,
      systemPrompt: data.systemPrompt.present
          ? data.systemPrompt.value
          : this.systemPrompt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('activeAiProvider: $activeAiProvider, ')
          ..write('activeAiModel: $activeAiModel, ')
          ..write('geminiApiKey: $geminiApiKey, ')
          ..write('grokApiKey: $grokApiKey, ')
          ..write('alibabaApiKey: $alibabaApiKey, ')
          ..write('localLlmBaseUrl: $localLlmBaseUrl, ')
          ..write('customEndpoint: $customEndpoint, ')
          ..write('customApiKey: $customApiKey, ')
          ..write('systemPrompt: $systemPrompt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      themeMode,
      activeAiProvider,
      activeAiModel,
      geminiApiKey,
      grokApiKey,
      alibabaApiKey,
      localLlmBaseUrl,
      customEndpoint,
      customApiKey,
      systemPrompt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.activeAiProvider == this.activeAiProvider &&
          other.activeAiModel == this.activeAiModel &&
          other.geminiApiKey == this.geminiApiKey &&
          other.grokApiKey == this.grokApiKey &&
          other.alibabaApiKey == this.alibabaApiKey &&
          other.localLlmBaseUrl == this.localLlmBaseUrl &&
          other.customEndpoint == this.customEndpoint &&
          other.customApiKey == this.customApiKey &&
          other.systemPrompt == this.systemPrompt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> id;
  final Value<String> themeMode;
  final Value<String> activeAiProvider;
  final Value<String> activeAiModel;
  final Value<String> geminiApiKey;
  final Value<String> grokApiKey;
  final Value<String> alibabaApiKey;
  final Value<String> localLlmBaseUrl;
  final Value<String> customEndpoint;
  final Value<String> customApiKey;
  final Value<String> systemPrompt;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.activeAiProvider = const Value.absent(),
    this.activeAiModel = const Value.absent(),
    this.geminiApiKey = const Value.absent(),
    this.grokApiKey = const Value.absent(),
    this.alibabaApiKey = const Value.absent(),
    this.localLlmBaseUrl = const Value.absent(),
    this.customEndpoint = const Value.absent(),
    this.customApiKey = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String id,
    this.themeMode = const Value.absent(),
    this.activeAiProvider = const Value.absent(),
    this.activeAiModel = const Value.absent(),
    this.geminiApiKey = const Value.absent(),
    this.grokApiKey = const Value.absent(),
    this.alibabaApiKey = const Value.absent(),
    this.localLlmBaseUrl = const Value.absent(),
    this.customEndpoint = const Value.absent(),
    this.customApiKey = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? themeMode,
    Expression<String>? activeAiProvider,
    Expression<String>? activeAiModel,
    Expression<String>? geminiApiKey,
    Expression<String>? grokApiKey,
    Expression<String>? alibabaApiKey,
    Expression<String>? localLlmBaseUrl,
    Expression<String>? customEndpoint,
    Expression<String>? customApiKey,
    Expression<String>? systemPrompt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (activeAiProvider != null) 'active_ai_provider': activeAiProvider,
      if (activeAiModel != null) 'active_ai_model': activeAiModel,
      if (geminiApiKey != null) 'gemini_api_key': geminiApiKey,
      if (grokApiKey != null) 'grok_api_key': grokApiKey,
      if (alibabaApiKey != null) 'alibaba_api_key': alibabaApiKey,
      if (localLlmBaseUrl != null) 'local_llm_base_url': localLlmBaseUrl,
      if (customEndpoint != null) 'custom_endpoint': customEndpoint,
      if (customApiKey != null) 'custom_api_key': customApiKey,
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? themeMode,
      Value<String>? activeAiProvider,
      Value<String>? activeAiModel,
      Value<String>? geminiApiKey,
      Value<String>? grokApiKey,
      Value<String>? alibabaApiKey,
      Value<String>? localLlmBaseUrl,
      Value<String>? customEndpoint,
      Value<String>? customApiKey,
      Value<String>? systemPrompt,
      Value<int>? rowid}) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (activeAiProvider.present) {
      map['active_ai_provider'] = Variable<String>(activeAiProvider.value);
    }
    if (activeAiModel.present) {
      map['active_ai_model'] = Variable<String>(activeAiModel.value);
    }
    if (geminiApiKey.present) {
      map['gemini_api_key'] = Variable<String>(geminiApiKey.value);
    }
    if (grokApiKey.present) {
      map['grok_api_key'] = Variable<String>(grokApiKey.value);
    }
    if (alibabaApiKey.present) {
      map['alibaba_api_key'] = Variable<String>(alibabaApiKey.value);
    }
    if (localLlmBaseUrl.present) {
      map['local_llm_base_url'] = Variable<String>(localLlmBaseUrl.value);
    }
    if (customEndpoint.present) {
      map['custom_endpoint'] = Variable<String>(customEndpoint.value);
    }
    if (customApiKey.present) {
      map['custom_api_key'] = Variable<String>(customApiKey.value);
    }
    if (systemPrompt.present) {
      map['system_prompt'] = Variable<String>(systemPrompt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('activeAiProvider: $activeAiProvider, ')
          ..write('activeAiModel: $activeAiModel, ')
          ..write('geminiApiKey: $geminiApiKey, ')
          ..write('grokApiKey: $grokApiKey, ')
          ..write('alibabaApiKey: $alibabaApiKey, ')
          ..write('localLlmBaseUrl: $localLlmBaseUrl, ')
          ..write('customEndpoint: $customEndpoint, ')
          ..write('customApiKey: $customApiKey, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConversationTableTable conversationTable =
      $ConversationTableTable(this);
  late final $MessageTableTable messageTable = $MessageTableTable(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [conversationTable, messageTable, appSettingsTable];
}

typedef $$ConversationTableTableCreateCompanionBuilder
    = ConversationTableCompanion Function({
  required String id,
  required String title,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isPinned,
  Value<bool> isFavourite,
  Value<String> modelName,
  Value<String?> draftMessage,
  Value<String?> systemPrompt,
  Value<int> rowid,
});
typedef $$ConversationTableTableUpdateCompanionBuilder
    = ConversationTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isPinned,
  Value<bool> isFavourite,
  Value<String> modelName,
  Value<String?> draftMessage,
  Value<String?> systemPrompt,
  Value<int> rowid,
});

class $$ConversationTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationTableTable> {
  $$ConversationTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavourite => $composableBuilder(
      column: $table.isFavourite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get draftMessage => $composableBuilder(
      column: $table.draftMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => ColumnFilters(column));
}

class $$ConversationTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationTableTable> {
  $$ConversationTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavourite => $composableBuilder(
      column: $table.isFavourite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get draftMessage => $composableBuilder(
      column: $table.draftMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt,
      builder: (column) => ColumnOrderings(column));
}

class $$ConversationTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationTableTable> {
  $$ConversationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isFavourite => $composableBuilder(
      column: $table.isFavourite, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<String> get draftMessage => $composableBuilder(
      column: $table.draftMessage, builder: (column) => column);

  GeneratedColumn<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => column);
}

class $$ConversationTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConversationTableTable,
    ConversationTableData,
    $$ConversationTableTableFilterComposer,
    $$ConversationTableTableOrderingComposer,
    $$ConversationTableTableAnnotationComposer,
    $$ConversationTableTableCreateCompanionBuilder,
    $$ConversationTableTableUpdateCompanionBuilder,
    (
      ConversationTableData,
      BaseReferences<_$AppDatabase, $ConversationTableTable,
          ConversationTableData>
    ),
    ConversationTableData,
    PrefetchHooks Function()> {
  $$ConversationTableTableTableManager(
      _$AppDatabase db, $ConversationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isFavourite = const Value.absent(),
            Value<String> modelName = const Value.absent(),
            Value<String?> draftMessage = const Value.absent(),
            Value<String?> systemPrompt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationTableCompanion(
            id: id,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isPinned: isPinned,
            isFavourite: isFavourite,
            modelName: modelName,
            draftMessage: draftMessage,
            systemPrompt: systemPrompt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isFavourite = const Value.absent(),
            Value<String> modelName = const Value.absent(),
            Value<String?> draftMessage = const Value.absent(),
            Value<String?> systemPrompt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationTableCompanion.insert(
            id: id,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isPinned: isPinned,
            isFavourite: isFavourite,
            modelName: modelName,
            draftMessage: draftMessage,
            systemPrompt: systemPrompt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConversationTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConversationTableTable,
    ConversationTableData,
    $$ConversationTableTableFilterComposer,
    $$ConversationTableTableOrderingComposer,
    $$ConversationTableTableAnnotationComposer,
    $$ConversationTableTableCreateCompanionBuilder,
    $$ConversationTableTableUpdateCompanionBuilder,
    (
      ConversationTableData,
      BaseReferences<_$AppDatabase, $ConversationTableTable,
          ConversationTableData>
    ),
    ConversationTableData,
    PrefetchHooks Function()>;
typedef $$MessageTableTableCreateCompanionBuilder = MessageTableCompanion
    Function({
  required String id,
  required String conversationId,
  required String senderRole,
  required String content,
  required DateTime timestamp,
  Value<bool> isError,
  Value<String> status,
  Value<String?> replyToId,
  Value<int> rowid,
});
typedef $$MessageTableTableUpdateCompanionBuilder = MessageTableCompanion
    Function({
  Value<String> id,
  Value<String> conversationId,
  Value<String> senderRole,
  Value<String> content,
  Value<DateTime> timestamp,
  Value<bool> isError,
  Value<String> status,
  Value<String?> replyToId,
  Value<int> rowid,
});

class $$MessageTableTableFilterComposer
    extends Composer<_$AppDatabase, $MessageTableTable> {
  $$MessageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderRole => $composableBuilder(
      column: $table.senderRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isError => $composableBuilder(
      column: $table.isError, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnFilters(column));
}

class $$MessageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageTableTable> {
  $$MessageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderRole => $composableBuilder(
      column: $table.senderRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isError => $composableBuilder(
      column: $table.isError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnOrderings(column));
}

class $$MessageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageTableTable> {
  $$MessageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
      column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<String> get senderRole => $composableBuilder(
      column: $table.senderRole, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isError =>
      $composableBuilder(column: $table.isError, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);
}

class $$MessageTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessageTableTable,
    MessageTableData,
    $$MessageTableTableFilterComposer,
    $$MessageTableTableOrderingComposer,
    $$MessageTableTableAnnotationComposer,
    $$MessageTableTableCreateCompanionBuilder,
    $$MessageTableTableUpdateCompanionBuilder,
    (
      MessageTableData,
      BaseReferences<_$AppDatabase, $MessageTableTable, MessageTableData>
    ),
    MessageTableData,
    PrefetchHooks Function()> {
  $$MessageTableTableTableManager(_$AppDatabase db, $MessageTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> conversationId = const Value.absent(),
            Value<String> senderRole = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<bool> isError = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageTableCompanion(
            id: id,
            conversationId: conversationId,
            senderRole: senderRole,
            content: content,
            timestamp: timestamp,
            isError: isError,
            status: status,
            replyToId: replyToId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String conversationId,
            required String senderRole,
            required String content,
            required DateTime timestamp,
            Value<bool> isError = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageTableCompanion.insert(
            id: id,
            conversationId: conversationId,
            senderRole: senderRole,
            content: content,
            timestamp: timestamp,
            isError: isError,
            status: status,
            replyToId: replyToId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessageTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessageTableTable,
    MessageTableData,
    $$MessageTableTableFilterComposer,
    $$MessageTableTableOrderingComposer,
    $$MessageTableTableAnnotationComposer,
    $$MessageTableTableCreateCompanionBuilder,
    $$MessageTableTableUpdateCompanionBuilder,
    (
      MessageTableData,
      BaseReferences<_$AppDatabase, $MessageTableTable, MessageTableData>
    ),
    MessageTableData,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  required String id,
  Value<String> themeMode,
  Value<String> activeAiProvider,
  Value<String> activeAiModel,
  Value<String> geminiApiKey,
  Value<String> grokApiKey,
  Value<String> alibabaApiKey,
  Value<String> localLlmBaseUrl,
  Value<String> customEndpoint,
  Value<String> customApiKey,
  Value<String> systemPrompt,
  Value<int> rowid,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<String> id,
  Value<String> themeMode,
  Value<String> activeAiProvider,
  Value<String> activeAiModel,
  Value<String> geminiApiKey,
  Value<String> grokApiKey,
  Value<String> alibabaApiKey,
  Value<String> localLlmBaseUrl,
  Value<String> customEndpoint,
  Value<String> customApiKey,
  Value<String> systemPrompt,
  Value<int> rowid,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeAiProvider => $composableBuilder(
      column: $table.activeAiProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeAiModel => $composableBuilder(
      column: $table.activeAiModel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geminiApiKey => $composableBuilder(
      column: $table.geminiApiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grokApiKey => $composableBuilder(
      column: $table.grokApiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alibabaApiKey => $composableBuilder(
      column: $table.alibabaApiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localLlmBaseUrl => $composableBuilder(
      column: $table.localLlmBaseUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customEndpoint => $composableBuilder(
      column: $table.customEndpoint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customApiKey => $composableBuilder(
      column: $table.customApiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeAiProvider => $composableBuilder(
      column: $table.activeAiProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeAiModel => $composableBuilder(
      column: $table.activeAiModel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geminiApiKey => $composableBuilder(
      column: $table.geminiApiKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grokApiKey => $composableBuilder(
      column: $table.grokApiKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alibabaApiKey => $composableBuilder(
      column: $table.alibabaApiKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localLlmBaseUrl => $composableBuilder(
      column: $table.localLlmBaseUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customEndpoint => $composableBuilder(
      column: $table.customEndpoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customApiKey => $composableBuilder(
      column: $table.customApiKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get activeAiProvider => $composableBuilder(
      column: $table.activeAiProvider, builder: (column) => column);

  GeneratedColumn<String> get activeAiModel => $composableBuilder(
      column: $table.activeAiModel, builder: (column) => column);

  GeneratedColumn<String> get geminiApiKey => $composableBuilder(
      column: $table.geminiApiKey, builder: (column) => column);

  GeneratedColumn<String> get grokApiKey => $composableBuilder(
      column: $table.grokApiKey, builder: (column) => column);

  GeneratedColumn<String> get alibabaApiKey => $composableBuilder(
      column: $table.alibabaApiKey, builder: (column) => column);

  GeneratedColumn<String> get localLlmBaseUrl => $composableBuilder(
      column: $table.localLlmBaseUrl, builder: (column) => column);

  GeneratedColumn<String> get customEndpoint => $composableBuilder(
      column: $table.customEndpoint, builder: (column) => column);

  GeneratedColumn<String> get customApiKey => $composableBuilder(
      column: $table.customApiKey, builder: (column) => column);

  GeneratedColumn<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String> activeAiProvider = const Value.absent(),
            Value<String> activeAiModel = const Value.absent(),
            Value<String> geminiApiKey = const Value.absent(),
            Value<String> grokApiKey = const Value.absent(),
            Value<String> alibabaApiKey = const Value.absent(),
            Value<String> localLlmBaseUrl = const Value.absent(),
            Value<String> customEndpoint = const Value.absent(),
            Value<String> customApiKey = const Value.absent(),
            Value<String> systemPrompt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            id: id,
            themeMode: themeMode,
            activeAiProvider: activeAiProvider,
            activeAiModel: activeAiModel,
            geminiApiKey: geminiApiKey,
            grokApiKey: grokApiKey,
            alibabaApiKey: alibabaApiKey,
            localLlmBaseUrl: localLlmBaseUrl,
            customEndpoint: customEndpoint,
            customApiKey: customApiKey,
            systemPrompt: systemPrompt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> themeMode = const Value.absent(),
            Value<String> activeAiProvider = const Value.absent(),
            Value<String> activeAiModel = const Value.absent(),
            Value<String> geminiApiKey = const Value.absent(),
            Value<String> grokApiKey = const Value.absent(),
            Value<String> alibabaApiKey = const Value.absent(),
            Value<String> localLlmBaseUrl = const Value.absent(),
            Value<String> customEndpoint = const Value.absent(),
            Value<String> customApiKey = const Value.absent(),
            Value<String> systemPrompt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            id: id,
            themeMode: themeMode,
            activeAiProvider: activeAiProvider,
            activeAiModel: activeAiModel,
            geminiApiKey: geminiApiKey,
            grokApiKey: grokApiKey,
            alibabaApiKey: alibabaApiKey,
            localLlmBaseUrl: localLlmBaseUrl,
            customEndpoint: customEndpoint,
            customApiKey: customApiKey,
            systemPrompt: systemPrompt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConversationTableTableTableManager get conversationTable =>
      $$ConversationTableTableTableManager(_db, _db.conversationTable);
  $$MessageTableTableTableManager get messageTable =>
      $$MessageTableTableTableManager(_db, _db.messageTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
