import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.g.dart';

class ItemResponse {
  final List<ItemModel> results;

  ItemResponse({required this.results});

  factory ItemResponse.fromJson(dynamic json) {
    if (json == null) return ItemResponse(results: []);
    
    if (json is Map<String, dynamic>) {
      final results = json['results'];
      if (results is List) {
        return ItemResponse(
          results: results
              .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      // If it's a map but doesn't have 'results', it might be a single item? 
      // (Depends on API spec, but safety first)
      return ItemResponse(results: []);
    }
    
    if (json is List) {
      return ItemResponse(
        results: json
            .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    
    return ItemResponse(results: []);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ItemModel {
  final int id;
  final int? user;
  final String name;
  final String category;
  final String kind;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  ItemModel({
    required this.id,
    this.user,
    required this.name,
    required this.category,
    required this.kind,
    required this.description,
    this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}
