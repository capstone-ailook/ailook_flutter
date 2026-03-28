import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:ailook_flutter/presentation/pages/cody_edit/item_selection_page.dart';
import 'package:ailook_flutter/presentation/providers/cody/cody_edit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CodyEditPage extends HookConsumerWidget {
  const CodyEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(codyEditProvider);
    final notifier = ref.read(codyEditProvider.notifier);
    final tagController = useTextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CREATE CODY',
          style: TextStyle(
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
          TextButton(
            onPressed: state.isLoading ? null : () async {
              final success = await notifier.save();
              if (success && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            child: Text(
              'DONE',
              style: TextStyle(
                color: state.isLoading ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Slots Section
                const Text('Selection Items', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _ItemSlot(label: 'TOP', item: state.top, onSelect: () => _openItemSelector(context, 'top', notifier)),
                    _ItemSlot(label: 'BOTTOM', item: state.bottom, onSelect: () => _openItemSelector(context, 'bottom', notifier)),
                    _ItemSlot(label: 'SHOES', item: state.shoes, onSelect: () => _openItemSelector(context, 'shoes', notifier)),
                    _ItemSlot(label: 'ACCESSORY', item: state.accessory, onSelect: () => _openItemSelector(context, 'accessory', notifier)),
                  ],
                ),
                const SizedBox(height: 40),

                // Name & Metadata Section
                const Text('Cody Info', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 20),
                TextField(
                  onChanged: notifier.updateName,
                  decoration: InputDecoration(
                    hintText: 'Cody Name *',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: notifier.updateDescription,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Description (Optional)',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 32),

                // Preview Image (Optional)
                const Text('Preview Image', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: notifier.pickImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: state.pickedImage != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(19), child: Image.file(state.pickedImage!, fit: BoxFit.cover))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[400], size: 32),
                              const SizedBox(height: 8),
                              const Text('Add preview image (Optional)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Tags
                const Text('Tags', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tagController,
                        onSubmitted: (v) {
                          notifier.addTag(v);
                          tagController.clear();
                        },
                        decoration: InputDecoration(
                          hintText: 'Add tag...',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(icon: const Icon(Icons.add_circle), onPressed: () {
                      notifier.addTag(tagController.text);
                      tagController.clear();
                    }),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: state.tags.map((t) => Chip(
                    label: Text('#$t', style: const TextStyle(fontWeight: FontWeight.w600)),
                    backgroundColor: Colors.grey[100],
                    onDeleted: () => notifier.removeTag(t),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide.none,
                  )).toList(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
          if (state.isLoading)
             Container(color: Colors.white.withOpacity(0.8), child: const Center(child: CircularProgressIndicator(color: Colors.black))),
          if (state.error != null)
             Positioned(
               bottom: 16, left: 16, right: 16,
               child: Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12)),
                 child: Text(state.error!, style: const TextStyle(color: Colors.red)),
               ),
             ),
        ],
      ),
    );
  }

  void _openItemSelector(BuildContext context, String category, CodyEdit notifier) async {
    final ItemEntity? selectedItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ItemSelectionPage(category: category)),
    );
    if (selectedItem != null) {
      notifier.setItem(category, selectedItem);
    }
  }
}

class _ItemSlot extends StatelessWidget {
  final String label;
  final ItemEntity? item;
  final VoidCallback onSelect;

  const _ItemSlot({required this.label, this.item, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: item != null ? Colors.black12 : Colors.grey[200]!, width: item != null ? 1.5 : 1),
        ),
        child: item != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: item!.imageUrl != null
                        ? Image.network(item!.imageUrl!, fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.image_outlined)),
                  ),
                  Positioned(
                    bottom: 8, left: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.grey[400], size: 32),
                  const SizedBox(height: 4),
                  Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
      ),
    );
  }
}
