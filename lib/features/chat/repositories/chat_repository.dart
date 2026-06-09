import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/chat/repositories/entities/chat_entity.dart';

abstract interface class ChatRepository {
  Future<Result<ChatSessionListEntity>> getSessions();
  Future<Result<ChatSessionEntity>> createSession(String title);
  Future<Result<List<ChatMessageEntity>>> getSessionMessages(int id);
  Future<Result<ChatResponseDataEntity>> sendMessage(int id, String text, {String? imageUrl, Map<String, dynamic>? profile, int? anchorItemId});
  Future<Result<void>> deleteSession(int id);
}
