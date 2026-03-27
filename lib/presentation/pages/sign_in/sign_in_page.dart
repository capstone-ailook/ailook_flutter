import 'package:flutter/material.dart';
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
              const Spacer(),

              // Logo
              const Text(
                'AILOOK',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.black,
                ),
              ),

              const Spacer(),

              // Apple Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => handleAppleSignIn(context, ref),
                  icon: const Icon(Icons.apple, color: Colors.black),
                  label: const Text(
                    '애플로 로그인',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Google Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => handleGoogleSignIn(context, ref),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // A simple colored Google "G" representation
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: 'G',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '구글로 로그인',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Terms of Service Footer
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style:
                      TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                  children: [
                    TextSpan(text: '로그인함으로써 서비스의 '),
                    TextSpan(
                      text: '이용약관',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: ' 및\n'),
                    TextSpan(
                      text: '개인정보처리방침',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: '에 동의하는 것으로 간주합니다.'),
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
