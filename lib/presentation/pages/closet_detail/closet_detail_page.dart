import 'package:ailook_flutter/app/router/router.dart';
import 'package:ailook_flutter/presentation/providers/closet/closet_list_provider.dart';
import 'package:ailook_flutter/presentation/providers/closet/closet_edit_provider.dart';
import 'package:ailook_flutter/presentation/widgets/base/base_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:go_router/go_router.dart';

class ClosetDetailPage extends BasePage {
  final int id;
  const ClosetDetailPage({super.key, required this.id});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    final closetState = ref.watch(closetListProvider);
    
    // Memoized item to prevent AppBar flickers during refresh
    final item = useMemoized(() {
      return closetState.maybeWhen(
        data: (s) => s.allItems.firstWhereOrNull((e) => e.id == id),
        orElse: () => null,
      );
    }, [closetState.asData]);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        item?.name ?? 'ITEM DETAIL',
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
          onPressed: () => _showMoreMenu(context, ref, item),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    // 1. Reactive Navigation: If the item is deleted from the list, close this page immediately.
    ref.listen(closetListProvider, (prev, next) {
      if (next is AsyncData) {
        final exists = next.value!.allItems.any((e) => e.id == id);
        if (!exists && context.mounted) {
          // Record is gone, navigate back to list
          ClosetListRoute().go(context);
        }
      }
    });

    final closetState = ref.watch(closetListProvider);
    
    // 2. Data Caching: Use a hook to keep the item displayed even if the provider is loading/refreshing
    final cachedItem = useState<ItemEntity?>(null);
    useEffect(() {
      closetState.whenData((s) {
        final found = s.allItems.firstWhereOrNull((e) => e.id == id);
        if (found != null) {
          cachedItem.value = found;
        }
      });
      return null;
    }, [closetState]);

    final item = cachedItem.value;
    
    // Fallback UI if we truly have no data yet
    if (item == null) {
      return closetState.when(
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
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'item_${item.id}',
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[100],
                        child: const Icon(Icons.error_outline),
                      ),
                    )
                  : Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.image_rounded, size: 64, color: Colors.grey),
                    ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Details',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _PropertyRow(label: 'Category', value: item.category),
                _PropertyRow(label: 'Kind', value: item.kind),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.6),
                  ),
                ],
                const SizedBox(height: 24),

                if (item.tags.isNotEmpty) ...[
                  const Text(
                    'Tags',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) => _TagChip(label: tag)).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context, WidgetRef ref, ItemEntity? item) {
    if (item == null) return;
    
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
              title: const Text('Edit Item', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                ClosetEditRoute(id: item.id).push(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Delete Item', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, item);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ItemEntity item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              EasyLoading.show(status: 'Deleting...');
              
              try {
                final success = await ref.read(closetEditProvider.notifier).delete(item.id);
                
                if (success) {
                  await EasyLoading.dismiss();
                  
                  // Use the main context for navigation
                  if (context.mounted) {
                    ClosetListRoute().go(context);
                  }
                  
                  EasyLoading.showSuccess('Deleted');
                  
                  // Final safeguard: Refresh list
                  ref.read(closetListProvider.notifier).refresh();
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

class _PropertyRow extends StatelessWidget {
  final String label;
  final String value;
  const _PropertyRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
