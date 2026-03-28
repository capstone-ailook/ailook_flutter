import 'dart:io';
import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:ailook_flutter/features/media/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cody_edit_provider.g.dart';

class CodyEditState {
  final String name;
  final String description;
  final List<String> tags;
  final ItemEntity? top;
  final ItemEntity? bottom;
  final ItemEntity? shoes;
  final ItemEntity? accessory;
  final File? pickedImage;
  final String? imageUrl;
  final bool isLoading;
  final String? error;

  CodyEditState({
    this.name = '',
    this.description = '',
    this.tags = const [],
    this.top,
    this.bottom,
    this.shoes,
    this.accessory,
    this.pickedImage,
    this.imageUrl,
    this.isLoading = false,
    this.error,
  });

  CodyEditState copyWith({
    String? name,
    String? description,
    List<String>? tags,
    ItemEntity? top,
    ItemEntity? bottom,
    ItemEntity? shoes,
    ItemEntity? accessory,
    File? pickedImage,
    String? imageUrl,
    bool? isLoading,
    String? error,
  }) {
    return CodyEditState(
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      shoes: shoes ?? this.shoes,
      accessory: accessory ?? this.accessory,
      pickedImage: pickedImage ?? this.pickedImage,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@Riverpod()
class CodyEdit extends _$CodyEdit {
  final ImagePicker _picker = ImagePicker();

  @override
  CodyEditState build() {
    return CodyEditState();
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateDescription(String description) => state = state.copyWith(description: description);
  
  void addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !state.tags.contains(trimmed)) {
      state = state.copyWith(tags: [...state.tags, trimmed]);
    }
  }

  void removeTag(String tag) {
    state = state.copyWith(tags: state.tags.where((t) => t != tag).toList());
  }

  void setItem(String category, ItemEntity item) {
    switch (category.toLowerCase()) {
      case 'top':
        state = state.copyWith(top: item);
        break;
      case 'bottom':
        state = state.copyWith(bottom: item);
        break;
      case 'shoes':
        state = state.copyWith(shoes: item);
        break;
      case 'accessory':
        state = state.copyWith(accessory: item);
        break;
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1080);
    if (image != null) {
      state = state.copyWith(pickedImage: File(image.path));
    }
  }

  Future<bool> save() async {
    if (state.name.isEmpty) {
      state = state.copyWith(error: 'Please enter a name');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      String? finalUrl = state.imageUrl;
      
      // 1. Upload image if picked
      if (state.pickedImage != null) {
        final mediaRepo = locator<MediaRepository>();
        final uploadResult = await mediaRepo.uploadImage(state.pickedImage!);
        
        finalUrl = uploadResult.fold(
          onSuccess: (url) => url,
          onFailure: (e) {
             state = state.copyWith(isLoading: false, error: 'Image upload failed: $e');
             return null;
          },
        );
        
        if (finalUrl == null) return false;
      }

      // 2. Save Cody metadata
      final body = {
        'name': state.name,
        'description': state.description,
        'image_url': finalUrl,
        'tags': state.tags,
        'top': state.top?.id,
        'bottom': state.bottom?.id,
        'shoes': state.shoes?.id,
        'accessory': state.accessory?.id,
      };

      final codyRepo = locator<CodyRepository>();
      final saveResult = await codyRepo.createCody(body);

      return saveResult.fold(
        onSuccess: (cody) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        onFailure: (e) {
          state = state.copyWith(isLoading: false, error: 'Save failed: $e');
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
