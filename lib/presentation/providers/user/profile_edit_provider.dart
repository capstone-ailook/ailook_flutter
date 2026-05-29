import 'dart:io';

import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/media/media.dart';
import 'package:ailook_flutter/features/user/user.dart';
import 'package:ailook_flutter/presentation/providers/user/user_info_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.g.dart';

class ProfileEditState {
  final String nickname;
  final String gender;
  final String age;
  final double height;
  final double weight;
  final File? pickedImage;
  final String? photoUrl;
  final bool isLoading;
  final String? error;

  ProfileEditState({
    this.nickname = '',
    this.gender = '남성',
    this.age = '20대',
    this.height = 170.0,
    this.weight = 60.0,
    this.pickedImage,
    this.photoUrl,
    this.isLoading = false,
    this.error,
  });

  ProfileEditState copyWith({
    String? nickname,
    String? gender,
    String? age,
    double? height,
    double? weight,
    File? pickedImage,
    String? photoUrl,
    bool? isLoading,
    String? error,
  }) {
    return ProfileEditState(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      pickedImage: pickedImage ?? this.pickedImage,
      photoUrl: photoUrl ?? this.photoUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class ProfileEdit extends _$ProfileEdit {
  final _picker = ImagePicker();

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
        photoUrl: userInfo.photoUrl,
      );
    }
    return ProfileEditState();
  }

  void updateNickname(String val) => state = state.copyWith(nickname: val);
  void updateGender(String val) => state = state.copyWith(gender: val);
  void updateAge(String val) => state = state.copyWith(age: val);
  void updateHeight(double val) => state = state.copyWith(height: val);
  void updateWeight(double val) => state = state.copyWith(weight: val);

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 512);
    if (image != null) {
      state = state.copyWith(pickedImage: File(image.path));
    }
  }

  Future<bool> save() async {
    if (state.nickname.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter a nickname');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      String? finalPhotoUrl = state.photoUrl;

      if (state.pickedImage != null) {
        final mediaRepo = locator<MediaRepository>();
        final uploadResult = await mediaRepo.uploadImage(state.pickedImage!);
        finalPhotoUrl = uploadResult.fold(
          onSuccess: (url) => url,
          onFailure: (e) {
            state = state.copyWith(isLoading: false, error: 'Image upload failed: $e');
            return null;
          },
        );
        if (finalPhotoUrl == null) return false;
      }

      final entity = UserProfileEntity(
        gender: state.gender,
        height: state.height,
        weight: state.weight,
        age: state.age,
        nickname: state.nickname.trim(),
        photoUrl: finalPhotoUrl,
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
