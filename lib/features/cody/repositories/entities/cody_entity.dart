import 'package:ailook_flutter/features/cody/data_source/remote/models/cody_model.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/item_entity.dart';

class CodyListEntity {
  final List<CodyEntity> codies;

  CodyListEntity({required this.codies});

  factory CodyListEntity.fromModel(CodyResponse model) {
    return CodyListEntity(
      codies: model.results.map((e) => CodyEntity.fromModel(e)).toList(),
    );
  }
}

class CodyEntity {
  final int id;
  final int? user;
  final String name;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  
  final int? topId;
  final int? bottomId;
  final int? shoesId;
  final int? accessoryId;
  
  final ItemEntity? top;
  final ItemEntity? bottom;
  final ItemEntity? shoes;
  final ItemEntity? accessory;

  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  CodyEntity({
    required this.id,
    this.user,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.tags,
    this.topId,
    this.bottomId,
    this.shoesId,
    this.accessoryId,
    this.top,
    this.bottom,
    this.shoes,
    this.accessory,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CodyEntity.fromModel(CodyModel model) {
    return CodyEntity(
      id: model.id,
      user: model.user,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      tags: model.tags,
      topId: model.top,
      bottomId: model.bottom,
      shoesId: model.shoes,
      accessoryId: model.accessory,
      top: model.topDetail != null
          ? ItemEntity.fromModel(model.topDetail!)
          : null,
      bottom: model.bottomDetail != null
          ? ItemEntity.fromModel(model.bottomDetail!)
          : null,
      shoes: model.shoesDetail != null
          ? ItemEntity.fromModel(model.shoesDetail!)
          : null,
      accessory: model.accessoryDetail != null
          ? ItemEntity.fromModel(model.accessoryDetail!)
          : null,
      isFavorite: model.isFavorite,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
    );
  }

  CodyEntity copyWith({
    int? id,
    int? user,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? tags,
    int? topId,
    int? bottomId,
    int? shoesId,
    int? accessoryId,
    ItemEntity? top,
    ItemEntity? bottom,
    ItemEntity? shoes,
    ItemEntity? accessory,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CodyEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      topId: topId ?? this.topId,
      bottomId: bottomId ?? this.bottomId,
      shoesId: shoesId ?? this.shoesId,
      accessoryId: accessoryId ?? this.accessoryId,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      shoes: shoes ?? this.shoes,
      accessory: accessory ?? this.accessory,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
