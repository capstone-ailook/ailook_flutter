import 'package:ailook_flutter/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/presentation/widgets/base/base_page.dart';
import 'package:ailook_flutter/presentation/pages/sign_in/sign_in_event.dart';

class SignInPage extends BasePage with SignInEvent {
  const SignInPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Brand Logo
              SvgPicture.asset(
                Assets.defaultLogo,
                width: 180,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your AI-Powered Personal Stylist',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  letterSpacing: -0.2,
                ),
              ),

              const Spacer(flex: 3),

              // Social Login Section
              _SocialLoginButton(
                onPressed: () => handleAppleSignIn(context, ref),
                icon: const Icon(Icons.apple, color: Colors.black, size: 24),
                label: 'Apple로 시작하기',
              ),
              const SizedBox(height: 12),
              _SocialLoginButton(
                onPressed: () => handleGoogleSignIn(context, ref),
                icon: SvgPicture.asset(
                  Assets.googleLogo,
                  width: 20,
                  height: 20,
                ),
                label: 'Google로 시작하기',
              ),

              const SizedBox(height: 48),

              // Terms of Service Footer
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    height: 1.6,
                    fontFamily: 'pretendard',
                  ),
                  children: [
                    const TextSpan(text: 'By signing in, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: '\nand '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  const _SocialLoginButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[200]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: icon,
              ),
            ),
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
