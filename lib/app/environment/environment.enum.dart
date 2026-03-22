import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ailook_flutter/app/environment/firebase/firebase_options.dart'
    as prod_firebase;
import 'package:ailook_flutter/app/environment/firebase/firebase_options_dev.dart'
    as dev_firebase;

enum Environment {
  dev(type: "DEV"),
  prod(type: "PROD");

  final String type;

  const Environment({
    required this.type,
  });

  String get dotFileName => switch (this) {
        dev => '.env',
        prod => '.env',
      };

  FirebaseOptions get firebaseOption => switch (this) {
        prod => prod_firebase.DefaultFirebaseOptions.currentPlatform,
        dev => dev_firebase.DefaultFirebaseOptions.currentPlatform,
      };

  String get apiUrl {
    if (this == Environment.prod) {
      return dotenv.env['BASE_URL_PROD']!;
    }
    // dev environment
    final devUrl = dotenv.env['BASE_URL_DEV']!;
    if (defaultTargetPlatform == TargetPlatform.android &&
        devUrl.contains('127.0.0.1')) {
      return devUrl.replaceAll('127.0.0.1', '10.0.2.2');
    }
    return devUrl;
  }
}
