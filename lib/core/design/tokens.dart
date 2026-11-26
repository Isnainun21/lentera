import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Tenun Kata. Lihat DOCSS/DESIGN.md untuk peran dan kontras setiap warna.
///
/// Benang punya warna tetap di kedua tema, karena teks di atasnya selalu tinta gelap.
class Thread {
  const Thread._();

  /// Baca Kata, juga bidang kata.
  static const kunyit = Color(0xFFF2B233);

  /// Beda Huruf.
  static const tarumMuda = Color(0xFF5B8DEF);

  /// Cerita.
  static const daun = Color(0xFF45B07E);

  /// Susun Suku Kata.
  static const jingga = Color(0xFFF39552);

  /// Hanya untuk hal yang sedang aktif: suku kata yang didengar, baris yang dibaca.
  static const kesumba = Color(0xFFF07A98);

  /// Dengar dan Pilih.
  static const laut = Color(0xFF4FB8C6);

  /// Tombol utama terang dan tinta pinggir kain.
  static const tarum = Color(0xFF1E2A5E);

  /// Tinta di atas benang. Sama di terang dan gelap.
  static const onThread = Color(0xFF0F1430);

  static const all = [kunyit, tarumMuda, daun, jingga, laut];

  static Color forKind(String kind) => switch (kind) {
        'letters' => tarumMuda,
        'build' => jingga,
        'listen' => laut,
        'story' => daun,
        _ => kunyit,
      };

  static Color named(String name) => switch (name) {
        'sky' => tarumMuda,
        'leaf' => daun,
        'orange' => jingga,
        // Kesumba dicadangkan untuk keadaan aktif, jadi warna cerita 'pink' memakai laut.
        'pink' => laut,
        _ => kunyit,
      };
}

/// Warna yang berubah antara terang dan gelap. Ambil lewat `Pal.of(context)`.
@immutable
class Pal extends ThemeExtension<Pal> {
  const Pal({
    required this.ground,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.subInk,
    required this.line,
    required this.primary,
    required this.onPrimary,
    required this.ok,
    required this.okSoft,
    required this.retry,
    required this.retrySoft,
    required this.letterB,
    required this.letterD,
    required this.empty,
  });

  final Color ground;
  final Color surface;
  final Color surfaceAlt;
  final Color ink;
  final Color subInk;
  final Color line;
  final Color primary;
  final Color onPrimary;
  final Color ok;
  final Color okSoft;
  final Color retry;
  final Color retrySoft;
  final Color letterB;
  final Color letterD;

  /// Slot benang yang belum terisi.
  final Color empty;

  static const light = Pal(
    ground: Color(0xFFEEF1F8),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFE1E6F2),
    ink: Color(0xFF0F1430),
    subInk: Color(0xFF3C4466),
    line: Color(0xFFCBD2E4),
    primary: Thread.tarum,
    onPrimary: Color(0xFFFFFFFF),
    ok: Color(0xFF0F6B45),
    okSoft: Color(0xFFD5F2E2),
    retry: Color(0xFF7A5600),
    retrySoft: Color(0xFFFFEFC2),
    letterB: Color(0xFF1D4FA8),
    letterD: Color(0xFFA4470A),
    empty: Color(0xFFD3D9EA),
  );

  static const dark = Pal(
    ground: Color(0xFF0F1430),
    surface: Color(0xFF1A2147),
    surfaceAlt: Color(0xFF252D5A),
    ink: Color(0xFFF1F3FA),
    subInk: Color(0xFFB9BFDA),
    line: Color(0xFF39427A),
    primary: Thread.kunyit,
    onPrimary: Thread.onThread,
    ok: Color(0xFF6FD9A3),
    okSoft: Color(0xFF173F35),
    retry: Color(0xFFF2C062),
    retrySoft: Color(0xFF3D3420),
    letterB: Color(0xFF9DBBFF),
    letterD: Color(0xFFFFAE73),
    empty: Color(0xFF2E3768),
  );

  static Pal of(BuildContext context) => Theme.of(context).extension<Pal>()!;

  @override
  Pal copyWith() => this;

  @override
  Pal lerp(Pal? other, double t) {
    if (other == null) return this;
    Color m(Color a, Color b) => Color.lerp(a, b, t)!;
    return Pal(
      ground: m(ground, other.ground),
      surface: m(surface, other.surface),
      surfaceAlt: m(surfaceAlt, other.surfaceAlt),
      ink: m(ink, other.ink),
      subInk: m(subInk, other.subInk),
      line: m(line, other.line),
      primary: m(primary, other.primary),
      onPrimary: m(onPrimary, other.onPrimary),
      ok: m(ok, other.ok),
      okSoft: m(okSoft, other.okSoft),
      retry: m(retry, other.retry),
      retrySoft: m(retrySoft, other.retrySoft),
      letterB: m(letterB, other.letterB),
      letterD: m(letterD, other.letterD),
      empty: m(empty, other.empty),
    );
  }
}

