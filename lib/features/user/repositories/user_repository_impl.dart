import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';
import 'package:ailook_flutter/features/user/user.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(
    this._userRemoteDataSource,
  );

  final UserRemoteDataSource _userRemoteDataSource;

  @override
  Future<Result<UserProfileResponseEntity>> getUserProfileData() async {
    try {
      final userResponseModel =
          await _userRemoteDataSource.getUserProfileData();

      // remote data source에서 받아온 모델을 앱에서 사용하는 모델로 변환
      return Result.success(
          UserProfileResponseEntity.fromModel(userResponseModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> submitUserProfileData(UserProfileEntity data) async {
    try {
      final userDto = await _userRemoteDataSource.submitUserProfileData(
          userProfileData: data);

      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
