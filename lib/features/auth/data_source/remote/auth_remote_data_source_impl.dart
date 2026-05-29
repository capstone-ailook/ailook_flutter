import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/features/auth/auth.dart';

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // google_sign_in 7.0.0+ 버전에서는 Singleton 패턴을 사용하며, 
  // 반드시 사용 전에 initialize()를 호출해야 합니다.
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  Future<UserCredential> signInWithApple() async {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    final rawNonce =
    List.generate(32, (_) => charset[random.nextInt(charset.length)])
        .join();

    final bytes = utf8.encode(rawNonce);
    final digest = sha256.convert(bytes);
    final nonce = digest.toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      accessToken: credential.authorizationCode,
      idToken: credential.identityToken,
      rawNonce: rawNonce,
    );

    return _firebaseAuth.signInWithCredential(oauthCredential);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Android에서 clientConfigurationError를 방지하기 위해 initialize를 먼저 호출하고 기다립니다.
      // serverClientId는 google-services.json의 client_type 3(Web client)의 client_id입니다.
      await _googleSignIn.initialize(
        serverClientId: Flavor.googleServerClientId,
      );

      // 7.2.0 버전에서는 signIn() 대신 authenticate()를 사용합니다.
      final googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      String message = error.toString();
      // [16] Account reauth failed 에러에 대한 좀 더 구체적인 안내를 추가합니다.
      if (message.contains('[16]') || message.contains('Account reauth failed')) {
        throw Exception(
          'Google Sign-In failed [16]: SHA-1 지문이 Firebase 콘솔에 등록되지 않았거나 google-services.json이 최신이 아닙니다.'
        );
      }
      throw Exception('google sign in failed: $error');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _googleSignIn.signOut();
      await user.delete();
    }
  }
}