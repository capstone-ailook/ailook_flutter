import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:techtalk/app/environment/firebase/firebase_options.dart'
// as prod_firebase;
// import 'package:techtalk/app/environment/firebase/firebase_options_dev.dart'
// as dev_firebase;

enum Environment {
  dev(type: "DEV"),
  prod(type: "PROD");

  final String type;

  const Environment({
    required this.type,
  });

  String get dotFileName => switch (this) {
        dev => /*'.dev.env'*/ '.env',
        prod => '.env',
      };

  // FirebaseOptions get firebaseOption => switch (this) {
  //   prod => prod_firebase.DefaultFirebaseOptions.currentPlatform,
  //   dev => dev_firebase.DefaultFirebaseOptions.currentPlatform,
  // };

  String get apiUrl => switch (this) {
        dev => dotenv.env['BASE_URL_DEV']!,
        prod => dotenv.env['BASE_URL_PROD']!,
      };
}
