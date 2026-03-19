import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';

abstract interface class UserRepository {
  /// 서버에서 유저 정보를 가져옴
  Future<Result<UserProfileResponseEntity>> getUserProfileData();

  Future<Result<void>> submitUserProfileData(UserProfileEntity data);
}