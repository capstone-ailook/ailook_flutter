import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ailook_flutter/features/auth/auth.dart';
import 'package:ailook_flutter/presentation/providers/chat/chat_provider.dart';
import 'package:ailook_flutter/presentation/providers/closet/closet_list_provider.dart';
import 'package:ailook_flutter/presentation/providers/cody/cody_list_provider.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';

part 'user_auth_provider.g.dart';

/// 앱 사용자 권한 프로바이더
@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  @override
  User? build() {
    return FirebaseAuth.instance.currentUser;
  }

  /// OAuth 인증을 통해 로그인한다.
  Future<void> signInOAuth(UserAccountProvider provider) async {
    final result = await signInOAuthUseCase(provider);
    result.fold(
      onSuccess: (value) {
        state = value.user;
      },
      onFailure: (e) {
        print('에임 $e');
        throw e;
      },
    );
  }

  void _invalidateUserDataProviders() {
    ref.invalidate(chatSessionListProvider);
    ref.invalidate(codyListProvider);
    ref.invalidate(closetListProvider);
    ref.invalidate(userInfoProvider);
  }

  /// 로그아웃을 시도한다.
  Future<void> signOut() async {
    final result = await signOutUseCase();
    result.fold(
      onSuccess: (value) {
        _invalidateUserDataProviders();
        ref.invalidateSelf();
      },
      onFailure: (e) {
        print('$e');
      },
    );
  }

  /// 회원탈퇴를 시도한다.
  Future<void> deleteAccount() async {
    final result = await deleteAccountUseCase();
    result.fold(
      onSuccess: (value) {
        _invalidateUserDataProviders();
        ref.invalidateSelf();
      },
      onFailure: (e) {
        print('$e');
      },
    );
  }
}

