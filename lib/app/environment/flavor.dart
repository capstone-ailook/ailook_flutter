import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:ailook_flutter/app/environment/environment.enum.dart';
import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Flavor {
  Flavor._();

  static final Flavor _instance = Flavor._();
  static late Environment _env;
  static late String _api;

  static Flavor get instance => _instance;

  static Environment get env => _env;

  static String get apiUrl => _api;

  static void initialize(Environment type) {
    _env = type;
  }

  /// [env]에 따라 어플리케이션 초기 설정을 진행한다.
  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();

    final rootIsolateToken = RootIsolateToken.instance;
    if (rootIsolateToken != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    }

    // 환경 파일 로드
    await dotenv.load(
      fileName: env.dotFileName,
    );

    _api = env.apiUrl;

    final option = env.firebaseOption;

    /// FireBase 초기화
    try {
      await Firebase.initializeApp(
        options: option,
      );
    } catch (e) {
      debugPrint('Firebase initialization warning: $e');
    }

    /// 앱 DI 실행
    await AppBinder.init();
  }
}