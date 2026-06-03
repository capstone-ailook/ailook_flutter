class OutfitEntity {
  final String image;
  final String imageUrl;
  final double score;
  final String? substyle;
  final String? captionSnippet;

  const OutfitEntity({
    required this.image,
    required this.imageUrl,
    required this.score,
    this.substyle,
    this.captionSnippet,
  });

  factory OutfitEntity.fromJson(Map<String, dynamic> json) {
    return OutfitEntity(
      image: json['image'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      substyle: json['substyle'] as String?,
      captionSnippet: json['caption_snippet'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'image': image,
        'image_url': imageUrl,
        'score': score,
        'substyle': substyle,
        'caption_snippet': captionSnippet,
      };
}

class ChatMessageEntity {
  final String role;
  final String text;
  final String? imageUrl;
  final List<OutfitEntity> outfits;
  final int? anchorItemId;
  final String? anchorCategory;

  const ChatMessageEntity({
    required this.role,
    required this.text,
    this.imageUrl,
    this.outfits = const [],
    this.anchorItemId,
    this.anchorCategory,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      role: json['role'] as String,
      text: json['text'] as String,
      imageUrl: json['image_url'] as String?,
      outfits: (json['outfits'] as List<dynamic>? ?? [])
          .map((o) => OutfitEntity.fromJson(o as Map<String, dynamic>))
          .toList(),
      anchorItemId: json['anchor_item_id'] as int?,
      anchorCategory: json['anchor_category'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        'image_url': imageUrl,
        'outfits': outfits.map((o) => o.toJson()).toList(),
        'anchor_item_id': anchorItemId,
        'anchor_category': anchorCategory,
      };

  ChatMessageEntity copyWith({
    String? role,
    String? text,
    String? imageUrl,
    List<OutfitEntity>? outfits,
    int? anchorItemId,
    String? anchorCategory,
  }) {
    return ChatMessageEntity(
      role: role ?? this.role,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      outfits: outfits ?? this.outfits,
      anchorItemId: anchorItemId ?? this.anchorItemId,
      anchorCategory: anchorCategory ?? this.anchorCategory,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageEntity &&
          other.role == role &&
          other.text == text &&
          other.imageUrl == imageUrl &&
          other.outfits.length == outfits.length;

  @override
  int get hashCode => Object.hash(role, text, imageUrl, outfits.length);

  @override
  String toString() =>
      'ChatMessageEntity(role: $role, text: $text, imageUrl: $imageUrl, outfits: ${outfits.length})';
}

class ChatSessionEntity {
  final int id;
  final String? title;
  final String? createdAt;

  const ChatSessionEntity({
    required this.id,
    this.title,
    this.createdAt,
  });

  factory ChatSessionEntity.fromJson(Map<String, dynamic> json) {
    return ChatSessionEntity(
      id: json['id'] as int,
      title: json['title'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'created_at': createdAt,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionEntity &&
          other.id == id &&
          other.title == title &&
          other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, title, createdAt);

  @override
  String toString() =>
      'ChatSessionEntity(id: $id, title: $title, createdAt: $createdAt)';
}

class ChatSessionListEntity {
  final List<ChatSessionEntity> sessions;

  const ChatSessionListEntity({required this.sessions});

  factory ChatSessionListEntity.fromJson(Map<String, dynamic> json) {
    return ChatSessionListEntity(
      sessions: (json['sessions'] as List<dynamic>)
          .map((s) => ChatSessionEntity.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'sessions': sessions.map((s) => s.toJson()).toList(),
      };
}

class ChatResponseDataEntity {
  final String reply;
  final String? imageUrl;
  final List<OutfitEntity> outfits;
  final int? anchorItemId;
  final String? anchorCategory;

  const ChatResponseDataEntity({
    required this.reply,
    this.imageUrl,
    this.outfits = const [],
    this.anchorItemId,
    this.anchorCategory,
  });

  factory ChatResponseDataEntity.fromJson(Map<String, dynamic> json) {
    return ChatResponseDataEntity(
      reply: json['reply'] as String,
      imageUrl: json['image_url'] as String?,
      outfits: (json['outfits'] as List<dynamic>? ?? [])
          .map((o) => OutfitEntity.fromJson(o as Map<String, dynamic>))
          .toList(),
      anchorItemId: json['anchor_item_id'] as int?,
      anchorCategory: json['anchor_category'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'reply': reply,
        'image_url': imageUrl,
        'outfits': outfits.map((o) => o.toJson()).toList(),
        'anchor_item_id': anchorItemId,
        'anchor_category': anchorCategory,
      };

  @override
  String toString() =>
      'ChatResponseDataEntity(reply: $reply, imageUrl: $imageUrl, outfits: ${outfits.length})';
}
