part of '../app_theme.dart';

abstract class _OutlinedButtonTheme {
  static final light = OutlinedButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColor().white,
      disabledBackgroundColor: AppColor().white,
      foregroundColor: AppColor().black,
      disabledForegroundColor: AppColor().gray3,
      elevation: 0,
      side: BorderSide(color: AppColor().black),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyle.title1.copyWith(
        color: AppColor().black,
      ),
    ),
  );
}
