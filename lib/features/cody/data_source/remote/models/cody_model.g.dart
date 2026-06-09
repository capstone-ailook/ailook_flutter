// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cody_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodyModel _$CodyModelFromJson(Map<String, dynamic> json) => CodyModel(
      id: (json['id'] as num).toInt(),
      user: (json['user'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      top: (json['top'] as num?)?.toInt(),
      bottom: (json['bottom'] as num?)?.toInt(),
      shoes: (json['shoes'] as num?)?.toInt(),
      accessory: (json['accessory'] as num?)?.toInt(),
      topDetail: json['top_detail'] == null
          ? null
          : ItemModel.fromJson(json['top_detail'] as Map<String, dynamic>),
      bottomDetail: json['bottom_detail'] == null
          ? null
          : ItemModel.fromJson(json['bottom_detail'] as Map<String, dynamic>),
      shoesDetail: json['shoes_detail'] == null
          ? null
          : ItemModel.fromJson(json['shoes_detail'] as Map<String, dynamic>),
      accessoryDetail: json['accessory_detail'] == null
          ? null
          : ItemModel.fromJson(
              json['accessory_detail'] as Map<String, dynamic>),
      isFavorite: json['is_favorite'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$CodyModelToJson(CodyModel instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'tags': instance.tags,
      'top': instance.top,
      'bottom': instance.bottom,
      'shoes': instance.shoes,
      'accessory': instance.accessory,
      'top_detail': instance.topDetail?.toJson(),
      'bottom_detail': instance.bottomDetail?.toJson(),
      'shoes_detail': instance.shoesDetail?.toJson(),
      'accessory_detail': instance.accessoryDetail?.toJson(),
      'is_favorite': instance.isFavorite,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CodyFavoriteResponse _$CodyFavoriteResponseFromJson(
        Map<String, dynamic> json) =>
    CodyFavoriteResponse(
      isFavorite: json['is_favorite'] as bool,
    );

Map<String, dynamic> _$CodyFavoriteResponseToJson(
        CodyFavoriteResponse instance) =>
    <String, dynamic>{
      'is_favorite': instance.isFavorite,
    };
