import 'package:ailook_flutter/core/index.dart';
import 'package:ailook_flutter/features/user/user.dart';

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