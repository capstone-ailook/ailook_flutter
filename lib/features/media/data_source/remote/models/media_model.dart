import 'package:json_annotation/json_annotation.dart';

part 'media_model.g.dart';

@JsonSerializable()
class MediaUploadResponse {
  @JsonKey(name: 'image_url')
  final String imageUrl;

  MediaUploadResponse({required this.imageUrl});

  factory MediaUploadResponse.fromJson(Map<String, dynamic> json) => _$MediaUploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MediaUploadResponseToJson(this);
}
