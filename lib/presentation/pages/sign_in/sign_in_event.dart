import 'package:flutter/material.dart';
import 'package:ailook_flutter/features/auth/auth.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';
import 'package:ailook_flutter/app/router/router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin class SignInEvent {
  Future<void> handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    try {
      EasyLoading.show();
      await ref
          .read(userAuthProvider.notifier)
          .signInOAuth(UserAccountProvider.google);
      
      // 로그인 성공 시 라우팅 처리
      if (context.mounted) {
        await _handlePostSignInRouting(context, ref);
      }
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      EasyLoading.showError('로그인에 실패했습니다.\n다시 시도해 주세요.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> handleAppleSignIn(BuildContext context, WidgetRef ref) async {
    try {
      EasyLoading.show();
      await ref
          .read(userAuthProvider.notifier)
          .signInOAuth(UserAccountProvider.apple);
      
      // 로그인 성공 시 라우팅 처리
      if (context.mounted) {
        await _handlePostSignInRouting(context, ref);
      }
    } catch (e) {
      debugPrint('Apple Sign In Error: $e');
      EasyLoading.showError('로그인에 실패했습니다.\n다시 시도해 주세요.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// 로그인 성공 후 유저 프로필 존재 여부에 따라 라우팅을 수행한다.
  Future<void> _handlePostSignInRouting(BuildContext context, WidgetRef ref) async {
    try {
      // userInfoProvider를 새로고침하여 최신 프로필 정보를 가져온다.
      final profile = await ref.refresh(userInfoProvider.future);

      if (!context.mounted) return;

      if (profile == null || !profile.exists) {
        // 프로필이 없으면 온보딩 페이지로 이동
        const OnboardingRoute().go(context);
      } else {
        // 프로필이 있으면 메인 페이지로 이동
        const MainRoute().go(context);
      }
    } catch (e) {
      debugPrint('Post Sign In Routing Error: $e');
      EasyLoading.showError('프로필 정보를 확인하는 중 오류가 발생했습니다.\n다시 시도해 주세요.');
      
      // 오류 발생 시 세션 정리를 위해 로그아웃 처리를 고려할 수 있음
      // await ref.read(userAuthProvider.notifier).signOut();
    }
  }
}
