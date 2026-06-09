import 'package:ailook_flutter/features/cody/data_source/remote/models/item_model.dart';

class ItemListEntity {
  final List<ItemEntity> items;

  ItemListEntity({required this.items});

  factory ItemListEntity.fromModel(ItemResponse model) {
    return ItemListEntity(
      items: model.results.map((e) => ItemEntity.fromModel(e)).toList(),
    );
  }
}

class ItemEntity {
  final int id;
  final int? user;
  final String name;
  final String category;
  final String kind;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemEntity({
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

  factory ItemEntity.fromModel(ItemModel model) {
    return ItemEntity(
      id: model.id,
      user: model.user,
      name: model.name,
      category: model.category,
      kind: model.kind,
      description: model.description,
      imageUrl: model.imageUrl,
      tags: model.tags,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
    );
  }
}
