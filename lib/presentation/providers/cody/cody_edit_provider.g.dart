// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cody_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CodyEdit)
final codyEditProvider = CodyEditProvider._();

final class CodyEditProvider
    extends $NotifierProvider<CodyEdit, CodyEditState> {
  CodyEditProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'codyEditProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$codyEditHash();

  @$internal
  @override
  CodyEdit create() => CodyEdit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodyEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodyEditState>(value),
    );
  }
}

String _$codyEditHash() => r'4b05ceb6698e4f880cfbefb4c5b381b0f455aac2';

abstract class _$CodyEdit extends $Notifier<CodyEditState> {
  CodyEditState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CodyEditState, CodyEditState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<CodyEditState, CodyEditState>,
        CodyEditState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
