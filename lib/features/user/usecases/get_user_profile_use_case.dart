import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/core/modules/base_use_case/base_no_param_use_case.dart';
import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';
import 'package:ailook_flutter/features/user/repositories/user_repository.dart';

final class GetUserProfileUseCase extends BaseNoParamUseCase<Result<UserProfileResponseEntity>> {
  GetUserProfileUseCase(
      this._userRepository,
      );

  final UserRepository _userRepository;

  @override
  Future<Result<UserProfileResponseEntity>> call() async {
    return _userRepository.getUserProfileData();
  }
}
