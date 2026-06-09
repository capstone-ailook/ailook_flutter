import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/models/item_model.dart';

part 'cody_model.g.dart';

class CodyResponse {
  final List<CodyModel> results;

  CodyResponse({required this.results});

  factory CodyResponse.fromJson(dynamic json) {
    if (json == null) return CodyResponse(results: []);

    if (json is Map<String, dynamic>) {
      final results = json['results'];
      if (results is List) {
        return CodyResponse(
          results: results
              .map((e) => CodyModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return CodyResponse(results: []);
    }

    if (json is List) {
      return CodyResponse(
        results: json
            .map((e) => CodyModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    return CodyResponse(results: []);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CodyModel {
  final int id;
  final int? user;
  final String name;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  
  final int? top;
  final int? bottom;
  final int? shoes;
  final int? accessory;
  
  @JsonKey(name: 'top_detail')
  final ItemModel? topDetail;
  @JsonKey(name: 'bottom_detail')
  final ItemModel? bottomDetail;
  @JsonKey(name: 'shoes_detail')
  final ItemModel? shoesDetail;
  @JsonKey(name: 'accessory_detail')
  final ItemModel? accessoryDetail;

  final bool isFavorite;
  final String createdAt;
  final String updatedAt;

  CodyModel({
    required this.id,
    this.user,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.tags,
    this.top,
    this.bottom,
    this.shoes,
    this.accessory,
    this.topDetail,
    this.bottomDetail,
    this.shoesDetail,
    this.accessoryDetail,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CodyModel.fromJson(Map<String, dynamic> json) => _$CodyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodyModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CodyFavoriteResponse {
  final bool isFavorite;

  CodyFavoriteResponse({required this.isFavorite});

  factory CodyFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$CodyFavoriteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CodyFavoriteResponseToJson(this);
}
