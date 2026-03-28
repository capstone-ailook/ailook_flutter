import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/core/modules/base_use_case/base_use_case.dart';
import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';
import 'package:ailook_flutter/features/user/repositories/user_repository.dart';

final class SubmitUserProfileUseCase extends BaseUseCase<UserProfileEntity, Result<void>> {
  SubmitUserProfileUseCase(
      this._userRepository,
      );

  final UserRepository _userRepository;

  @override
  Future<Result<void>> call(UserProfileEntity data) async {
    return _userRepository.submitUserProfileData(data);
  }
}