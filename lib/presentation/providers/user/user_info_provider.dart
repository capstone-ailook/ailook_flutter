import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ailook_flutter/features/user/user.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';

part 'user_info_provider.g.dart';

@Riverpod(keepAlive: true)
class UserInfo extends _$UserInfo {
  @override
  FutureOr<UserProfileResponseEntity?> build() async {
    final userAuth = ref.watch(userAuthProvider);

    if (userAuth == null) {
      return null;
    }

    // Use GetIt locator (via user.dart final variable)
    final result = await getUserProfileUseCase.call();

    return result.fold(
      onSuccess: (response) => response,
      onFailure: (error) {
        debugPrint('Profile Fetch Error: $error');
        throw error;
      },
    );
  }

  Future<void> createData(UserProfileEntity data) async {
    // Use GetIt locator (via user.dart final variable)
    final result = await submitUserProfileUseCase.call(data);

    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
      },
      onFailure: (error) {
        throw error;
      },
    );
    await future;
  }

  void edit(UserProfileEntity user) {
    state = AsyncData(UserProfileResponseEntity(exists: true, profile: user));
  }
}