/// Lapisan warna bacaan, pilihan pendamping. Beberapa pembaca disleksia lebih nyaman dengan latar berwarna.
enum ReadingTint {
  none('Tanpa warna', null, null),
  kuning('Kuning', Color(0xFFFFF3C4), Color(0xFF3A3416)),
  biru('Biru', Color(0xFFDCEBFF), Color(0xFF1C2D4D)),
  hijau('Hijau', Color(0xFFDDF5E6), Color(0xFF173A2A)),
  merahMuda('Merah muda', Color(0xFFFFE3EC), Color(0xFF45222F));

  const ReadingTint(this.label, this.light, this.dark);

  final String label;
  final Color? light;
  final Color? dark;

  Color? of(Brightness b) => b == Brightness.dark ? dark : light;
}

/// Tangga huruf. Warna diwarisi dari tema, jadi gaya ini aman di terang dan gelap.
class AppText {
  const AppText._();

  // Lexend di project ini adalah font variabel, jadi berat harus lewat sumbu wght.
  static TextStyle _style(double size, int weight, double height, [double spacing = 0]) => TextStyle(
        fontFamily: 'Lexend',
        fontSize: size,
        height: height,
        letterSpacing: spacing,
        fontWeight: FontWeight.values[(weight ~/ 100) - 1],
        fontVariations: [FontVariation('wght', weight.toDouble())],
      );

  static final wordHero = _style(72, 700, 1.05, 1.5);
  static final syllable = _style(34, 700, 1.15, 1.4);
  static final display = _style(40, 700, 1.1, -0.6);
  static final title = _style(28, 700, 1.2, -0.3);
  static final heading = _style(21, 650, 1.3);
  static final reading = _style(26, 500, 1.6, 0.8);
  static final body = _style(18, 400, 1.45);
  static final bodyStrong = _style(18, 600, 1.45);
  static final bodyGuardian = _style(16, 400, 1.45);
  static final label = _style(15, 600, 1.3);
  static final caption = _style(14, 500, 1.4);
  static final metric = _style(34, 700, 1.05, -0.5);
}

class AppSpace {
  const AppSpace._();

  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 24.0;
  static const s6 = 32.0;
  static const s7 = 48.0;

  static const gutter = 20.0;
  static const panelRadius = 16.0;
  static const tileRadius = 12.0;
  static const buttonRadius = 14.0;
  static const tapChild = 56.0;
  static const tapGuardian = 48.0;

  /// Lebar baca maksimal untuk layar lebar.
  static const readingWidth = 720.0;
  static const contentWidth = 1100.0;
}

class AppMotion {
  const AppMotion._();

  static const quick = Duration(milliseconds: 160);
  static const panel = Duration(milliseconds: 240);
  static const weave = Duration(milliseconds: 420);
  static const ease = Cubic(0.16, 1, 0.3, 1);
}

