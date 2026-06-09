import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/presentation/providers/cody/cody_list_provider.dart';
import 'package:ailook_flutter/presentation/providers/cody/cody_edit_provider.dart';
import 'package:ailook_flutter/presentation/widgets/base/base_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:go_router/go_router.dart';

class CodyDetailPage extends BasePage {
  final int id;
  const CodyDetailPage({super.key, required this.id});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    final codyListState = ref.watch(codyListProvider);
    
    // Memoized cody to prevent AppBar flickers during refresh
    final cody = useMemoized(() {
      return codyListState.maybeWhen(
        data: (s) => s.allCodies.firstWhereOrNull((e) => e.id == id),
        orElse: () => null,
      );
    }, [codyListState.asData]);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        cody?.name ?? 'CODY DETAIL',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
          onPressed: () => _showMoreMenu(context, ref, cody),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    // 1. Reactive Navigation: If the cody is deleted from the list, close this page immediately.
    ref.listen(codyListProvider, (prev, next) {
      if (next is AsyncData) {
        final exists = next.value!.allCodies.any((e) => e.id == id);
        if (!exists && context.mounted) {
          // Record is gone, navigate back to list
          CodyListRoute().go(context);
        }
      }
    });

    final codyListState = ref.watch(codyListProvider);
    
    // 2. Data Caching: Use a hook to keep the cody displayed even if the provider is loading/refreshing
    final cachedCody = useState<CodyEntity?>(null);
    useEffect(() {
      codyListState.whenData((s) {
        final found = s.allCodies.firstWhereOrNull((e) => e.id == id);
        if (found != null) {
          cachedCody.value = found;
        }
      });
      return null;
    }, [codyListState]);

    final cody = cachedCody.value;
    
    if (cody == null) {
      return codyListState.when(
        data: (_) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (e, _) => Center(child: Text('Error: $e')),
      );
    }
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'cody_item_${cody.id}',
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[50]),
                child: cody.imageUrl != null && cody.imageUrl!.isNotEmpty
                    ? Image.network(cody.imageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.image_rounded, size: 64, color: Colors.grey),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cody.name,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: -0.5),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        cody.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: cody.isFavorite ? Colors.red : Colors.black45,
                        size: 28,
                      ),
                      onPressed: () {
                        ref.read(codyListProvider.notifier).toggleFavorite(cody.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (cody.description.isNotEmpty) ...[
                  Text(
                    cody.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.6),
                  ),
                  const SizedBox(height: 32),
                ],

                const Text('Constituent Items', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _SmallItemCard(label: 'TOP', item: cody.top),
                    _SmallItemCard(label: 'BOTTOM', item: cody.bottom),
                    _SmallItemCard(label: 'SHOES', item: cody.shoes),
                    _SmallItemCard(label: 'ACCESSORY', item: cody.accessory),
                  ],
                ),
                const SizedBox(height: 32),

                if (cody.tags.isNotEmpty) ...[
                  const Text('Style Tags', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cody.tags.map((tag) => _TagChip(label: tag)).toList(),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context, WidgetRef ref, CodyEntity? cody) {
    if (cody == null) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded, color: Colors.black),
              title: const Text('Edit Cody', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                CodyEditRoute(id: cody.id).push(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Delete Cody', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, cody);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, CodyEntity cody) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Cody'),
        content: Text('Are you sure you want to delete "${cody.name}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              EasyLoading.show(status: 'Deleting...');
              
              try {
                final success = await ref.read(codyEditProvider.notifier).delete(cody.id);
                
                if (success) {
                  // kept-alive 리스트가 삭제를 반영하도록 네비게이션 전에 리페치
                  await ref.read(codyListProvider.notifier).refresh();
                  await EasyLoading.dismiss();

                  if (context.mounted) {
                    CodyListRoute().go(context);
                  }

                  EasyLoading.showSuccess('Deleted');
                } else {
                  await EasyLoading.dismiss();
                  EasyLoading.showError('Failed to delete');
                }
              } catch (e) {
                await EasyLoading.dismiss();
                EasyLoading.showError('Error occurred');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SmallItemCard extends StatelessWidget {
  final String label;
  final ItemEntity? item;
  const _SmallItemCard({required this.label, this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: item?.imageUrl != null ? Image.network(item!.imageUrl!, fit: BoxFit.cover) : const Icon(Icons.image, size: 20, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey)),
                Text(item?.name ?? 'Not selected', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Text('#$label', style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
