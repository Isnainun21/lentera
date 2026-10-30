import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Penyimpanan lokal — mencakup profil, sesi, aksesibilitas, lencana,
/// dan statistik harian.
class Store {
  Store._();
  static final Store instance = Store._();

  static const _kProfil = 'profil';
  static const _kSesi = 'sesi';
  static const _kLencana = 'lencana';
  static const _kMenitHarian = 'menitHarian'; // "YYYY-MM-DD": detik

  SharedPreferences? _prefs;

  Future<void> init() async =>
      _prefs = await SharedPreferences.getInstance();

  SharedPreferences get _p {
    assert(_prefs != null, 'Store.init() harus dipanggil dulu');
    return _prefs!;
  }

  // ─────────── Profil (Pengguna) ───────────

  bool get sudahOnboarding => _p.getString(_kProfil) != null;

  Pengguna? bacaProfil() {
    final raw = _p.getString(_kProfil);
    if (raw == null) return null;
    return Pengguna.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> simpanProfil(Pengguna p) =>
      _p.setString(_kProfil, jsonEncode(p.toJson()));

  // ─────────── Sesi latihan (SesiLatihan) ───────────

  List<SesiLatihan> bacaSesi(String idPengguna) {
    final raw = _p.getString(_kSesi);
    if (raw == null) return const [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list
        .map(SesiLatihan.fromJson)
        .where((s) => s.idPengguna == idPengguna)
        .toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  Future<void> simpanSesi(SesiLatihan s) async {
    final raw = _p.getString(_kSesi);
    final list = raw == null
        ? <Map<String, dynamic>>[]
        : (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    list.add(s.toJson());
    await _p.setString(_kSesi, jsonEncode(list));
  }

  // ─────────── Waktu Harian ───────────

  String get _hariIni {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  /// Menambahkan detik latihan ke hari ini.
  Future<void> tambahWaktuLatihan(int detik) async {
    final raw = _p.getString(_kMenitHarian);
    final map = raw == null
        ? <String, dynamic>{}
        : jsonDecode(raw) as Map<String, dynamic>;
    final key = _hariIni;
    map[key] = ((map[key] as num?)?.toInt() ?? 0) + detik;
    await _p.setString(_kMenitHarian, jsonEncode(map));
  }

  /// Detik total latihan hari ini.
  int waktuLatihanHariIni() {
    final raw = _p.getString(_kMenitHarian);
    if (raw == null) return 0;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return (map[_hariIni] as num?)?.toInt() ?? 0;
  }

  /// Menit latihan hari ini.
  int menitLatihanHariIni() => (waktuLatihanHariIni() / 60).floor();

  /// Bintang earned hari ini (1 bintang per 5 menit latihan, max 5).
  int bintangHariIni() => (menitLatihanHariIni() / 5).floor().clamp(0, 5);

  /// Jumlah hari berturut-turut berlatih (streak).
  int streakHari() {
    final raw = _p.getString(_kMenitHarian);
    if (raw == null) return 0;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    var streak = 0;
    var tanggal = DateTime.now();
    for (var i = 0; i < 365; i++) {
      final key =
          '${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}';
      if (map.containsKey(key) && ((map[key] as num?)?.toInt() ?? 0) > 0) {
        streak++;
      } else if (i > 0) {
        break;
      }
      tanggal = tanggal.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // ─────────── Lencana ───────────

  List<Lencana> bacaLencana() {
    final raw = _p.getString(_kLencana);
    if (raw == null) return const [];
    return (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map(Lencana.fromJson)
        .toList();
  }

  Future<void> tambahLencana(Lencana l) async {
    final list = bacaLencana().map((e) => e.toJson()).toList();
    // Jangan duplikat
    if (list.any((e) => e['jenis'] == l.jenis.name)) return;
    list.add(l.toJson());
    await _p.setString(_kLencana, jsonEncode(list));
  }

  bool punyaLencana(JenisLencana jenis) =>
      bacaLencana().any((l) => l.jenis == jenis);

  /// Periksa dan berikan lencana otomatis berdasarkan progress.
  Future<List<Lencana>> periksaLencanaBaru(String idPengguna) async {
    final sesi = bacaSesi(idPengguna);
    final baru = <Lencana>[];

    // Penjelajah Fonik: minimal 10 sesi
    if (sesi.length >= 10 && !punyaLencana(JenisLencana.penjelajahFonik)) {
      final l = Lencana(jenis: JenisLencana.penjelajahFonik, tanggalDapat: DateTime.now());
      await tambahLencana(l);
      baru.add(l);
    }

    // Raja Suku Kata: total 40+ benar
    final totalBenar = sesi.fold<int>(0, (a, s) => a + s.jumlahBenar);
    if (totalBenar >= 40 && !punyaLencana(JenisLencana.rajaSukuKata)) {
      final l = Lencana(jenis: JenisLencana.rajaSukuKata, tanggalDapat: DateTime.now());
      await tambahLencana(l);
      baru.add(l);
    }

    // Rajin Berlatih: 7 hari streak
    if (streakHari() >= 7 && !punyaLencana(JenisLencana.rajinBerlatih)) {
      final l = Lencana(jenis: JenisLencana.rajinBerlatih, tanggalDapat: DateTime.now());
      await tambahLencana(l);
      baru.add(l);
    }

    return baru;
  }

  // ─────────── Aksesibilitas (RA-PRD-601) ───────────

  Aksesibilitas bacaAksesibilitas() => Aksesibilitas(
        ukuranHuruf: _p.getDouble('ukuranHuruf') ?? 1.0,
        textToSpeech: _p.getBool('textToSpeech') ?? true,
        hurufRamahDisleksia: _p.getBool('hurufRamah') ?? true,
        penggarisAktif: _p.getBool('penggarisAktif') ?? false,
        warnaHurufAktif: _p.getBool('warnaHurufAktif') ?? true,
      );

  Future<void> simpanAksesibilitas(Aksesibilitas a) async {
    await _p.setDouble('ukuranHuruf', a.ukuranHuruf);
    await _p.setBool('textToSpeech', a.textToSpeech);
    await _p.setBool('hurufRamah', a.hurufRamahDisleksia);
    await _p.setBool('penggarisAktif', a.penggarisAktif);
    await _p.setBool('warnaHurufAktif', a.warnaHurufAktif);
  }

  // ─────────── Cerita Progress ───────────

  int ceritaSelesai() => _p.getInt('ceritaSelesai') ?? 0;

  Future<void> tambahCeritaSelesai() async {
    await _p.setInt('ceritaSelesai', ceritaSelesai() + 1);
  }

  // ─────────── Reset (untuk debug) ───────────

  Future<void> resetSemua() async {
    await _p.clear();
  }
}

class Aksesibilitas {
  const Aksesibilitas({
    this.ukuranHuruf = 1.0,
    this.textToSpeech = true,
    this.hurufRamahDisleksia = true,
    this.penggarisAktif = false,
    this.warnaHurufAktif = true,
  });

  final double ukuranHuruf;
  final bool textToSpeech;
  final bool hurufRamahDisleksia;
  final bool penggarisAktif;
  final bool warnaHurufAktif;

  Aksesibilitas copyWith({
    double? ukuranHuruf,
    bool? textToSpeech,
    bool? hurufRamahDisleksia,
    bool? penggarisAktif,
    bool? warnaHurufAktif,
  }) =>
      Aksesibilitas(
        ukuranHuruf: ukuranHuruf ?? this.ukuranHuruf,
        textToSpeech: textToSpeech ?? this.textToSpeech,
        hurufRamahDisleksia: hurufRamahDisleksia ?? this.hurufRamahDisleksia,
        penggarisAktif: penggarisAktif ?? this.penggarisAktif,
        warnaHurufAktif: warnaHurufAktif ?? this.warnaHurufAktif,
      );
}