ThemeData buildTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? Pal.dark : Pal.light;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.primary,
    onPrimary: p.onPrimary,
    secondary: Thread.kunyit,
    onSecondary: Thread.onThread,
    secondaryContainer: p.surfaceAlt,
    onSecondaryContainer: p.ink,
    surface: p.surface,
    onSurface: p.ink,
    onSurfaceVariant: p.subInk,
    surfaceContainerLowest: p.surface,
    surfaceContainerLow: p.surface,
    surfaceContainer: p.surface,
    surfaceContainerHigh: p.surfaceAlt,
    surfaceContainerHighest: p.surfaceAlt,
    outline: p.subInk,
    outlineVariant: p.line,
    error: p.retry,
    onError: p.surface,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Lexend',
    colorScheme: scheme,
    scaffoldBackgroundColor: p.ground,
    splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
    extensions: [p],
  );
  final text = base.textTheme.apply(bodyColor: p.ink, displayColor: p.ink, fontFamily: 'Lexend');
  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.buttonRadius));
  return base.copyWith(
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: p.ground,
      foregroundColor: p.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.heading.copyWith(color: p.ink),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.surface,
      indicatorColor: Thread.kesumba,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      height: 76,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => AppText.caption.copyWith(
          color: s.contains(WidgetState.selected) ? p.ink : p.subInk,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(size: 26, color: s.contains(WidgetState.selected) ? Thread.onThread : p.subInk),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: p.surface,
      indicatorColor: Thread.kesumba,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      selectedIconTheme: const IconThemeData(size: 26, color: Thread.onThread),
      unselectedIconTheme: IconThemeData(size: 26, color: p.subInk),
      selectedLabelTextStyle: AppText.caption.copyWith(color: p.ink, fontWeight: FontWeight.w700),
      unselectedLabelTextStyle: AppText.caption.copyWith(color: p.subInk),
      labelType: NavigationRailLabelType.all,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
        disabledBackgroundColor: p.surfaceAlt,
        disabledForegroundColor: p.subInk,
        minimumSize: const Size.fromHeight(60),
        shape: buttonShape,
        textStyle: AppText.bodyStrong,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.ink,
        minimumSize: const Size(AppSpace.tapGuardian, AppSpace.tapGuardian),
        shape: buttonShape,
        textStyle: AppText.label,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surface,
      labelStyle: AppText.bodyGuardian.copyWith(color: p.subInk),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius), borderSide: BorderSide(color: p.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius), borderSide: BorderSide(color: p.line)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
        borderSide: BorderSide(color: p.ink, width: 2),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.ok : p.surfaceAlt),
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.surface : p.subInk),
      trackOutlineColor: WidgetStateProperty.all(p.subInk),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.primary : Colors.transparent),
      checkColor: WidgetStateProperty.all(p.onPrimary),
      side: BorderSide(color: p.ink, width: 2),
    ),
    sliderTheme: SliderThemeData(activeTrackColor: p.ink, thumbColor: p.ink, inactiveTrackColor: p.surfaceAlt, trackHeight: 6),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: p.surface,
        foregroundColor: p.ink,
        selectedBackgroundColor: Thread.kesumba,
        selectedForegroundColor: Thread.onThread,
        side: BorderSide(color: p.line),
        minimumSize: const Size(0, AppSpace.tapGuardian),
        textStyle: AppText.label,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.panelRadius)),
      titleTextStyle: AppText.heading.copyWith(color: p.ink),
      contentTextStyle: AppText.bodyGuardian.copyWith(color: p.ink),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      showDragHandle: true,
      dragHandleColor: p.line,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpace.panelRadius))),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.ink,
      contentTextStyle: AppText.bodyGuardian.copyWith(color: p.ground),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: p.ink, linearTrackColor: p.empty),
    listTileTheme: ListTileThemeData(iconColor: p.ink, textColor: p.ink),
    dividerTheme: DividerThemeData(color: p.line, thickness: 1, space: 1),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}
