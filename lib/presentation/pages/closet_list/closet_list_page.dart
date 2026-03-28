import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/presentation/providers/closet/closet_list_provider.dart';
import 'package:ailook_flutter/presentation/widgets/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClosetListPage extends BasePage {
  const ClosetListPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text(
        'MY CLOSET',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded, color: Colors.black, size: 28),
          onPressed: () async {
            final result = await ClosetEditRoute().push<bool>(context);
            if (result == true) {
              ref.read(closetListProvider.notifier).refresh();
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final closetState = ref.watch(closetListProvider);
    final searchController = useTextEditingController();

    return closetState.when(
      data: (state) {
        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) => ref.read(closetListProvider.notifier).updateSearch(value),
                  decoration: const InputDecoration(
                    hintText: 'Search closet items...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: state.selectedCategory == 'all',
                      onTap: () => ref.read(closetListProvider.notifier).updateCategory('all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Top',
                      isSelected: state.selectedCategory == 'top',
                      onTap: () => ref.read(closetListProvider.notifier).updateCategory('top'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Bottom',
                      isSelected: state.selectedCategory == 'bottom',
                      onTap: () => ref.read(closetListProvider.notifier).updateCategory('bottom'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Shoes',
                      isSelected: state.selectedCategory == 'shoes',
                      onTap: () => ref.read(closetListProvider.notifier).updateCategory('shoes'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Accessory',
                      isSelected: state.selectedCategory == 'accessory',
                      onTap: () => ref.read(closetListProvider.notifier).updateCategory('accessory'),
                    ),
                  ],
                ),
              ),
            ),

            // Grid
            Expanded(
              child: state.filteredItems.isEmpty
                  ? _EmptyState(isSearching: searchController.text.isNotEmpty)
                  : RefreshIndicator(
                      onRefresh: () => ref.read(closetListProvider.notifier).refresh(),
                      color: Colors.black,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.filteredItems.length,
                        itemBuilder: (context, index) {
                          return _ItemCard(item: state.filteredItems[index]);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final dynamic item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                    ),
                  )
                : const Center(child: Icon(Icons.image_rounded, color: Colors.grey, size: 32)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 4),
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (item.tags != null && item.tags!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4),
            child: Text(
              (item.tags as List).map((t) => '#$t').join(' '),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isSearching;

  const _EmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.checkroom_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'No matching items found' : 'Start by adding your first closet item',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
