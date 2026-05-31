import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/chat/data_source/remote/chat_remote_data_source.dart';
import 'package:ailook_flutter/features/chat/repositories/entities/chat_entity.dart';
import 'package:ailook_flutter/features/chat/repositories/chat_repository.dart';

final class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ChatSessionListEntity>> getSessions() async {
    try {
      final response = await _remoteDataSource.getSessions();
      return Result.success(ChatSessionListEntity(
        sessions: response.sessions.map((s) => ChatSessionEntity(
          id: s.id,
          title: s.title,
          createdAt: s.createdAt,
        )).toList(),
      ));
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<ChatSessionEntity>> createSession(String title) async {
    try {
      final response = await _remoteDataSource.createSession(title);
      return Result.success(ChatSessionEntity(
        id: response.id,
        title: response.title,
        createdAt: response.createdAt,
      ));
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<ChatMessageEntity>>> getSessionMessages(int id) async {
    try {
      final response = await _remoteDataSource.getSessionMessages(id);
      final messages = response.messages.map((m) => ChatMessageEntity(
        role: m.role,
        text: m.text,
        imageUrl: m.imageUrl,
      )).toList();
      return Result.success(messages);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<ChatResponseDataEntity>> sendMessage(int id, String text, {String? imageUrl, Map<String, dynamic>? profile}) async {
    try {
      final response = await _remoteDataSource.sendMessage(id, text, imageUrl, profile);
      return Result.success(ChatResponseDataEntity(
        reply: response.reply,
        imageUrl: response.imageUrl,
      ));
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteSession(int id) async {
    try {
      await _remoteDataSource.deleteSession(id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}
