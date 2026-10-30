import 'dart:convert';

class ChildSettings {
  const ChildSettings({
    this.fontScale = 1.0,
    this.speechRate = 0.4,
    this.ruler = true,
    this.letterColors = true,
    this.reduceMotion = false,
    this.wordsPerSession = 6,
    this.raiseAfter = 3,
    this.lowerAfter = 2,
    this.guided = false,
  });

  final double fontScale;
  final double speechRate;
  final bool ruler;
  final bool letterColors;
  final bool reduceMotion;
  final int wordsPerSession;
  final int raiseAfter;
  final int lowerAfter;

  /// Mode pendampingan: menampilkan tombol "Sudah benar" saat latihan.
  final bool guided;

  ChildSettings copyWith({
    double? fontScale,
    double? speechRate,
    bool? ruler,
    bool? letterColors,
    bool? reduceMotion,
    int? wordsPerSession,
    int? raiseAfter,
    int? lowerAfter,
    bool? guided,
  }) =>
      ChildSettings(
        fontScale: fontScale ?? this.fontScale,
        speechRate: speechRate ?? this.speechRate,
        ruler: ruler ?? this.ruler,
        letterColors: letterColors ?? this.letterColors,
        reduceMotion: reduceMotion ?? this.reduceMotion,
        wordsPerSession: wordsPerSession ?? this.wordsPerSession,
        raiseAfter: raiseAfter ?? this.raiseAfter,
        lowerAfter: lowerAfter ?? this.lowerAfter,
        guided: guided ?? this.guided,
      );

  String encode() => jsonEncode({
        'fontScale': fontScale,
        'speechRate': speechRate,
        'ruler': ruler,
        'letterColors': letterColors,
        'reduceMotion': reduceMotion,
        'wordsPerSession': wordsPerSession,
        'raiseAfter': raiseAfter,
        'lowerAfter': lowerAfter,
        'guided': guided,
      });

  factory ChildSettings.decode(String raw) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return ChildSettings(
      fontScale: (j['fontScale'] as num?)?.toDouble() ?? 1.0,
      speechRate: (j['speechRate'] as num?)?.toDouble() ?? 0.4,
      ruler: j['ruler'] as bool? ?? true,
      letterColors: j['letterColors'] as bool? ?? true,
      reduceMotion: j['reduceMotion'] as bool? ?? false,
      wordsPerSession: j['wordsPerSession'] as int? ?? 6,
      raiseAfter: j['raiseAfter'] as int? ?? 3,
      lowerAfter: j['lowerAfter'] as int? ?? 2,
      guided: j['guided'] as bool? ?? false,
    );
  }
}

class ChildProfile {
  const ChildProfile({required this.id, required this.nickname, required this.avatarId, required this.settings, required this.level});

  final String id;
  final String nickname;
  final int avatarId;
  final ChildSettings settings;
  final int level;
}
