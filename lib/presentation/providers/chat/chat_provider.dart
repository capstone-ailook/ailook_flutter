import 'dart:io';
import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/chat/data_source/remote/chat_remote_data_source_impl.dart';
import 'package:ailook_flutter/features/chat/repositories/chat_repository.dart';
import 'package:ailook_flutter/features/chat/repositories/chat_repository_impl.dart';
import 'package:ailook_flutter/features/chat/repositories/entities/chat_entity.dart';
import 'package:ailook_flutter/features/media/repositories/media_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(ChatRemoteDataSourceImpl());
}

@riverpod
MediaRepository mediaRepository(Ref ref) {
  return locator<MediaRepository>();
}

@riverpod
class ChatImage extends _$ChatImage {
  @override
  String? build() => null;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      state = image.path;
    }
  }

  void clear() => state = null;
}

@riverpod
class ChatSessionList extends _$ChatSessionList {
  @override
  FutureOr<List<ChatSessionEntity>> build() async {
    final result = await ref.watch(chatRepositoryProvider).getSessions();
    return result.fold(
      onSuccess: (data) => data.sessions,
      onFailure: (error) => throw error,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(chatRepositoryProvider).getSessions();
      return result.fold(
        onSuccess: (data) => data.sessions,
        onFailure: (error) => throw error,
      );
    });
  }

  Future<void> deleteSession(int id) async {
    final result = await ref.read(chatRepositoryProvider).deleteSession(id);
    result.fold(
      onSuccess: (_) => refresh(),
      onFailure: (error) => throw error,
    );
  }
}

@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  FutureOr<List<ChatMessageEntity>> build(int? argSessionId) async {
    if (argSessionId == null) return [];
    
    final result = await ref.watch(chatRepositoryProvider).getSessionMessages(argSessionId);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (error) => throw error,
    );
  }

  Future<void> sendMessage(String text) async {
    final currentSessionId = argSessionId;
    final imagePath = ref.read(chatImageProvider);
    String? imageUrl;

    if (imagePath != null) {
      // Upload image first
      final uploadResult = await ref.read(mediaRepositoryProvider).uploadImage(File(imagePath));
      uploadResult.fold(
        onSuccess: (url) => imageUrl = url,
        onFailure: (error) => throw Exception('Image upload failed: $error'),
      );
      // Clear image state after successful upload
      ref.read(chatImageProvider.notifier).clear();
    }

    if (currentSessionId == null) {
      // Create new session first
      final sessionResult = await ref.read(chatRepositoryProvider).createSession('');
      sessionResult.fold(
        onSuccess: (session) async {
          await _sendToSession(session.id, text, imageUrl: imageUrl);
        },
        onFailure: (error) => throw error,
      );
    } else {
      await _sendToSession(currentSessionId, text, imageUrl: imageUrl);
    }
  }

  Future<void> _sendToSession(int id, String text, {String? imageUrl}) async {
    final previousMessages = state.asData?.value ?? [];
    
    // Optimistic update: Add user message and a temporary loading message
    final userMessage = ChatMessageEntity(role: 'user', text: text, imageUrl: imageUrl);
    final loadingMessage = const ChatMessageEntity(role: 'loading', text: '');
    state = AsyncData([...previousMessages, userMessage, loadingMessage]);

    final result = await ref.read(chatRepositoryProvider).sendMessage(id, text, imageUrl: imageUrl);
    
    result.fold(
      onSuccess: (data) {
        final aiMessage = ChatMessageEntity(role: 'ai', text: data.reply, imageUrl: data.imageUrl);
        state = AsyncData([...previousMessages, userMessage, aiMessage]);
      },
      onFailure: (error) {
        state = AsyncData([...previousMessages, userMessage, ChatMessageEntity(role: 'ai', text: 'Error: $error')]);
      },
    );
  }
}
