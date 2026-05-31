// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      id: (json['id'] as num).toInt(),
      user: (json['user'] as num?)?.toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      kind: json['kind'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'name': instance.name,
      'category': instance.category,
      'kind': instance.kind,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'tags': instance.tags,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
