import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isFavourite = false,
    this.modelName = 'gemini-1.5-flash',
    this.draftMessage,
    this.systemPrompt,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isFavourite;
  final String modelName;
  final String? draftMessage;
  final String? systemPrompt;

  Conversation copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isFavourite,
    String? modelName,
    String? draftMessage,
    String? systemPrompt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isFavourite: isFavourite ?? this.isFavourite,
      modelName: modelName ?? this.modelName,
      draftMessage: draftMessage ?? this.draftMessage,
      systemPrompt: systemPrompt ?? this.systemPrompt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        updatedAt,
        isPinned,
        isFavourite,
        modelName,
        draftMessage,
        systemPrompt,
      ];
}
