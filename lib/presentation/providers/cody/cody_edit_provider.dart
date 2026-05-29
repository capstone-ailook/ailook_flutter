import 'dart:io';
import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:ailook_flutter/features/media/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

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
    bool clearTop = false,
    ItemEntity? bottom,
    bool clearBottom = false,
    ItemEntity? shoes,
    bool clearShoes = false,
    ItemEntity? accessory,
    bool clearAccessory = false,
    File? pickedImage,
    String? imageUrl,
    bool? isLoading,
    String? error,
  }) {
    return CodyEditState(
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      top: clearTop ? null : (top ?? this.top),
      bottom: clearBottom ? null : (bottom ?? this.bottom),
      shoes: clearShoes ? null : (shoes ?? this.shoes),
      accessory: clearAccessory ? null : (accessory ?? this.accessory),
      pickedImage: pickedImage ?? this.pickedImage,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class CodyEdit extends _$CodyEdit {
  final ImagePicker _picker = ImagePicker();

  @override
  CodyEditState build() {
    return CodyEditState();
  }

  void initWithCody(CodyEntity cody) {
    state = CodyEditState(
      name: cody.name ?? '',
      description: cody.description ?? '',
      tags: cody.tags ?? [],
      top: cody.top,
      bottom: cody.bottom,
      shoes: cody.shoes,
      accessory: cody.accessory,
      imageUrl: cody.imageUrl,
    );
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

  void clearItem(String category) {
    switch (category.toLowerCase()) {
      case 'top':
        state = state.copyWith(clearTop: true);
        break;
      case 'bottom':
        state = state.copyWith(clearBottom: true);
        break;
      case 'shoes':
        state = state.copyWith(clearShoes: true);
        break;
      case 'accessory':
        state = state.copyWith(clearAccessory: true);
        break;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, maxWidth: 1080);
    if (image != null) {
      state = state.copyWith(pickedImage: File(image.path));
    }
  }

  Future<bool> save({int? id}) async {
    if (state.name.isEmpty) {
      state = state.copyWith(error: 'Please enter a name');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      String? finalUrl = state.imageUrl;
      
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
      final Result<CodyEntity> saveResult;
      
      if (id != null) {
        saveResult = await codyRepo.updateCody(id, body);
      } else {
        saveResult = await codyRepo.createCody(body);
      }

      return saveResult.fold(
        onSuccess: (cody) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        onFailure: (e) {
          String errorMessage = 'Save failed: $e';
          if (e is DioException && e.response?.data is Map) {
            final errors = e.response!.data as Map;
            if (errors.isNotEmpty) {
              errorMessage = errors.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n');
            }
          }
          state = state.copyWith(isLoading: false, error: errorMessage);
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> delete(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final codyRepo = locator<CodyRepository>();
      final result = await codyRepo.deleteCody(id);
      
      return result.fold(
        onSuccess: (_) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        onFailure: (e) {
          state = state.copyWith(isLoading: false, error: 'Delete failed: $e');
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
