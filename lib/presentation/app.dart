import 'package:ailook_flutter/presentation/providers/user/user_auth_provider.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';
import 'package:ailook_flutter/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AILookApp extends StatelessWidget {
  const AILookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Closet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    if (user == null) {
      return const LoginScreen();
    }

    return const ProfileScreen();
  }
}

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.checkroom, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'AI Closet',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to sync your wardrobe across devices',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const Spacer(),
              _SocialLoginButton(
                text: 'Continue with Google',
                textColor: Colors.black87,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                iconWidget: _buildGoogleGIcon(),
                onPressed: () => ref
                    .read(userAuthProvider.notifier)
                    .signInOAuth(UserAccountProvider.google),
              ),
              const SizedBox(height: 16),
              _SocialLoginButton(
                text: 'Continue with Apple',
                textColor: Colors.white,
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                iconWidget: const Icon(Icons.apple, size: 26, color: Colors.white),
                onPressed: () => ref
                    .read(userAuthProvider.notifier)
                    .signInOAuth(UserAccountProvider.apple),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleGIcon() {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue, // Just a placeholder Google flavor
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Widget iconWidget;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
      ),
      icon: iconWidget,
      label: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => ref.read(userAuthProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: userInfo.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found. Please create one.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nickname: ${profile.nickname}', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Gender: ${profile.gender}'),
                Text('Age: ${profile.age}'),
                Text('Height: ${profile.height} cm'),
                Text('Weight: ${profile.weight} kg'),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
