import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ailook_flutter/core/index.dart';
import 'package:ailook_flutter/features/auth/auth.dart';

final class SignInOAuthUseCase
    extends BaseUseCase<UserAccountProvider, Result<UserCredential>> {
  SignInOAuthUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  FutureOr<Result<UserCredential>> call(UserAccountProvider request) async =>
      _authRepository.signInOAuth(request);
}