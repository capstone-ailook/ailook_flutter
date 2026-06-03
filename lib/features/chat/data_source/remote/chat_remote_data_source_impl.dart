import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/app/network/app_dio.dart';
import 'package:ailook_flutter/features/chat/data_source/remote/api/chat_api.dart';
import 'package:ailook_flutter/features/chat/data_source/remote/models/chat_model.dart';
import 'package:ailook_flutter/features/chat/data_source/remote/chat_remote_data_source.dart';

final class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatAPI _chatAPI = ChatAPI(
    AppDio.instance,
    baseUrl: Flavor.apiUrl,
  );

  @override
  Future<ChatSessionResponse> getSessions() {
    return _chatAPI.getSessions();
  }

  @override
  Future<ChatSessionModel> createSession(String title) {
    return _chatAPI.createSession({'title': title});
  }

  @override
  Future<ChatSessionDetailResponse> getSessionMessages(int id) {
    return _chatAPI.getSessionMessages(id);
  }

  @override
  Future<ChatResponseModel> sendMessage(int id, String text, String? imageUrl, Map<String, dynamic>? profile, int? anchorItemId) {
    final body = {
      'message': text,
      'image_url': imageUrl ?? '',
      if (profile != null) 'profile': profile,
      if (anchorItemId != null) 'anchor_item_id': anchorItemId,
    };
    return _chatAPI.sendMessage(id, body);
  }

  @override
  Future<void> deleteSession(int id) {
    return _chatAPI.deleteSession(id);
  }
}
