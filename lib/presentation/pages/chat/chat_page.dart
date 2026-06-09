import 'dart:io';
import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/chat/repositories/entities/chat_entity.dart';
import 'package:ailook_flutter/features/cody/cody.dart';
import 'package:ailook_flutter/presentation/providers/chat/chat_provider.dart';
import 'package:ailook_flutter/presentation/providers/cody/cody_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSessionId = useState<int?>(null);
    final messagesState = ref.watch(chatMessagesProvider(selectedSessionId.value));
    final textController = useTextEditingController();
    final scrollController = useScrollController();

    // Scroll to bottom when messages change
    useEffect(() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      return null;
    }, [messagesState]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'AI STYLIST',
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
            onPressed: () => selectedSessionId.value = null,
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.black, size: 26),
            onPressed: () => _showHistorySheet(context, ref, selectedSessionId),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: messagesState.when(
              data: (messages) => messages.isEmpty
                  ? const _ChatEmptyState()
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _MessageBubble(message: messages[index]);
                      },
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              ),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),

          // Input Area
          _ChatInput(
            controller: textController,
            onSend: (text) async {
              if (text.trim().isEmpty) return;
              final newId = await ref.read(chatMessagesProvider(selectedSessionId.value).notifier).sendMessage(text);
              if (selectedSessionId.value == null && newId != null) {
                selectedSessionId.value = newId;
              }
              textController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _showHistorySheet(BuildContext context, WidgetRef ref, ValueNotifier<int?> selectedId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return _ChatHistorySheet(activeSessionId: selectedId.value);
      },
    ).then((newId) {
      if (newId != null && newId is int) {
        selectedId.value = newId;
      }
    });
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final isLoading = message.role == 'loading';
    final hasOutfits = !isUser && !isLoading && message.outfits.isNotEmpty;

    if (isLoading) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const SizedBox(
            width: 24,
            height: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TypingDot(delay: 0),
                _TypingDot(delay: 0.2),
                _TypingDot(delay: 0.4),
              ],
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * (hasOutfits ? 0.85 : 0.75)),
        decoration: BoxDecoration(
          color: isUser ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null && message.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(message.imageUrl!),
                ),
              ),
            if (hasOutfits)
              ..._buildRichBody(context, message.text, message.outfits,
                  message.anchorItemId, message.anchorCategory)
            else
              Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// AI 답변의 `[image: 파일명]` 토큰을 outfits와 매칭해 텍스트 사이에 카드를 끼워 렌더링.
  /// 매칭 안 되는 토큰은 건너뛰고, 토큰이 하나도 안 걸리면 outfits를 하단에 폴백 노출.
  List<Widget> _buildRichBody(BuildContext context, String text,
      List<OutfitEntity> outfits, int? anchorItemId, String? anchorCategory) {
    final byImage = {for (final o in outfits) o.image: o};
    final widgets = <Widget>[];
    final used = <String>{};
    final re = RegExp(r'\[image:\s*([^\]]+)\]');
    int last = 0;
    Widget card(OutfitEntity o) => _OutfitCard(
        outfit: o, anchorItemId: anchorItemId, anchorCategory: anchorCategory);
    for (final m in re.allMatches(text)) {
      final before = text.substring(last, m.start).trim();
      if (before.isNotEmpty) widgets.add(_aiText(before));
      final fname = m.group(1)!.trim();
      final outfit = byImage[fname];
      if (outfit != null) {
        widgets.add(card(outfit));
        used.add(fname);
      }
      last = m.end;
    }
    final tail = text.substring(last).trim();
    if (tail.isNotEmpty) widgets.add(_aiText(tail));
    if (used.isEmpty) {
      for (final o in outfits) {
        widgets.add(card(o));
      }
    }
    return widgets;
  }

  Widget _aiText(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(t,
            style: const TextStyle(
                color: Colors.black87, fontSize: 15, height: 1.4)),
      );
}

