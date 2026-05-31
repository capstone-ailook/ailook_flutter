// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    UserProfileResponse(
      exists: json['exists'] as bool,
      profile: json['profile'] == null
          ? null
          : UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileResponseToJson(
        UserProfileResponse instance) =>
    <String, dynamic>{
      'exists': instance.exists,
      'profile': instance.profile?.toJson(),
    };

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      gender: json['gender'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      age: json['age'] as String,
      nickname: json['nickname'] as String,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'height': instance.height,
      'weight': instance.weight,
      'age': instance.age,
      'nickname': instance.nickname,
      'photo_url': instance.photoUrl,
    };
