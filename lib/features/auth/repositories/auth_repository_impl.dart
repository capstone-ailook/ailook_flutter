import 'package:firebase_auth/firebase_auth.dart';
import 'package:ailook_flutter/core/index.dart';
import 'package:ailook_flutter/features/auth/auth.dart';
import 'package:ailook_flutter/features/cody/cody.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl([
    this._authRemoteDataSource,
    this._codyRepository,
  ]);

  final AuthRemoteDataSource? _authRemoteDataSource;
  final CodyRepository? _codyRepository;

  @override
  Future<Result<UserCredential>> signInOAuth(
      UserAccountProvider provider,
      ) async {
    try {
      final userCredential = await switch (provider) {
        UserAccountProvider.google => _authRemoteDataSource!.signInWithGoogle(),
        UserAccountProvider.apple => _authRemoteDataSource!.signInWithApple(),
      };

      return Result.success(userCredential);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> signOutOauth() async {
    try {
      return Result.success(
        await _authRemoteDataSource!.signOut(),
      );
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      // 1. Delete user data from the backend first
      await _codyRepository!.deleteUserAccount();

      // 2. Then delete the Firebase account
      return Result.success(
        await _authRemoteDataSource!.deleteAccount(),
      );
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
