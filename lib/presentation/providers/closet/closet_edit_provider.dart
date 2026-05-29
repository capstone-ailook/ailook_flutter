import 'dart:io';
import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:ailook_flutter/features/media/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part 'closet_edit_provider.g.dart';

class ClosetEditState {
  final String name;
  final String category;
  final String kind;
  final String description;
  final List<String> tags;
  final File? pickedImage;
  final String? imageUrl;
  final bool isLoading;
  final String? error;

  ClosetEditState({
    this.name = '',
    this.category = 'top',
    this.kind = '',
    this.description = '',
    this.tags = const [],
    this.pickedImage,
    this.imageUrl,
    this.isLoading = false,
    this.error,
  });

  ClosetEditState copyWith({
    String? name,
    String? category,
    String? kind,
    String? description,
    List<String>? tags,
    File? pickedImage,
    String? imageUrl,
    bool? isLoading,
    String? error,
  }) {
    return ClosetEditState(
      name: name ?? this.name,
      category: category ?? this.category,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      pickedImage: pickedImage ?? this.pickedImage,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class ClosetEdit extends _$ClosetEdit {
  final ImagePicker _picker = ImagePicker();

  @override
  ClosetEditState build() {
    return ClosetEditState();
  }

  void initWithItem(ItemEntity item) {
    state = ClosetEditState(
      name: item.name,
      category: item.category,
      kind: item.kind ?? '',
      description: item.description ?? '',
      tags: item.tags ?? [],
      imageUrl: item.imageUrl,
    );
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateCategory(String category) => state = state.copyWith(category: category);
  void updateKind(String kind) => state = state.copyWith(kind: kind);
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
        'category': state.category,
        'kind': state.kind,
        'description': state.description,
        'image_url': finalUrl,
        'tags': state.tags,
      };

      final codyRepo = locator<CodyRepository>();
      final Result<ItemEntity> saveResult;
      
      if (id != null) {
        saveResult = await codyRepo.updateItem(id, body);
      } else {
        saveResult = await codyRepo.createItem(body);
      }

      return saveResult.fold(
        onSuccess: (item) {
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
      final result = await codyRepo.deleteItem(id);
      
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
