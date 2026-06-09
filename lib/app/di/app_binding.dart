import 'package:ailook_flutter/app/di/modules/auth_di.dart';
import 'package:ailook_flutter/app/di/modules/user_di.dart';
import 'package:ailook_flutter/app/di/modules/cody_di.dart';
import 'package:ailook_flutter/app/di/modules/media_di.dart';
import 'package:ailook_flutter/app/di/feature_di_interface.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

// 안전하게 등록된 인스턴스를 해제하는 메소드
void safeUnregister<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

// 안전하게 Factory 싱글톤 등록하는 메소드
void safeRegisterSingleton<T extends Object>(FactoryFunc<T> factoryFunc) {
  if (!locator.isRegistered<T>()) {
    locator.registerLazySingleton<T>(factoryFunc);
  }
}

final class AppBinder {
  AppBinder._();

  /// 'Splash' 단계에서 우선적으로 Binding 해야되는 모듈들은
  /// 아래 메소드에서 처리합
  static void _initTopPriority() {
    // AppRate.init();
  }

  static Future<void> init() async {
    _initTopPriority();

    final List<FeatureDependencyInjection> diModules = [
      AuthDependencyInjection(),
      UserDependencyInjection(),
      CodyDependencyInjection(),
      MediaDependencyInjection(),
    ];

    for (final di in diModules) {
      di.init();
    }
  }
}
