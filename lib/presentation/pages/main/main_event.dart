import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:ailook_flutter/app/router/router.dart';

mixin MainEvent {
  Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(userAuthProvider.notifier).signOut();
    if (context.mounted) {
      const SignInRoute().go(context);
    }
  }
}
