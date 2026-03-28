import 'package:ailook_flutter/presentation/providers/closet/closet_edit_provider.dart';
import 'package:ailook_flutter/app/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClosetEditPage extends HookConsumerWidget {
  const ClosetEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(closetEditProvider);
    final notifier = ref.read(closetEditProvider.notifier);
    final tagController = useTextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ADD ITEM',
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
                // Image Picker Area
                GestureDetector(
                  onTap: state.isLoading ? null : notifier.pickImage,
                  child: Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: state.pickedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(23),
                            child: Image.file(state.pickedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text(
                                'Tap to add a photo',
                                style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Name Input
                const Text('Item Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  onChanged: notifier.updateName,
                  decoration: InputDecoration(
                    hintText: 'e.g. White Cotton T-Shirt',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Selection
                const Text('Category', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _CategoryChip(label: 'TOP', value: 'top', isSelected: state.category == 'top', onTap: notifier.updateCategory),
                      _CategoryChip(label: 'BOTTOM', value: 'bottom', isSelected: state.category == 'bottom', onTap: notifier.updateCategory),
                      _CategoryChip(label: 'SHOES', value: 'shoes', isSelected: state.category == 'shoes', onTap: notifier.updateCategory),
                      _CategoryChip(label: 'ACCESSORY', value: 'accessory', isSelected: state.category == 'accessory', onTap: notifier.updateCategory),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Kind / Keywords
                const Text('Kind', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  onChanged: notifier.updateKind,
                  decoration: InputDecoration(
                    hintText: 'e.g. Tee, Jeans, Hoodie',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tags
                const Text('Tags', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tagController,
                        onSubmitted: (value) {
                          notifier.addTag(value);
                          tagController.clear();
                        },
                        decoration: InputDecoration(
                          hintText: 'Add a tag...',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () {
                        notifier.addTag(tagController.text);
                        tagController.clear();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.tags.map((tag) => Chip(
                    label: Text('#$tag', style: const TextStyle(fontWeight: FontWeight.w600)),
                    backgroundColor: Colors.grey[100],
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => notifier.removeTag(tag),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide.none,
                  )).toList(),
                ),
              ],
            ),
          ),
          if (state.isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(child: CircularProgressIndicator(color: Colors.black)),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final Function(String) onTap;

  const _CategoryChip({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey[200]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
