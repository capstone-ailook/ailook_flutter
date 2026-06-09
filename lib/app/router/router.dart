import 'package:ailook_flutter/presentation/pages/splash/splash_page.dart';
import 'package:ailook_flutter/presentation/pages/sign_in/sign_in_page.dart';
import 'package:ailook_flutter/presentation/pages/onboarding/onboarding_page.dart';
import 'package:ailook_flutter/presentation/pages/closet_list/closet_list_page.dart';
import 'package:ailook_flutter/presentation/pages/main/main_page.dart';
import 'package:ailook_flutter/presentation/pages/cody_list/cody_list_page.dart';
import 'package:ailook_flutter/presentation/pages/chat/chat_page.dart';
import 'package:ailook_flutter/presentation/pages/profile/profile_page.dart';
import 'package:ailook_flutter/presentation/pages/closet_edit/closet_edit_page.dart';
import 'package:ailook_flutter/presentation/pages/cody_edit/cody_edit_page.dart';
import 'package:ailook_flutter/presentation/pages/cody_edit/item_selection_page.dart';
import 'package:ailook_flutter/presentation/pages/profile/profile_edit_page.dart';
import 'package:ailook_flutter/presentation/pages/closet_detail/closet_detail_page.dart';
import 'package:ailook_flutter/presentation/pages/cody_detail/cody_detail_page.dart';
import 'package:ailook_flutter/presentation/pages/error/network_error_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'router.g.dart';

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
        return FadeTransition(opacity: animation, child: child);
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
    return CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      child: const SignInPage(),
    );
  }
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
  Page<void> buildPage(BuildContext context, GoRouterState state) => const MaterialPage(child: OnboardingPage());
}

///
/// Shell Route for Main Tabs
///
@TypedStatefulShellRoute<MainShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    const TypedStatefulShellBranch<CodyListBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CodyListRoute>(path: CodyListRoute.path, name: CodyListRoute.name),
      ],
    ),
    const TypedStatefulShellBranch<ClosetListBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ClosetListRoute>(path: ClosetListRoute.path, name: ClosetListRoute.name),
      ],
    ),
    const TypedStatefulShellBranch<ChatBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ChatRoute>(path: ChatRoute.path, name: ChatRoute.name),
      ],
    ),
    const TypedStatefulShellBranch<ProfileBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(path: ProfileRoute.path, name: ProfileRoute.name),
      ],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return MainPage(navigationShell: navigationShell);
  }
}

// Branches
class CodyListBranch extends StatefulShellBranchData { const CodyListBranch(); }
class ClosetListBranch extends StatefulShellBranchData { const ClosetListBranch(); }
class ChatBranch extends StatefulShellBranchData { const ChatBranch(); }
class ProfileBranch extends StatefulShellBranchData { const ProfileBranch(); }

// Routes in Shell
class CodyListRoute extends GoRouteData with $CodyListRoute {
  static const String path = '/cody';
  static const String name = 'cody';
  @override
  Widget build(BuildContext context, GoRouterState state) => const CodyListPage();
}
class ClosetListRoute extends GoRouteData with $ClosetListRoute {
  static const String path = '/closet';
  static const String name = 'closet';
  @override
  Widget build(BuildContext context, GoRouterState state) => const ClosetListPage();
}
class ChatRoute extends GoRouteData with $ChatRoute {
  static const String path = '/chat';
  static const String name = 'chat';
  @override
  Widget build(BuildContext context, GoRouterState state) => const ChatPage();
}
class ProfileRoute extends GoRouteData with $ProfileRoute {
  static const String path = '/profile';
  static const String name = 'profile';
  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfilePage();
}

///
/// Profile Edit
///
@TypedGoRoute<ProfileEditRoute>(
  path: ProfileEditRoute.path,
  name: ProfileEditRoute.name,
)
class ProfileEditRoute extends GoRouteData with $ProfileEditRoute {
  const ProfileEditRoute();
  static const String path = '/profile/edit';
  static const String name = 'profile_edit';
  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileEditPage();
}

///
/// Closet Edit
///
@TypedGoRoute<ClosetEditRoute>(
  path: ClosetEditRoute.path,
  name: ClosetEditRoute.name,
)
class ClosetEditRoute extends GoRouteData with $ClosetEditRoute {
  final int? id;
  const ClosetEditRoute({this.id});
  static const String path = '/closet/edit';
  static const String name = 'closet_edit';
  @override
  Widget build(BuildContext context, GoRouterState state) => ClosetEditPage(id: id);
}

///
/// Closet Detail
///
@TypedGoRoute<ClosetDetailRoute>(
  path: ClosetDetailRoute.path,
  name: ClosetDetailRoute.name,
)
class ClosetDetailRoute extends GoRouteData with $ClosetDetailRoute {
  final int id;
  const ClosetDetailRoute({required this.id});
  static const String path = '/closet/detail/:id';
  static const String name = 'closet_detail';
  @override
  Widget build(BuildContext context, GoRouterState state) => ClosetDetailPage(id: id);
}

///
/// Cody Edit
///
@TypedGoRoute<CodyEditRoute>(
  path: CodyEditRoute.path,
  name: CodyEditRoute.name,
)
class CodyEditRoute extends GoRouteData with $CodyEditRoute {
  final int? id;
  const CodyEditRoute({this.id});
  static const String path = '/cody/edit';
  static const String name = 'cody_edit';
  @override
  Widget build(BuildContext context, GoRouterState state) => CodyEditPage(id: id);
}

///
/// Cody Detail
///
@TypedGoRoute<CodyDetailRoute>(
  path: CodyDetailRoute.path,
  name: CodyDetailRoute.name,
)
class CodyDetailRoute extends GoRouteData with $CodyDetailRoute {
  final int id;
  const CodyDetailRoute({required this.id});
  static const String path = '/cody/detail/:id';
  static const String name = 'cody_detail';
  @override
  Widget build(BuildContext context, GoRouterState state) => CodyDetailPage(id: id);
}

///
/// Item Selection (for Cody creation)
///
@TypedGoRoute<ItemSelectionRoute>(
  path: ItemSelectionRoute.path,
  name: ItemSelectionRoute.name,
)
class ItemSelectionRoute extends GoRouteData with $ItemSelectionRoute {
  final String category;
  const ItemSelectionRoute({required this.category});
  static const String path = '/closet/select/:category';
  static const String name = 'item_selection';
  @override
  Widget build(BuildContext context, GoRouterState state) => ItemSelectionPage(category: category);
}
///
/// Network Error
///
@TypedGoRoute<NetworkErrorRoute>(
  path: NetworkErrorRoute.path,
  name: NetworkErrorRoute.name,
)
class NetworkErrorRoute extends GoRouteData with $NetworkErrorRoute {
  const NetworkErrorRoute();
  static const String path = '/error/network';
  static const String name = 'network_error';
  @override
  Widget build(BuildContext context, GoRouterState state) => const NetworkErrorPage();
}
