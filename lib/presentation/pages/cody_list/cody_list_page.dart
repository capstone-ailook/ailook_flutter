import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/cody_entity.dart';
import 'package:ailook_flutter/presentation/providers/cody/cody_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CodyListPage extends HookConsumerWidget {
  const CodyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codyListState = ref.watch(codyListProvider);
    final searchController = useTextEditingController();
    final showFavoritesOnly = useState(false);

    useEffect(() {
      void listener() {
        ref.read(codyListProvider.notifier).filter(searchController.text, showFavoritesOnly.value);
      }
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController, showFavoritesOnly]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MY CODY',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.black, size: 28),
            onPressed: () async {
              final result = await CodyEditRoute().push<bool>(context);
              if (result == true) {
                ref.read(codyListProvider.notifier).refresh();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
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
                decoration: const InputDecoration(
                  hintText: 'Search cody name...',
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
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: !showFavoritesOnly.value,
                  onTap: () => showFavoritesOnly.value = false,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Favorites',
                  isSelected: showFavoritesOnly.value,
                  onTap: () => showFavoritesOnly.value = true,
                ),
              ],
            ),
          ),

          // Cody Grid
          Expanded(
            child: codyListState.when(
              data: (state) => state.filteredCodies.isEmpty
                  ? _EmptyState(
                      isSearching: searchController.text.isNotEmpty,
                      isFavorites: showFavoritesOnly.value,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(codyListProvider.notifier).refresh(),
                      color: Colors.black,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.74,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.filteredCodies.length,
                        itemBuilder: (context, index) {
                          return _CodyCard(cody: state.filteredCodies[index]);
                        },
                      ),
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                    const SizedBox(height: 12),
                    Text('Error: $err'),
                    TextButton(
                      onPressed: () => ref.read(codyListProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

class _CodyCard extends StatelessWidget {
  final CodyEntity cody;

  const _CodyCard({required this.cody});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
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
                child: cody.imageUrl != null && cody.imageUrl!.isNotEmpty
                    ? Image.network(
                        cody.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                        ),
                      )
                    : const Center(child: Icon(Icons.image_rounded, color: Colors.grey, size: 32)),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      (cody.isFavorite ?? false) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: (cody.isFavorite ?? false) ? Colors.red : Colors.black45,
                      size: 20,
                    ),
                    onPressed: () {
                      // TODO: Toggle favorite
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 4),
          child: Text(
            cody.name ?? 'Untitled',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (cody.tags != null && cody.tags!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4),
            child: Text(
              cody.tags!.map((t) => '#$t').join(' '),
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
  final bool isFavorites;

  const _EmptyState({required this.isSearching, required this.isFavorites});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching
                ? Icons.search_off_rounded
                : (isFavorites ? Icons.favorite_border_rounded : Icons.checkroom_rounded),
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'No matching codies found'
                : (isFavorites ? 'No favorite codies yet' : 'Start by adding your first cody'),
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
