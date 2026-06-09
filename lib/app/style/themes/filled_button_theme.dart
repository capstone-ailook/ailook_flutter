part of '../app_theme.dart';

abstract class _FilledButtonTheme {
  static final light = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColor().black,
      disabledBackgroundColor: AppColor().gray3,
      foregroundColor: AppColor().white,
      disabledForegroundColor: AppColor().white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyle.title1,
    ),
  );
}
