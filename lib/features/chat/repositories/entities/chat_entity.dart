class ChatMessageEntity {
  final String role;
  final String text;
  final String? imageUrl;

  const ChatMessageEntity({
    required this.role,
    required this.text,
    this.imageUrl,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      role: json['role'] as String,
      text: json['text'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        'image_url': imageUrl,
      };

  ChatMessageEntity copyWith({String? role, String? text, String? imageUrl}) {
    return ChatMessageEntity(
      role: role ?? this.role,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageEntity &&
          other.role == role &&
          other.text == text &&
          other.imageUrl == imageUrl;

  @override
  int get hashCode => Object.hash(role, text, imageUrl);

  @override
  String toString() =>
      'ChatMessageEntity(role: $role, text: $text, imageUrl: $imageUrl)';
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

  const ChatResponseDataEntity({
    required this.reply,
    this.imageUrl,
  });

  factory ChatResponseDataEntity.fromJson(Map<String, dynamic> json) {
    return ChatResponseDataEntity(
      reply: json['reply'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'reply': reply,
        'image_url': imageUrl,
      };

  @override
  String toString() =>
      'ChatResponseDataEntity(reply: $reply, imageUrl: $imageUrl)';
}
