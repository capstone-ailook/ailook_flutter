import 'package:ailook_flutter/presentation/pages/splash/splash_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/core/index.dart';
import 'package:ailook_flutter/presentation/widgets/base/index.dart';


class SplashPage extends BasePage with SplashEvent {
  const SplashPage({super.key});

  @override
  void onInit(BuildContext context, WidgetRef ref) {
    Future.microtask(() => routeByUserAuthAndData(context, ref));
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Center(
      child: SvgPicture.asset(
        Assets.defaultLogo,
      ),
    );
  }
}