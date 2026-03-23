import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/app/network/app_dio.dart';
import 'package:ailook_flutter/features/user/data_source/remote/api/user_api.dart';
import 'package:ailook_flutter/features/user/data_source/remote/models/user_profile_model.dart';
import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';
import 'package:ailook_flutter/features/user/data_source/remote/user_remote_data_source.dart';

final class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserAPI _userAPI = UserAPI(
    AppDio.instance,
    baseUrl: Flavor.apiUrl,
  );

  @override
  Future<UserProfileResponse> getUserProfileData() {
    return _userAPI.getProfile();
  }

  @override
  Future<void> submitUserProfileData({required UserProfileEntity userProfileData}) {
    final userProfileModel = UserProfileModel.fromEntity(userProfileData);

    return _userAPI.submitProfile(userProfileModel);
  }
  
}