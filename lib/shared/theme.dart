import 'package:flutter/material.dart';

/// App colors — light and dark theme palettes
/// Exact match of React Native theme/index.ts
class AppColors {
  // Light theme
  static const light = AppColorScheme(
    primary: Color(0xFF6366F1),
    primaryLight: Color(0xFF818CF8),
    primaryDark: Color(0xFF4F46E5),
    accent: Color(0xFFF59E0B),
    accentLight: Color(0xFFFBBF24),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF1F5F9),
    text: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textTertiary: Color(0xFF94A3B8),
    border: Color(0xFFE2E8F0),
    error: Color(0xFFEF4444),
    success: Color(0xFF22C55E),
    rating: Color(0xFFF59E0B),
    skeleton: Color(0xFFE2E8F0),
    skeletonHighlight: Color(0xFFF1F5F9),
    overlay: Color(0x80000000),
    cardShadow: Color(0x140F172A),
  );

  // Dark theme
  static const dark = AppColorScheme(
    primary: Color(0xFF818CF8),
    primaryLight: Color(0xFFA5B4FC),
    primaryDark: Color(0xFF6366F1),
    accent: Color(0xFFFBBF24),
    accentLight: Color(0xFFFCD34D),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF334155),
    text: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    border: Color(0xFF334155),
    error: Color(0xFFF87171),
    success: Color(0xFF4ADE80),
    rating: Color(0xFFFBBF24),
    skeleton: Color(0xFF334155),
    skeletonHighlight: Color(0xFF475569),
    overlay: Color(0xB3000000),
    cardShadow: Color(0x4D000000),
  );
}

class AppColorScheme {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color accent;
  final Color accentLight;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color error;
  final Color success;
  final Color rating;
  final Color skeleton;
  final Color skeletonHighlight;
  final Color overlay;
  final Color cardShadow;

  const AppColorScheme({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.accent,
    required this.accentLight,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.error,
    required this.success,
    required this.rating,
    required this.skeleton,
    required this.skeletonHighlight,
    required this.overlay,
    required this.cardShadow,
  });
}

/// Typography styles — exact match of React Native Typography
class AppTypography {
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 36 / 28,
  );

  static const h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 28 / 22,
  );

  static const h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 24 / 18,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 22 / 16,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 16 / 12,
  );

  static const caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 14 / 11,
  );

  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 20 / 15,
  );
}

/// Spacing values
class Spacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

/// Border radius values
class AppBorderRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 9999;
}
