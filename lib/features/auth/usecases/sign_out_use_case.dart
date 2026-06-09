import 'dart:async';

import 'package:ailook_flutter/core/modules/base_use_case/base_no_param_use_case.dart';
import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/auth/auth.dart';

final class SignOutUseCase extends BaseNoParamUseCase<Result<void>> {
  SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  FutureOr<Result<void>> call() async => _authRepository.signOutOauth();
}
