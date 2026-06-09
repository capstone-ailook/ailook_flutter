import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'closet_list_provider.g.dart';

class ClosetListState {
  final List<ItemEntity> allItems;
  final List<ItemEntity> filteredItems;
  final String searchQuery;
  final String selectedCategory;

  ClosetListState({
    required this.allItems,
    required this.filteredItems,
    required this.searchQuery,
    required this.selectedCategory,
  });

  ClosetListState copyWith({
    List<ItemEntity>? allItems,
    List<ItemEntity>? filteredItems,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ClosetListState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

@Riverpod(keepAlive: true)
class ClosetList extends _$ClosetList {
  @override
  FutureOr<ClosetListState> build() async {
    final result = await getItemsUseCase.call();
    
    return result.fold(
      onSuccess: (itemList) {
        return ClosetListState(
          allItems: itemList.items,
          filteredItems: itemList.items,
          searchQuery: '',
          selectedCategory: 'all',
        );
      },
      onFailure: (error) {
        throw error;
      },
    );
  }

  void updateSearch(String query) {
    state.whenData((currentState) {
      final newSearchQuery = query.trim().toLowerCase();
      final newFilteredItems = _applyFilter(currentState.allItems, newSearchQuery, currentState.selectedCategory);
      state = AsyncData(currentState.copyWith(
        searchQuery: newSearchQuery,
        filteredItems: newFilteredItems,
      ));
    });
  }

  void updateCategory(String category) {
    state.whenData((currentState) {
      final newFilteredItems = _applyFilter(currentState.allItems, currentState.searchQuery, category);
      state = AsyncData(currentState.copyWith(
        selectedCategory: category,
        filteredItems: newFilteredItems,
      ));
    });
  }

  List<ItemEntity> _applyFilter(List<ItemEntity> items, String query, String category) {
    return items.where((item) {
      final name = item.name.toLowerCase();
      final itemCategory = item.category.toLowerCase();
      
      final matchesSearch = query.isEmpty || name.contains(query);
      final matchesCategory = category == 'all' || itemCategory == category;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
