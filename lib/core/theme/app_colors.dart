import 'package:flutter/material.dart';

/// Defines all the colors used in the Dhukuti app.
class AppColors {
  AppColors._();

  // Base Colors
  static const Color canvas = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color mutedSurface = Color(0xFFF5F5F5);
  static const Color numpadKey = Color(0xFFF8F8F8);
  static const Color border = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFF3F3F3);
  static const Color lightDivider = Color(0xFFF5F5F5);
  static const Color lightDivider2 = Color(0xFFF8F8F8);

  // Text Colors
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF333333);
  static const Color textTertiary = Color(0xFF555555);
  static const Color textQuaternary = Color(0xFF666666);
  static const Color textMuted = Color(0xFF888888);
  static const Color textLabel = Color(0xFF999999);
  static const Color textPlaceholder = Color(0xFFAAAAAA);
  static const Color textDisabled = Color(0xFFBBBBBB);
  static const Color textFaded = Color(0xFFCCCCCC);
  static const Color textVeryFaded = Color(0xFFDDDDDD);

  // Semantic Colors
  static const Color success = Color(0xFF34C759);
  static const Color successBg = Color(0xFFE8F9E8);
  static const Color danger = Color(0xFFFF3B5C);
  static const Color dangerBg = Color(0xFFFFEEEE);
  static const Color dangerBgLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF007AFF);
  static const Color warning = Color(0xFFFFD60A);
  static const Color accentPurple = Color(0xFFAF52DE);

  // User-Selectable Palette
  static const List<Color> selectablePalette = [
    Color(0xFFFF3B5C),
    Color(0xFFFF8C00),
    Color(0xFF34C759),
    Color(0xFF007AFF),
    Color(0xFFAF52DE),
    Color(0xFFFF69B4),
    Color(0xFFFFD60A),
    Color(0xFF5856D6),
    Color(0xFFFF6B6B),
    Color(0xFF00C9A7),
  ];

  // Hero Gradient Colors
  static const Color heroGradientStart = Color(0xFF0A0A1A);
  static const Color heroGradientMid = Color(0xFF1A1A2E);
  static const Color heroGradientEnd = Color(0xFF16213E);
  static const Color heroPurpleGlow = Color.fromRGBO(175, 82, 222, 0.35);
  static const Color heroBlueGlow = Color.fromRGBO(0, 122, 255, 0.25);
}
