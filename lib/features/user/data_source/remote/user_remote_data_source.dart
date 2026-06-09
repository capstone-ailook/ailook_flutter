import 'package:ailook_flutter/features/user/data_source/remote/models/user_profile_model.dart';
import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';

abstract interface class UserRemoteDataSource {
  ///
  /// 유저 정보 호출
  ///
  Future<UserProfileResponse> getUserProfileData();

  ///
  /// 유저 정보 제출
  ///
  Future<void> submitUserProfileData({required UserProfileEntity userProfileData});
}
