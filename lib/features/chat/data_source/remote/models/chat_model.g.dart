// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSessionResponse _$ChatSessionResponseFromJson(Map<String, dynamic> json) =>
    ChatSessionResponse(
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatSessionResponseToJson(
        ChatSessionResponse instance) =>
    <String, dynamic>{
      'sessions': instance.sessions,
    };

ChatSessionModel _$ChatSessionModelFromJson(Map<String, dynamic> json) =>
    ChatSessionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ChatSessionModelToJson(ChatSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
    };

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      role: json['role'] as String,
      text: json['text'] as String,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'role': instance.role,
      'text': instance.text,
      'image_url': instance.imageUrl,
    };

ChatSessionDetailResponse _$ChatSessionDetailResponseFromJson(
        Map<String, dynamic> json) =>
    ChatSessionDetailResponse(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatSessionDetailResponseToJson(
        ChatSessionDetailResponse instance) =>
    <String, dynamic>{
      'messages': instance.messages,
    };

ChatResponseModel _$ChatResponseModelFromJson(Map<String, dynamic> json) =>
    ChatResponseModel(
      reply: json['reply'] as String,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$ChatResponseModelToJson(ChatResponseModel instance) =>
    <String, dynamic>{
      'reply': instance.reply,
      'image_url': instance.imageUrl,
    };
