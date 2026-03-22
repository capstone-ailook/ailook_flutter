import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ailook_flutter/features/user/user.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';

part 'user_info_provider.g.dart';

@Riverpod(keepAlive: true)
class UserInfo extends _$UserInfo {
  @override
  FutureOr<UserProfileEntity?> build() async {
    final userAuth = ref.watch(userAuthProvider);

    if (userAuth == null) {
      throw Exception('유저 인증 정보가 존재하지 않습니다(로그아웃 이후 다시 로그인 시도할 경우 정상적인 시도입니다)');
    }

    final userData = await getUserProfileUseCase();

    return userData.fold(
      onSuccess: (info) {
        AppUserInfo().initialize(info.profile as UserProfileEntity?);
        return info.profile as UserProfileEntity;
      },
      onFailure: (e) {
        return null;
      },
    );
  }

  Future<void> createData(UserProfileEntity data) async {
    final createUserData = await submitUserProfileUseCase(data);
    await createUserData.fold(
      onSuccess: (value) async {
        ref.invalidateSelf();

        await future;
      },
      onFailure: (e) {

        throw e;
      },
    );
  }

  void edit(UserProfileEntity user) {
    state = AsyncData(user);
  }
}

final class AppUserInfo {
  static final AppUserInfo _instance = AppUserInfo._internal();

  factory AppUserInfo() => _instance;

  AppUserInfo._internal();

  UserProfileEntity? instance;

  void initialize(UserProfileEntity? info) {
    instance = info;
  }
}
