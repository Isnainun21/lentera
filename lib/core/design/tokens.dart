import 'package:flutter/material.dart';

/// Token dari DOCSS/DESIGN.md. Kontras setiap pasangan tercatat di sana.
class AppColors {
  const AppColors._();

  static const ground = Color(0xFFF3F5F0);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF121A18);
  static const subInk = Color(0xFF4A5654);
  static const deep = Color(0xFF0E4C63);
  static const lantern = Color(0xFFFFC22E);
  static const lanternSoft = Color(0xFFFFE9A8);
  static const sky = Color(0xFF49A9EE);
  static const leaf = Color(0xFF35B779);
  static const ok = Color(0xFF0F6B45);
  static const okSoft = Color(0xFFD5F2E2);
  static const retry = Color(0xFF7A5600);
  static const retrySoft = Color(0xFFFFEFC2);
  static const letterB = Color(0xFF1D5C8C);
  static const letterD = Color(0xFF9A4A00);
  static const idle = Color(0xFFE7EBE5);

  static Color named(String name) => switch (name) {
        'sky' => sky,
        'leaf' => leaf,
        _ => lantern,
      };

  /// Avatar sementara: lingkaran warna dan inisial, sampai aset avatar ditentukan.
  static const avatars = [sky, leaf, lantern, Color(0xFFFF9F68), Color(0xFF7FD6C2), Color(0xFFB7A6F0)];
}

class AppText {
  const AppText._();

  // Lexend di project ini adalah font variabel, jadi berat harus lewat sumbu wght.
  static TextStyle _style(double size, int weight, double height, [double spacing = 0, Color color = AppColors.ink]) =>
      TextStyle(
        fontFamily: 'Lexend',
        fontSize: size,
        height: height,
        letterSpacing: spacing,
        color: color,
        fontWeight: FontWeight.values[(weight ~/ 100) - 1],
        fontVariations: [FontVariation('wght', weight.toDouble())],
      );

  static final wordHero = _style(72, 700, 1.05, 1.5);
  static final syllable = _style(34, 700, 1.15, 1.4);
  static final title = _style(30, 700, 1.2, -0.3);
  static final heading = _style(22, 600, 1.3);
  static final reading = _style(26, 500, 1.6, 0.8);
  static final body = _style(18, 400, 1.45);
  static final bodyStrong = _style(18, 600, 1.45);
  static final bodyGuardian = _style(16, 400, 1.45);
  static final caption = _style(14, 500, 1.4, 0, AppColors.subInk);
  static final metric = _style(32, 700, 1.1, -0.3);
}

class AppSpace {
  const AppSpace._();

  static const gutter = 20.0;
  static const cardRadius = 28.0;
  static const tileRadius = 20.0;
  static const tapChild = 56.0;
  static const tapGuardian = 48.0;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Lexend',
    scaffoldBackgroundColor: AppColors.ground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: Colors.white,
      secondary: AppColors.lantern,
      onSecondary: AppColors.ink,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: AppColors.retry,
    ),
    splashFactory: InkRipple.splashFactory,
  );
  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.ground,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.heading,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: AppText.bodyGuardian.copyWith(color: AppColors.subInk),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
        borderSide: const BorderSide(color: AppColors.ink, width: 2),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.ok : AppColors.idle),
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : AppColors.subInk),
      trackOutlineColor: WidgetStateProperty.all(AppColors.subInk),
    ),
    sliderTheme: const SliderThemeData(activeTrackColor: AppColors.ink, thumbColor: AppColors.ink, inactiveTrackColor: AppColors.idle),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.surface, titleTextStyle: AppText.heading, contentTextStyle: AppText.bodyGuardian),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: AppText.bodyGuardian.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
