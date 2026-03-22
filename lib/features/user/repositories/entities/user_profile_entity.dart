import 'package:ailook_flutter/features/user/data_source/remote/models/user_profile_model.dart';

class UserProfileResponseEntity {
  /// 유저 존재 여부
  final bool exists;

  /// 유저 프로필
  final UserProfileEntity? profile;

  UserProfileResponseEntity({required this.exists, required this.profile});

  factory UserProfileResponseEntity.fromModel(UserProfileResponse model) {
    return UserProfileResponseEntity(
      exists: model.exists,
      profile: model.profile != null ? UserProfileEntity.fromModel(model.profile!) : null,
    );
  }
}

class UserProfileEntity {
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

  UserProfileEntity({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.nickname,
  });

  factory UserProfileEntity.fromModel(UserProfileModel model) {
    return UserProfileEntity(
      gender: model.gender,
      height: model.height,
      weight: model.weight,
      age: model.age,
      nickname: model.nickname,
    );
  }
}
