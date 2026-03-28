import 'package:ailook_flutter/features/user/user.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.g.dart';

class ProfileEditState {
  final String nickname;
  final String gender;
  final String age;
  final double height;
  final double weight;
  final bool isLoading;
  final String? error;

  ProfileEditState({
    this.nickname = '',
    this.gender = '남성',
    this.age = '20대',
    this.height = 170.0,
    this.weight = 60.0,
    this.isLoading = false,
    this.error,
  });

  ProfileEditState copyWith({
    String? nickname,
    String? gender,
    String? age,
    double? height,
    double? weight,
    bool? isLoading,
    String? error,
  }) {
    return ProfileEditState(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class ProfileEdit extends _$ProfileEdit {
  @override
  ProfileEditState build() {
    final userInfo = ref.watch(userInfoProvider).asData?.value?.profile;
    if (userInfo != null) {
      return ProfileEditState(
        nickname: userInfo.nickname,
        gender: userInfo.gender,
        age: userInfo.age,
        height: userInfo.height,
        weight: userInfo.weight,
      );
    }
    return ProfileEditState();
  }

  void updateNickname(String val) => state = state.copyWith(nickname: val);
  void updateGender(String val) => state = state.copyWith(gender: val);
  void updateAge(String val) => state = state.copyWith(age: val);
  void updateHeight(double val) => state = state.copyWith(height: val);
  void updateWeight(double val) => state = state.copyWith(weight: val);

  Future<bool> save() async {
    if (state.nickname.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter a nickname');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final entity = UserProfileEntity(
        gender: state.gender,
        height: state.height,
        weight: state.weight,
        age: state.age,
        nickname: state.nickname.trim(),
      );

      final result = await submitUserProfileUseCase.call(entity);

      return result.fold(
        onSuccess: (_) {
          state = state.copyWith(isLoading: false);
          ref.invalidate(userInfoProvider);
          return true;
        },
        onFailure: (e) {
          state = state.copyWith(isLoading: false, error: 'Save failed: $e');
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
