// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 사용자 권한 프로바이더

@ProviderFor(UserAuth)
final userAuthProvider = UserAuthProvider._();

/// 앱 사용자 권한 프로바이더
final class UserAuthProvider extends $NotifierProvider<UserAuth, User?> {
  /// 앱 사용자 권한 프로바이더
  UserAuthProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userAuthProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userAuthHash();

  @$internal
  @override
  UserAuth create() => UserAuth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$userAuthHash() => r'8e777e187e53e99eb0cc1fef30a4b106d1858008';

/// 앱 사용자 권한 프로바이더

abstract class _$UserAuth extends $Notifier<User?> {
  User? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<User?, User?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<User?, User?>, User?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
