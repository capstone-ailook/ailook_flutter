import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ailook_flutter/presentation/app.dart';
import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/app/environment/environment.enum.dart';

Future<void> main() async {
  Flavor.initialize(Environment.prod);

  return runFlavoredApp();
}
