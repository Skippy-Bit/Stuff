import 'package:flutter/material.dart';

class E7MRTheme {
  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFFEF5E7),
      100: Color(0xFFFDE6C2),
      200: Color(0xFFFCD599),
      300: Color(0xFFFBC470),
      400: Color(0xFFFAB752),
      500: Color(_primaryValue),
      600: Color(0xFFF8A32E),
      700: Color(0xFFF79927),
      800: Color(0xFFF69020),
      900: Color(0xFFF57F14),
    },
  );
  static const int _primaryValue = 0xFFF9AA33;

  static const MaterialColor secondary = MaterialColor(
    _secondaryValue,
    <int, Color>{
      50: Color(0xFFE7E9EB),
      100: Color(0xFFC2C8CC),
      200: Color(0xFF9AA4AA),
      300: Color(0xFF718088),
      400: Color(0xFF52646F),
      500: Color(_secondaryValue),
      600: Color(0xFF2F424E),
      700: Color(0xFF273944),
      800: Color(0xFF21313B),
      900: Color(0xFF15212A),
    },
  );
  static const int _secondaryValue = 0xFF344955;

  // Login gradient
  static const Color loginGradientStart = const Color(_secondaryValue);
  static const Color loginGradientEnd = const Color(_secondaryValue);
  // static const Color loginGradientStart = const Color(0xFFC2C8CC);
  // static const Color loginGradientEnd = const Color(0xFF52646F);

  static const loginPrimaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
