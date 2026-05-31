import 'package:ailook_flutter/features/chat/data_source/remote/models/chat_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatSessionResponse> getSessions();
  Future<ChatSessionModel> createSession(String title);
  Future<ChatSessionDetailResponse> getSessionMessages(int id);
  Future<ChatResponseModel> sendMessage(int id, String text, String? imageUrl, Map<String, dynamic>? profile);
  Future<void> deleteSession(int id);
}
