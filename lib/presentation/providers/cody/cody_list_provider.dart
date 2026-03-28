import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cody_list_provider.g.dart';

@riverpod
class CodyList extends _$CodyList {
  @override
  FutureOr<CodyListState> build() async {
    return _fetch();
  }

  Future<CodyListState> _fetch() async {
    final result = await getCodiesUseCase.call();
    return result.fold(
      onSuccess: (data) => CodyListState(
        allCodies: data.codies,
        filteredCodies: data.codies,
      ),
      onFailure: (error) => throw error,
    );
  }

  void filter(String query, bool showFavoritesOnly) {
    state.whenData((data) {
      final filtered = data.allCodies.where((cody) {
        final matchesQuery = query.isEmpty || (cody.name?.toLowerCase().contains(query.toLowerCase()) ?? false);
        final matchesFav = !showFavoritesOnly || (cody.isFavorite ?? false);
        return matchesQuery && matchesFav;
      }).toList();

      state = AsyncData(data.copyWith(filteredCodies: filtered));
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }
}

class CodyListState {
  final List<CodyEntity> allCodies;
  final List<CodyEntity> filteredCodies;

  CodyListState({
    required this.allCodies,
    required this.filteredCodies,
  });

  CodyListState copyWith({
    List<CodyEntity>? allCodies,
    List<CodyEntity>? filteredCodies,
  }) {
    return CodyListState(
      allCodies: allCodies ?? this.allCodies,
      filteredCodies: filteredCodies ?? this.filteredCodies,
    );
  }
}
