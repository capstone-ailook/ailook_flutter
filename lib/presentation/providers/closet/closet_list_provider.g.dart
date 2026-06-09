// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closet_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClosetList)
final closetListProvider = ClosetListProvider._();

final class ClosetListProvider
    extends $AsyncNotifierProvider<ClosetList, ClosetListState> {
  ClosetListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'closetListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$closetListHash();

  @$internal
  @override
  ClosetList create() => ClosetList();
}

String _$closetListHash() => r'cf1f209c03fa57a3903f662f383da2569e797030';

abstract class _$ClosetList extends $AsyncNotifier<ClosetListState> {
  FutureOr<ClosetListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ClosetListState>, ClosetListState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ClosetListState>, ClosetListState>,
        AsyncValue<ClosetListState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
