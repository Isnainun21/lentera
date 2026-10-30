import 'package:flutter/material.dart';

/// Token dari DOCSS/DESIGN.md. Kontras setiap pasangan tercatat di sana.
class AppColors {
  const AppColors._();

  static const ground = Color(0xFFDDE6E3);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1B2422);
  static const subInk = Color(0xFF46524F);
  static const lantern = Color(0xFFEFC75E);
  static const lanternSoft = Color(0xFFFBF0CE);
  static const sky = Color(0xFF8FB6C9);
  static const leaf = Color(0xFF7DB58F);
  static const ok = Color(0xFF1E6B46);
  static const okSoft = Color(0xFFDCEFE3);
  static const retry = Color(0xFF7A5600);
  static const retrySoft = Color(0xFFF7EBCB);
  static const letterB = Color(0xFF1D5C8C);
  static const letterD = Color(0xFF9A4A00);
  static const idle = Color(0xFFEDF2F0);

  static Color named(String name) => switch (name) {
        'sky' => sky,
        'leaf' => leaf,
        _ => lantern,
      };

  /// Avatar sementara: lingkaran warna dan inisial, sampai aset avatar ditentukan.
  static const avatars = [sky, leaf, lantern, Color(0xFFC9B7A6), Color(0xFFA9C4BE), Color(0xFFD6C27F)];
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

  static final wordHero = _style(60, 700, 1.1, 2.4);
  static final syllable = _style(34, 700, 1.15, 1.4);
  static final title = _style(28, 700, 1.25);
  static final heading = _style(22, 600, 1.3);
  static final reading = _style(22, 500, 1.7, 0.88);
  static final body = _style(18, 400, 1.45);
  static final bodyStrong = _style(18, 600, 1.45);
  static final bodyGuardian = _style(16, 400, 1.45);
  static final caption = _style(14, 500, 1.4, 0, AppColors.subInk);
  static final metric = _style(30, 700, 1.15);
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
