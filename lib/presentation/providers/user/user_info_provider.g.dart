// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserInfo)
final userInfoProvider = UserInfoProvider._();

final class UserInfoProvider
    extends $AsyncNotifierProvider<UserInfo, UserProfileEntity?> {
  UserInfoProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userInfoProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userInfoHash();

  @$internal
  @override
  UserInfo create() => UserInfo();
}

String _$userInfoHash() => r'97eeb49f192f9953bd805defb17738fa1cce9758';

abstract class _$UserInfo extends $AsyncNotifier<UserProfileEntity?> {
  FutureOr<UserProfileEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<UserProfileEntity?>, UserProfileEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserProfileEntity?>, UserProfileEntity?>,
        AsyncValue<UserProfileEntity?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
