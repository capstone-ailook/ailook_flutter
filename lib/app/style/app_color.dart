import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  static final AppColor _light = AppColor._(
    white: const Color(0xFFFFFFFF),
    black: const Color(0xFF09090B),
    gray1: const Color(0xFFECECF2),
    gray2: const Color(0xFFDCDCE9),
    gray3: const Color(0xFFA2A2B2),
    gray4: const Color(0xFF71717E),
    gray5: const Color(0xFF42424A),
    gray6: const Color(0xFF282831),
    gray7: const Color(0xFF09090B),
    background1: const Color(0xFFF6F6F9),
  );

  static final AppColor _dark = AppColor._(
    white: const Color(0xFFFFFFFF),
    black: const Color(0xFF09090B),
    gray1: const Color(0xFFECECF2),
    gray2: const Color(0xFFDCDCE9),
    gray3: const Color(0xFFA2A2B2),
    gray4: const Color(0xFF71717E),
    gray5: const Color(0xFF42424A),
    gray6: const Color(0xFF282831),
    gray7: const Color(0xFF09090B),
    background1: const Color(0xFFF6F6F9),
  );
  factory AppColor() => _light;

  AppColor._({
    required this.white,
    required this.black,
    required this.gray1,
    required this.gray2,
    required this.gray3,
    required this.gray4,
    required this.gray5,
    required this.gray6,
    required this.gray7,
    required this.background1,
  });

  factory AppColor.dark() => _dark;

  final Color white;
  final Color black;
  final Color gray1;
  final Color gray2;
  final Color gray3;
  final Color gray4;
  final Color gray5;
  final Color gray6;
  final Color gray7;
  final Color background1;

  static late BuildContext _context;
  static void init(BuildContext context) => _context = context;

  static AppColor get of => Theme.of(_context).extension<AppColor>()!;
  static AppColor? get maybeOf => Theme.of(_context).extension<AppColor>();

  @override
  ThemeExtension<AppColor> copyWith({
    Color? white,
    Color? black,
    Color? gray1,
    Color? gray2,
    Color? gray3,
    Color? gray4,
    Color? gray5,
    Color? gray6,
    Color? gray7,
    Color? background1,
  }) {
    return AppColor._(
      white: white ?? this.white,
      black: black ?? this.black,
      gray1: gray1 ?? this.gray1,
      gray2: gray2 ?? this.gray2,
      gray3: gray3 ?? this.gray3,
      gray4: gray4 ?? this.gray4,
      gray5: gray5 ?? this.gray5,
      gray6: gray6 ?? this.gray6,
      gray7: gray7 ?? this.gray7,
      background1: background1 ?? this.background1,
    );
  }

  @override
  ThemeExtension<AppColor> lerp(
    covariant ThemeExtension<AppColor>? other,
    double t,
  ) {
    if (other is! AppColor) {
      return this;
    }
    return AppColor._(
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      gray1: Color.lerp(gray1, other.gray1, t)!,
      gray2: Color.lerp(gray2, other.gray2, t)!,
      gray3: Color.lerp(gray3, other.gray3, t)!,
      gray4: Color.lerp(gray4, other.gray4, t)!,
      gray5: Color.lerp(gray5, other.gray5, t)!,
      gray6: Color.lerp(gray6, other.gray6, t)!,
      gray7: Color.lerp(gray7, other.gray7, t)!,
      background1: Color.lerp(background1, other.background1, t)!,
    );
  }
}
