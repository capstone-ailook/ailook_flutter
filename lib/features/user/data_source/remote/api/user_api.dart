import 'package:dio/dio.dart' hide Headers;
import 'package:ailook_flutter/features/user/data_source/remote/models/user_profile_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserAPI {
  factory UserAPI(Dio dio, {String baseUrl}) = _UserAPI;

  @GET("/user/profile")
  @Headers({"requiresToken": true})
  Future<UserProfileResponse> getProfile();

  @POST("/user/profile/")
  @Headers({"requiresToken": true})
  Future<void> submitProfile(@Body() UserProfileModel signUpData);
}