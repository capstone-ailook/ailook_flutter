// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $splashRoute,
      $signInRoute,
      $onboardingRoute,
      $mainShellRoute,
      $profileEditRoute,
      $closetEditRoute,
      $closetDetailRoute,
      $codyEditRoute,
      $codyDetailRoute,
      $itemSelectionRoute,
      $networkErrorRoute,
    ];

RouteBase get $splashRoute => GoRouteData.$route(
      path: '/splash',
      name: 'splash',
      factory: $SplashRoute._fromState,
    );

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  @override
  String get location => GoRouteData.$location(
        '/splash',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRoute => GoRouteData.$route(
      path: '/sign_in',
      name: 'sign_in',
      factory: $SignInRoute._fromState,
    );

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  @override
  String get location => GoRouteData.$location(
        '/sign_in',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
      path: '/onboarding',
      name: 'onboarding',
      factory: $OnboardingRoute._fromState,
    );

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location(
        '/onboarding',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
      factory: $MainShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/cody',
              name: 'cody',
              factory: $CodyListRoute._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/closet',
              name: 'closet',
              factory: $ClosetListRoute._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/chat',
              name: 'chat',
              factory: $ChatRoute._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/profile',
              name: 'profile',
              factory: $ProfileRoute._fromState,
            ),
          ],
        ),
      ],
    );

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

mixin $CodyListRoute on GoRouteData {
  static CodyListRoute _fromState(GoRouterState state) => CodyListRoute();

  @override
  String get location => GoRouteData.$location(
        '/cody',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ClosetListRoute on GoRouteData {
  static ClosetListRoute _fromState(GoRouterState state) => ClosetListRoute();

  @override
  String get location => GoRouteData.$location(
        '/closet',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) => ChatRoute();

  @override
  String get location => GoRouteData.$location(
        '/chat',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute();

  @override
  String get location => GoRouteData.$location(
        '/profile',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileEditRoute => GoRouteData.$route(
      path: '/profile/edit',
      name: 'profile_edit',
      factory: $ProfileEditRoute._fromState,
    );

mixin $ProfileEditRoute on GoRouteData {
  static ProfileEditRoute _fromState(GoRouterState state) =>
      const ProfileEditRoute();

  @override
  String get location => GoRouteData.$location(
        '/profile/edit',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $closetEditRoute => GoRouteData.$route(
      path: '/closet/edit',
      name: 'closet_edit',
      factory: $ClosetEditRoute._fromState,
    );

mixin $ClosetEditRoute on GoRouteData {
  static ClosetEditRoute _fromState(GoRouterState state) => ClosetEditRoute(
        id: _$convertMapValue('id', state.uri.queryParameters, int.tryParse),
      );

  ClosetEditRoute get _self => this as ClosetEditRoute;

  @override
  String get location => GoRouteData.$location(
        '/closet/edit',
        queryParams: {
          if (_self.id != null) 'id': _self.id!.toString(),
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $closetDetailRoute => GoRouteData.$route(
      path: '/closet/detail/:id',
      name: 'closet_detail',
      factory: $ClosetDetailRoute._fromState,
    );

mixin $ClosetDetailRoute on GoRouteData {
  static ClosetDetailRoute _fromState(GoRouterState state) => ClosetDetailRoute(
        id: int.parse(state.pathParameters['id']!),
      );

  ClosetDetailRoute get _self => this as ClosetDetailRoute;

  @override
  String get location => GoRouteData.$location(
        '/closet/detail/${Uri.encodeComponent(_self.id.toString())}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $codyEditRoute => GoRouteData.$route(
      path: '/cody/edit',
      name: 'cody_edit',
      factory: $CodyEditRoute._fromState,
    );

mixin $CodyEditRoute on GoRouteData {
  static CodyEditRoute _fromState(GoRouterState state) => CodyEditRoute(
        id: _$convertMapValue('id', state.uri.queryParameters, int.tryParse),
      );

  CodyEditRoute get _self => this as CodyEditRoute;

  @override
  String get location => GoRouteData.$location(
        '/cody/edit',
        queryParams: {
          if (_self.id != null) 'id': _self.id!.toString(),
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $codyDetailRoute => GoRouteData.$route(
      path: '/cody/detail/:id',
      name: 'cody_detail',
      factory: $CodyDetailRoute._fromState,
    );

mixin $CodyDetailRoute on GoRouteData {
  static CodyDetailRoute _fromState(GoRouterState state) => CodyDetailRoute(
        id: int.parse(state.pathParameters['id']!),
      );

  CodyDetailRoute get _self => this as CodyDetailRoute;

  @override
  String get location => GoRouteData.$location(
        '/cody/detail/${Uri.encodeComponent(_self.id.toString())}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $itemSelectionRoute => GoRouteData.$route(
      path: '/closet/select/:category',
      name: 'item_selection',
      factory: $ItemSelectionRoute._fromState,
    );

mixin $ItemSelectionRoute on GoRouteData {
  static ItemSelectionRoute _fromState(GoRouterState state) =>
      ItemSelectionRoute(
        category: state.pathParameters['category']!,
      );

  ItemSelectionRoute get _self => this as ItemSelectionRoute;

  @override
  String get location => GoRouteData.$location(
        '/closet/select/${Uri.encodeComponent(_self.category)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $networkErrorRoute => GoRouteData.$route(
      path: '/error/network',
      name: 'network_error',
      factory: $NetworkErrorRoute._fromState,
    );

mixin $NetworkErrorRoute on GoRouteData {
  static NetworkErrorRoute _fromState(GoRouterState state) =>
      const NetworkErrorRoute();

  @override
  String get location => GoRouteData.$location(
        '/error/network',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
