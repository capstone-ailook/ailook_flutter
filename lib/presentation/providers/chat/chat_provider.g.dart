// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'8ca4598510bdde4d3bfbb97383900c9c8e2602b4';

@ProviderFor(mediaRepository)
final mediaRepositoryProvider = MediaRepositoryProvider._();

final class MediaRepositoryProvider extends $FunctionalProvider<MediaRepository,
    MediaRepository, MediaRepository> with $Provider<MediaRepository> {
  MediaRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'mediaRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mediaRepositoryHash();

  @$internal
  @override
  $ProviderElement<MediaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaRepository create(Ref ref) {
    return mediaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaRepository>(value),
    );
  }
}

String _$mediaRepositoryHash() => r'7eb9eeeb1efca82e5b3c54d0631632e7f8d2ea4a';

@ProviderFor(ChatImage)
final chatImageProvider = ChatImageProvider._();

final class ChatImageProvider extends $NotifierProvider<ChatImage, String?> {
  ChatImageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatImageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatImageHash();

  @$internal
  @override
  ChatImage create() => ChatImage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$chatImageHash() => r'b2ff349d7e1500c20617a1f2306cdf6865cecf11';

abstract class _$ChatImage extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatSessionList)
final chatSessionListProvider = ChatSessionListProvider._();

final class ChatSessionListProvider
    extends $AsyncNotifierProvider<ChatSessionList, List<ChatSessionEntity>> {
  ChatSessionListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatSessionListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatSessionListHash();

  @$internal
  @override
  ChatSessionList create() => ChatSessionList();
}

String _$chatSessionListHash() => r'adfd624b524726d9b41c826ad97afebdda18debb';

abstract class _$ChatSessionList
    extends $AsyncNotifier<List<ChatSessionEntity>> {
  FutureOr<List<ChatSessionEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<ChatSessionEntity>>, List<ChatSessionEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ChatSessionEntity>>,
            List<ChatSessionEntity>>,
        AsyncValue<List<ChatSessionEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatMessages)
final chatMessagesProvider = ChatMessagesFamily._();

final class ChatMessagesProvider
    extends $AsyncNotifierProvider<ChatMessages, List<ChatMessageEntity>> {
  ChatMessagesProvider._(
      {required ChatMessagesFamily super.from, required int? super.argument})
      : super(
          retry: null,
          name: r'chatMessagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatMessages create() => ChatMessages();

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'b0a3658f8ce591d1ac83e2585343c44cc29c8e86';

final class ChatMessagesFamily extends $Family
    with
        $ClassFamilyOverride<ChatMessages, AsyncValue<List<ChatMessageEntity>>,
            List<ChatMessageEntity>, FutureOr<List<ChatMessageEntity>>, int?> {
  ChatMessagesFamily._()
      : super(
          retry: null,
          name: r'chatMessagesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ChatMessagesProvider call(
    int? argSessionId,
  ) =>
      ChatMessagesProvider._(argument: argSessionId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

abstract class _$ChatMessages extends $AsyncNotifier<List<ChatMessageEntity>> {
  late final _$args = ref.$arg as int?;
  int? get argSessionId => _$args;

  FutureOr<List<ChatMessageEntity>> build(
    int? argSessionId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<ChatMessageEntity>>, List<ChatMessageEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ChatMessageEntity>>,
            List<ChatMessageEntity>>,
        AsyncValue<List<ChatMessageEntity>>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
