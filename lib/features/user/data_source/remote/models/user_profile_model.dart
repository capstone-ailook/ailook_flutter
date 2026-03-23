import 'package:ailook_flutter/features/user/repositories/entities/user_profile_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserProfileResponse {
  /// 유저 존재 여부
  final bool exists;

  /// 유저 프로필
  final UserProfileModel? profile;

  UserProfileResponse({required this.exists, required this.profile});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return _$UserProfileResponseFromJson(json);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserProfileModel {
  /// 유저 성별
  final String gender;

  /// 유저 키
  final double height;

  /// 유저 체중
  final double weight;

  /// 유저 나이
  final String age;

  /// 유저 닉네임
  final String nickname;

  UserProfileModel({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.nickname,
  });

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      gender: entity.gender,
      height: entity.height,
      weight: entity.weight,
      age: entity.age,
      nickname: entity.nickname,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return _$UserProfileModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
