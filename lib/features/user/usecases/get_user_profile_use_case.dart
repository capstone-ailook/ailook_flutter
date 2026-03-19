import 'package:ailook_flutter/core/index.dart';
import 'package:ailook_flutter/features/user/user.dart';

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