class _OutfitCard extends StatelessWidget {
  final OutfitEntity outfit;
  final int? anchorItemId;
  final String? anchorCategory;
  const _OutfitCard({required this.outfit, this.anchorItemId, this.anchorCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => _OutfitDetailSheet(
            outfit: outfit,
            anchorItemId: anchorItemId,
            anchorCategory: anchorCategory),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                outfit.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.broken_image_outlined,
                        color: Colors.grey)),
                loadingBuilder: (c, child, p) => p == null
                    ? child
                    : Container(
                        color: Colors.grey.shade50,
                        child: const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black26))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  if (outfit.substyle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(outfit.substyle!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  const Spacer(),
                  const Icon(Icons.add_circle_outline_rounded,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 4),
                  const Text('코디 저장',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutfitDetailSheet extends ConsumerWidget {
  final OutfitEntity outfit;
  final int? anchorItemId;
  final String? anchorCategory;
  const _OutfitDetailSheet(
      {required this.outfit, this.anchorItemId, this.anchorCategory});

  Future<void> _saveAsCody(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final body = <String, dynamic>{
      'name': 'AI 추천 코디',
      'description': outfit.captionSnippet ?? '',
      'image_url': outfit.imageUrl,
      'tags': [if (outfit.substyle != null) outfit.substyle!],
    };
    // 클로젯-탭 추천이면 앵커(사용자 실제 Item)를 해당 슬롯에 연결 (D9 c)
    if (anchorItemId != null &&
        (anchorCategory == 'top' || anchorCategory == 'bottom')) {
      body[anchorCategory!] = anchorItemId;
    }
    final result = await locator<CodyRepository>().createCody(body);
    navigator.pop();
    result.fold(
      onSuccess: (_) {
        // kept-alive 코디 리스트가 새 코디를 반영하도록 리페치 (#1)
        ref.invalidate(codyListProvider);
        messenger.showSnackBar(
            const SnackBar(content: Text('내 코디에 저장했어요 👕')));
      },
      onFailure: (e) => messenger
          .showSnackBar(SnackBar(content: Text('저장 실패: $e'))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(outfit.imageUrl, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 14),
            if (outfit.substyle != null)
              Text('#${outfit.substyle}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            if (outfit.captionSnippet != null) ...[
              const SizedBox(height: 6),
              Text(outfit.captionSnippet!,
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 13, height: 1.4)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _saveAsCody(context, ref),
                icon: const Icon(Icons.checkroom_rounded, size: 20),
                label: const Text('이 코디로 저장',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final double delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
      ),
    );
  }
}

class _ChatInput extends ConsumerWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const _ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(chatImageProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        image: DecorationImage(
                          image: FileImage(File(imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => ref.read(chatImageProvider.notifier).clear(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.black54, size: 24),
                  onPressed: () => _showImageSourceDialog(context, ref),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: 5,
                    minLines: 1,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      hintText: 'Ask about your style...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (controller.text.trim().isNotEmpty || imagePath != null) {
                      onSend(controller.text);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('앨범에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(chatImageProvider.notifier).pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(chatImageProvider.notifier).pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatHistorySheet extends ConsumerWidget {
  final int? activeSessionId;
  const _ChatHistorySheet({this.activeSessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsState = ref.watch(chatSessionListProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Chat History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          // New Chat Tile
          ListTile(
            leading: const Icon(Icons.add_circle_outline_rounded, color: Colors.black87, size: 22),
            title: const Text('Start New Chat', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pop(context, null),
          ),
          const Divider(height: 1),
          sessionsState.when(
            data: (sessions) => sessions.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No history yet')))
                : Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final isActive = session.id == activeSessionId;
                        return ListTile(
                          leading: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 20,
                            color: isActive ? Colors.black : Colors.grey[600],
                          ),
                          title: Text(
                            session.title ?? 'New Chat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? Colors.black : Colors.black87,
                            ),
                          ),
                          subtitle: Text(session.createdAt?.split('T').first ?? ''),
                          onTap: () => Navigator.pop(context, session.id),
                          trailing: isActive
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: const Text(
                                    '현재 채팅',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                  onPressed: () => _showDeleteConfirmation(context, ref, session),
                                ),
                        );
                      },
                    ),
                  ),
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Colors.black))),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, ChatSessionEntity session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text('Are you sure you want to delete "${session.title ?? 'this chat'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatSessionListProvider.notifier).deleteSession(session.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _ChatEmptyState extends StatelessWidget {
  const _ChatEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_outlined, size: 64, color: Colors.grey[200]),
          const SizedBox(height: 20),
          const Text(
            'How can I help you today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ask for outfit suggestions or style advice.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
