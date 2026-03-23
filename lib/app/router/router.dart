import 'package:ailook_flutter/presentation/pages/splash/splash_page.dart';
import 'package:ailook_flutter/presentation/pages/sign_in/sign_in_page.dart';
import 'package:ailook_flutter/presentation/pages/onboarding/onboarding_page.dart';
import 'package:ailook_flutter/presentation/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'router.g.dart';

///
/// 부모 라우트가 [$extra]로 argument를 전달하고 있고
/// 자식 라우트도 동일하게 [$extra]로 argument을 전달하는 상황일 때
/// 부모 [$extra]값이 자식[$extra]를 덮어쓰는 고질적인 이슈가 존재.
///
/// 해당 이슈: https://github.com/flutter/flutter/issues/106121
///
/// 1년 반이 더 지난 이슈지만 Flutter tream에서 해결의지 크게 없어보임.
/// 이를 우회회할 수 있는 방법은 라우트를 부모와 자식으로 구분하지 않는 것인데,
/// 이렇게 되면 route path경로를 유동적으로 설정하지 못한다는 문제점이 발생.
/// 이러한 이유로 [ChatListRoute] 라우트 모듈의 경우 [$extra]를 통해 인자를 전달 받지 않고
/// Route 모듈의 전역변수 값을 외부에서 업데이트하여 필요한 섹션에 인자를 전달하는 중
///
///
///

final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static GoRouter appRouter(WidgetRef ref) => GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashRoute.path,
    routes: $appRoutes,
  );
}

///
/// splash
///
@TypedGoRoute<SplashRoute>(
  path: SplashRoute.path,
  name: SplashRoute.name,
)
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  static const String path = '/splash';
  static const String name = 'splash';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation),
          child: child,
        );
      },
      child: const SplashPage(),
    );
  }
}

///
/// sign_in
///
@TypedGoRoute<SignInRoute>(
  path: SignInRoute.path,
  name: SignInRoute.name,
)
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();

  static const String path = '/sign_in';
  static const String name = 'sign_in';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const CustomTransitionPage(
      transitionsBuilder: fadeTransition,
      child: SignInPage(),
    );
  }
}

Widget fadeTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

///
/// onboarding
///
@TypedGoRoute<OnboardingRoute>(
  path: OnboardingRoute.path,
  name: OnboardingRoute.name,
)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  static const String path = '/onboarding';
  static const String name = 'onboarding';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: OnboardingPage(),
    );
  }
}

///
/// main
///
@TypedGoRoute<MainRoute>(
  path: MainRoute.path,
  name: MainRoute.name,
)
class MainRoute extends GoRouteData with $MainRoute {
  const MainRoute();

  static const String path = '/main';
  static const String name = 'main';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: MainPage(),
    );
  }
}