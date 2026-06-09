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

  Future<CodyListState> _fetch({String? query, bool? showFavoritesOnly}) async {
    final result = await getCodiesUseCase.call();
    return result.fold(
      onSuccess: (data) {
        final lastQuery = query ?? state.value?.lastQuery ?? '';
        final lastFav = showFavoritesOnly ?? state.value?.lastShowFavoritesOnly ?? false;
        
        return CodyListState(
          allCodies: data.codies,
          filteredCodies: _getFilteredCodies(data.codies, lastQuery, lastFav),
          lastQuery: lastQuery,
          lastShowFavoritesOnly: lastFav,
        );
      },
      onFailure: (error) => throw error,
    );
  }

  void filter(String query, bool showFavoritesOnly) {
    state.whenData((data) {
      state = AsyncData(data.copyWith(
        filteredCodies: _getFilteredCodies(data.allCodies, query, showFavoritesOnly),
        lastQuery: query,
        lastShowFavoritesOnly: showFavoritesOnly,
      ));
    });
  }

  Future<void> refresh() async {
    final prevData = state.value;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return _fetch(
        query: prevData?.lastQuery,
        showFavoritesOnly: prevData?.lastShowFavoritesOnly,
      );
    });
  }

  Future<void> toggleFavorite(int id) async {
    final currentState = state.value;
    if (currentState == null) return;

    final allCodies = List<CodyEntity>.from(currentState.allCodies);
    final index = allCodies.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final oldCody = allCodies[index];
    final isNowFavorite = !(oldCody.isFavorite ?? false);
    final newCody = oldCody.copyWith(isFavorite: isNowFavorite);

    // Optimistic UI Update
    allCodies[index] = newCody;
    _applyUpdates(allCodies);

    final result = await toggleFavoriteUseCase.call(id);
    result.fold(
      onSuccess: (updatedStatus) {
        final latestState = state.value;
        if (latestState == null) return;
        
        final currentAll = List<CodyEntity>.from(latestState.allCodies);
        final currentIdx = currentAll.indexWhere((e) => e.id == id);
        if (currentIdx != -1 && updatedStatus != currentAll[currentIdx].isFavorite) {
          currentAll[currentIdx] = currentAll[currentIdx].copyWith(isFavorite: updatedStatus);
          _applyUpdates(currentAll);
        }
      },
      onFailure: (error) {
        final latestState = state.value;
        if (latestState == null) return;
        
        final currentAll = List<CodyEntity>.from(latestState.allCodies);
        final currentIdx = currentAll.indexWhere((e) => e.id == id);
        if (currentIdx != -1) {
          currentAll[currentIdx] = oldCody;
          _applyUpdates(currentAll);
        }
      },
    );
  }

  void _applyUpdates(List<CodyEntity> updatedAllCodies) {
    state.whenData((data) {
      state = AsyncData(data.copyWith(
        allCodies: updatedAllCodies,
        filteredCodies: _getFilteredCodies(updatedAllCodies, data.lastQuery, data.lastShowFavoritesOnly),
      ));
    });
  }

  List<CodyEntity> _getFilteredCodies(List<CodyEntity> all, String query, bool showFavoritesOnly) {
    return all.where((cody) {
      final matchesQuery = query.isEmpty || (cody.name?.toLowerCase().contains(query.toLowerCase()) ?? false);
      
      // Restored correct logic:
      if (showFavoritesOnly) {
        // "Favorites" tab selected -> Show ONLY favorites
        return matchesQuery && (cody.isFavorite ?? false);
      } else {
        // "All" tab selected -> Show EVERYTHING
        return matchesQuery;
      }
    }).toList();
  }
}

class CodyListState {
  final List<CodyEntity> allCodies;
  final List<CodyEntity> filteredCodies;
  final String lastQuery;
  final bool lastShowFavoritesOnly;

  CodyListState({
    required this.allCodies,
    required this.filteredCodies,
    this.lastQuery = '',
    this.lastShowFavoritesOnly = false,
  });

  CodyListState copyWith({
    List<CodyEntity>? allCodies,
    List<CodyEntity>? filteredCodies,
    String? lastQuery,
    bool? lastShowFavoritesOnly,
  }) {
    return CodyListState(
      allCodies: allCodies ?? this.allCodies,
      filteredCodies: filteredCodies ?? this.filteredCodies,
      lastQuery: lastQuery ?? this.lastQuery,
      lastShowFavoritesOnly: lastShowFavoritesOnly ?? this.lastShowFavoritesOnly,
    );
  }
}

