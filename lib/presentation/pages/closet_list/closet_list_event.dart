import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin ClosetListEvent {
  Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
    EasyLoading.show(status: 'Signing out...');
    try {
      await ref.read(userAuthProvider.notifier).signOut();
      if (context.mounted) {
        const SignInRoute().go(context);
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  void navigateToProfile(BuildContext context) {
    // TODO: Profile screen navigation
  }

  void navigateToCody(BuildContext context) {
    // TODO: Cody screen navigation
  }
}
