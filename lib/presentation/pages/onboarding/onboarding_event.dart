import 'package:ailook_flutter/features/user/user.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:ailook_flutter/app/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin class OnboardingEvent {
  Future<void> submitProfile({
    required BuildContext context,
    required WidgetRef ref,
    required String? gender,
    required String? height,
    required String? weight,
    required String? age,
    required String? nickname,
  }) async {
    // 입력값 검증
    if (gender == null || gender.isEmpty) {
      _showSnack(context, '성별을 선택해 주세요.');
      return;
    }
    if (height == null || height.isEmpty) {
      _showSnack(context, '키를 입력해 주세요.');
      return;
    }
    if (weight == null || weight.isEmpty) {
      _showSnack(context, '몸무게를 입력해 주세요.');
      return;
    }
    if (age == null || age.isEmpty) {
      _showSnack(context, '연령대를 선택해 주세요.');
      return;
    }
    if (nickname == null || nickname.isEmpty) {
      _showSnack(context, '닉네임을 입력해 주세요.');
      return;
    }

    final heightVal = double.tryParse(height);
    final weightVal = double.tryParse(weight);
    if (heightVal == null) {
      _showSnack(context, '키를 올바른 숫자로 입력해 주세요.');
      return;
    }
    if (weightVal == null) {
      _showSnack(context, '몸무게를 올바른 숫자로 입력해 주세요.');
      return;
    }

    EasyLoading.show();
    try {
      final entity = UserProfileEntity(
        gender: gender,
        height: heightVal,
        weight: weightVal,
        age: age,
        nickname: nickname,
      );

      final messenger = ScaffoldMessenger.of(context);
      final result = await submitUserProfileUseCase(entity);

      EasyLoading.dismiss();
      result.fold(
        onSuccess: (_) {
          // 메인 화면으로 이동
          const MainRoute().go(context);
        },
        onFailure: (error) {
          messenger.showSnackBar(
            SnackBar(content: Text('프로필 저장에 실패했습니다: $error')),
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      if (context.mounted) {
        _showSnack(context, '오류가 발생했습니다: $e');
      }
    }
  }

  /// 온보딩 과정에서 로그아웃하고 로그인 화면으로 돌아간다.
  Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(userAuthProvider.notifier).signOut();
    if (context.mounted) {
      const SignInRoute().go(context);
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
