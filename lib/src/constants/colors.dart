import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor mainColor = MaterialColor(
    _mainPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(_mainPrimaryValue),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
  static const int _mainPrimaryValue = 0xFFFF6D6D;
  static Color secondColor = const Color(0xffe5e5e5);
  static const titleColor = Color(0xff283238);
  static const secondTitleColor = Color(0xffffffff);
  static const textColor = Color(0xff081D30);
  static const hintTextColor = Color(0xffC4C4C4);
  static const labelColor = Color(0xffA8A8A8);
}