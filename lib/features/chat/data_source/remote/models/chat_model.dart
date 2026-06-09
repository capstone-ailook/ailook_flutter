import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class OutfitModel {
  final String image;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final double score;
  final String? substyle;
  @JsonKey(name: 'caption_snippet')
  final String? captionSnippet;

  OutfitModel({
    required this.image,
    required this.imageUrl,
    required this.score,
    this.substyle,
    this.captionSnippet,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) =>
      _$OutfitModelFromJson(json);

  Map<String, dynamic> toJson() => _$OutfitModelToJson(this);
}

@JsonSerializable()
class ChatSessionResponse {
  final List<ChatSessionModel> sessions;

  ChatSessionResponse({required this.sessions});

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatSessionModel {
  final int id;
  final String? title;
  final String? createdAt;

  ChatSessionModel({
    required this.id,
    this.title,
    this.createdAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatMessageModel {
  final String role;
  final String text;
  final String? imageUrl;
  @JsonKey(defaultValue: <OutfitModel>[])
  final List<OutfitModel> outfits;
  final int? anchorItemId;
  final String? anchorCategory;

  ChatMessageModel({
    required this.role,
    required this.text,
    this.imageUrl,
    this.outfits = const [],
    this.anchorItemId,
    this.anchorCategory,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}

@JsonSerializable()
class ChatSessionDetailResponse {
  final List<ChatMessageModel> messages;

  ChatSessionDetailResponse({required this.messages});

  factory ChatSessionDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionDetailResponseToJson(this);
}

@JsonSerializable()
class ChatResponseModel {
  final String reply;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(defaultValue: <OutfitModel>[])
  final List<OutfitModel> outfits;
  @JsonKey(name: 'anchor_item_id')
  final int? anchorItemId;
  @JsonKey(name: 'anchor_category')
  final String? anchorCategory;

  ChatResponseModel({
    required this.reply,
    this.imageUrl,
    this.outfits = const [],
    this.anchorItemId,
    this.anchorCategory,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseModelToJson(this);
}
