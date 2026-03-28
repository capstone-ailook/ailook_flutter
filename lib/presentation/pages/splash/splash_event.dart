import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin class SplashEvent {
  /// 유저 인증정보와 유저 정보를 토대로 라우팅을 분기한다.
  ///
  /// 인증 정보가 없으면 [SignInPage], 유저 정보가 없으면 [OnboardingPage], 둘 다 있는 유저라면 [MainPage]로 라우팅한다.
  Future<void> routeByUserAuthAndData(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(userAuthProvider);

    if (auth == null) {
      const SignInRoute().go(context);
      return;
    }

    await ref.read(userInfoProvider.future).then(
      (userData) {
        if (userData == null || !userData.exists) {
          const OnboardingRoute().go(context);
        } else {
          CodyListRoute().go(context);
        }
      },
    );
  }
}

