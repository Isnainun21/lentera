import 'package:flutter/material.dart';

/// Token warna & tipografi dari `stitch_dyslexia_adaptive_reading_app/lentera_membaca/DESIGN.md`.
class AppColors {
  const AppColors._();

  // ──── Surface System ────
  static const surface = Color(0xFFF9F9FD);
  static const surfaceLowest = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF3F3F7);
  static const surfaceContainer = Color(0xFFEDEDF1);
  static const surfaceHigh = Color(0xFFE8E8EC);
  static const surfaceHighest = Color(0xFFE2E2E6);

  // ──── On-Surface (Text) ────
  static const onSurface = Color(0xFF1A1C1F);
  static const onSurfaceVariant = Color(0xFF3C4947);
  static const outline = Color(0xFF6C7A77);
  static const outlineVariant = Color(0xFFBBCAC6);

  // ──── Primary (Mint Teal) ────
  static const primary = Color(0xFF006A61);
  static const primaryContainer = Color(0xFF38C6B6);
  static const onPrimaryContainer = Color(0xFF004E46);
  static const primaryFixed = Color(0xFF74F8E6);
  static const primaryFixedDim = Color(0xFF53DBCA);
  static const primaryTint = Color(0xFFE6F9F7);

  // ──── Secondary (Warm Coral Red) ────
  static const secondary = Color(0xFFAE2F34);
  static const secondaryContainer = Color(0xFFFF6B6B);
  static const onSecondaryContainer = Color(0xFF6D0010);
  static const secondaryFixed = Color(0xFFFFDAD8);

  // ──── Tertiary (Sunny Butter Yellow) ────
  static const tertiary = Color(0xFF745B00);
  static const tertiaryContainer = Color(0xFFD8AD0D);
  static const tertiaryFixed = Color(0xFFFFE08A);
  static const sunnyButter = Color(0xFFFFD13B);

  // ──── Error ────
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);

  // ──── Special ────
  static const softLavender = Color(0xFFE6E0F8);
  static const lavenderShadow = Color(0xFFD0C6EF);
  static const softPeach = Color(0xFFFFF3EB);
  static const canvasIvory = Color(0xFFF8F5F0);

  // ──── Warna Huruf Discriminasi ────
  static const hurufB = Color(0xFF2196F3); // Biru untuk b
  static const hurufD = Color(0xFFFF6B6B); // Merah/Oranye untuk d
  static const hurufP = Color(0xFF9C27B0); // Ungu untuk p
  static const hurufQ = Color(0xFFFF9800); // Oranye untuk q

  // ──── Bayangan ────
  static const shadowTeal = Color(0xFF289F92);
  static const shadowGold = Color(0xFFD8AD0D);
}

/// Skala tipografi Lexend (DESIGN.md).
class AppText {
  const AppText._();

  static const _lexend = 'Lexend';

  static const headlineXlMobile = TextStyle(
      fontFamily: _lexend, fontSize: 30, height: 40 / 30, fontWeight: FontWeight.w800, letterSpacing: 0.02 * 30, color: AppColors.onSurface);
  static const headlineLgMobile = TextStyle(
      fontFamily: _lexend, fontSize: 24, height: 34 / 24, fontWeight: FontWeight.w700, letterSpacing: 0.02 * 24, color: AppColors.onSurface);
  static const headlineMd = TextStyle(
      fontFamily: _lexend, fontSize: 22, height: 32 / 22, fontWeight: FontWeight.w700, letterSpacing: 0.015 * 22, color: AppColors.onSurface);
  static const headlineSm = TextStyle(
      fontFamily: _lexend, fontSize: 18, height: 28 / 18, fontWeight: FontWeight.w600, letterSpacing: 0.015 * 18, color: AppColors.onSurface);
  static const bodyReadingLg = TextStyle(
      fontFamily: _lexend, fontSize: 22, height: 38 / 22, fontWeight: FontWeight.w500, letterSpacing: 0.04 * 22, color: AppColors.onSurface);
  static const bodyReadingMd = TextStyle(
      fontFamily: _lexend, fontSize: 18, height: 32 / 18, fontWeight: FontWeight.w500, letterSpacing: 0.035 * 18, color: AppColors.onSurface);
  static const bodyLg = TextStyle(
      fontFamily: _lexend, fontSize: 16, height: 26 / 16, fontWeight: FontWeight.w400, letterSpacing: 0.01 * 16, color: AppColors.onSurfaceVariant);
  static const bodyMd = TextStyle(
      fontFamily: _lexend, fontSize: 14, height: 22 / 14, fontWeight: FontWeight.w400, letterSpacing: 0.01 * 14, color: AppColors.onSurfaceVariant);
  static const labelLg = TextStyle(
      fontFamily: _lexend, fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w700, letterSpacing: 0.03 * 15, color: AppColors.onSurface);
  static const labelMd = TextStyle(
      fontFamily: _lexend, fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w600, letterSpacing: 0.025 * 13, color: AppColors.onSurfaceVariant);
  static const labelSm = TextStyle(
      fontFamily: _lexend, fontSize: 11, height: 16 / 11, fontWeight: FontWeight.w700, letterSpacing: 0.04 * 11, color: AppColors.onSurfaceVariant);
  static const syllableDisplay = TextStyle(
      fontFamily: _lexend, fontSize: 26, height: 34 / 26, fontWeight: FontWeight.w700, letterSpacing: 0.08 * 26, color: AppColors.onSurface);

  /// RA-PRD-601: opsi memperbesar ukuran huruf.
  static TextStyle scale(TextStyle base, double skala) => base.copyWith(
        fontSize: base.fontSize! * skala,
      );
}

class AppRadius {
  const AppRadius._();

  static const card = 24.0;
  static const tile = 16.0;
  static const pill = 9999.0;
  static const cardLg = 28.0;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: const ColorScheme.light(
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          primary: AppColors.primary,
          secondary: AppColors.primaryContainer,
          error: AppColors.error,
        ),
        fontFamily: 'Lexend',
        splashFactory: InkSparkle.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppText.headlineMd,
          iconTheme: IconThemeData(color: AppColors.onSurface),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.outlineVariant, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.primaryContainer, width: 2.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          hintStyle: AppText.bodyReadingMd.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      );
}