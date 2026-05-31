// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closet_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClosetEdit)
final closetEditProvider = ClosetEditProvider._();

final class ClosetEditProvider
    extends $NotifierProvider<ClosetEdit, ClosetEditState> {
  ClosetEditProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'closetEditProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$closetEditHash();

  @$internal
  @override
  ClosetEdit create() => ClosetEdit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClosetEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClosetEditState>(value),
    );
  }
}

String _$closetEditHash() => r'8138bf5cef0596a8ae046e350b412b0278cf0725';

abstract class _$ClosetEdit extends $Notifier<ClosetEditState> {
  ClosetEditState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ClosetEditState, ClosetEditState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ClosetEditState, ClosetEditState>,
        ClosetEditState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
