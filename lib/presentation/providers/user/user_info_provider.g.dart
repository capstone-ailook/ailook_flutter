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
    extends $AsyncNotifierProvider<UserInfo, UserProfileResponseEntity?> {
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

String _$userInfoHash() => r'18c6bcf4374c9b806f85e8aa21722e62277a0ebb';

abstract class _$UserInfo extends $AsyncNotifier<UserProfileResponseEntity?> {
  FutureOr<UserProfileResponseEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfileResponseEntity?>,
        UserProfileResponseEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserProfileResponseEntity?>,
            UserProfileResponseEntity?>,
        AsyncValue<UserProfileResponseEntity?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
