// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cody_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CodyList)
final codyListProvider = CodyListProvider._();

final class CodyListProvider
    extends $AsyncNotifierProvider<CodyList, CodyListState> {
  CodyListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'codyListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$codyListHash();

  @$internal
  @override
  CodyList create() => CodyList();
}

String _$codyListHash() => r'051e987e1a9ca4dbfb3323f59d5f68e5de53c4d8';

abstract class _$CodyList extends $AsyncNotifier<CodyListState> {
  FutureOr<CodyListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CodyListState>, CodyListState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<CodyListState>, CodyListState>,
        AsyncValue<CodyListState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
