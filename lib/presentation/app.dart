import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/app/style/app_color.dart';
import 'package:ailook_flutter/app/style/app_theme.dart';
import 'package:ailook_flutter/core/services/app_size.dart';
import 'package:ailook_flutter/presentation/widgets/common/layout/mobie_layout_constraint_layout.dart';

base class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    log('''
{ 
  "provider": "${context.provider.name ?? context.provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    log('${context.provider.name ?? context.provider.runtimeType} dispose');
  }
}

final globalContainer = ProviderContainer(
  observers: [
    ProviderLogger(),
    MyObserver(),
  ],
);

Future<void> runFlavoredApp() async {
  await Flavor.instance.setup();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);

  return runApp(
    UncontrolledProviderScope(
      container: globalContainer,
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  App({super.key}) {
    _initLoadingIndicator();
  }

  static void _initLoadingIndicator() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      // 로딩 인디케이터 배경 색상. 그림자는 사용하지 않아도 될 듯
      ..backgroundColor = Colors.transparent
      ..boxShadow = []
      ..indicatorColor = Colors.white
      // 로딩 인디케이터 호출 시 오베리어 컬러
      ..maskType = EasyLoadingMaskType.black
      ..maskColor = Colors.transparent
      ..textColor = Colors.white
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ko'), Locale('en')],
          locale: const Locale('ko'),
          routerConfig: AppRouter.appRouter(ref),
          debugShowCheckedModeBanner: false,
          title: 'ailook',
          themeMode: ThemeMode.light,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          builder: EasyLoading.init(
            builder: (context, child) {
              AppColor.init(context);
              AppSize.init(context);
              return FToastBuilder()(
                context,
                MLayoutConstraintLayout(context, child),
              );
            },
          ),
        );
      },
    );
  }
}

base class MyObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    print('Provider ${context.provider} was initialized with $value');
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    print('Provider ${context.provider} was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    print(
        'Provider ${context.provider} updated from $previousValue to $newValue');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    print('Provider ${context.provider} threw $error at $stackTrace');
  }
}
