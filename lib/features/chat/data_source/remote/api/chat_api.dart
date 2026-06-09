import 'package:ailook_flutter/features/chat/data_source/remote/models/chat_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_api.g.dart';

@RestApi()
abstract class ChatAPI {
  factory ChatAPI(Dio dio, {String baseUrl}) = _ChatAPI;

  @GET('/chat/sessions/')
  Future<ChatSessionResponse> getSessions();

  @POST('/chat/sessions/')
  Future<ChatSessionModel> createSession(@Body() Map<String, dynamic> body);

  @GET('/chat/sessions/{id}/')
  Future<ChatSessionDetailResponse> getSessionMessages(@Path('id') int id);

  @POST('/chat/sessions/{id}/')
  Future<ChatResponseModel> sendMessage(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/chat/sessions/{id}/')
  Future<void> deleteSession(@Path('id') int id);
}
