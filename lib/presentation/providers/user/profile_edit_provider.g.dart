// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileEdit)
final profileEditProvider = ProfileEditProvider._();

final class ProfileEditProvider
    extends $NotifierProvider<ProfileEdit, ProfileEditState> {
  ProfileEditProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'profileEditProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$profileEditHash();

  @$internal
  @override
  ProfileEdit create() => ProfileEdit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileEditState>(value),
    );
  }
}

String _$profileEditHash() => r'a6f9e915cd8dd1369fd1b35b394baf7b88b51503';

abstract class _$ProfileEdit extends $Notifier<ProfileEditState> {
  ProfileEditState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProfileEditState, ProfileEditState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProfileEditState, ProfileEditState>,
        ProfileEditState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
