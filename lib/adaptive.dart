import 'models.dart';

// RA-PRD-202: membandingkan teks hasil speech-to-text dengan kata target,
// per suku kata, supaya umpan balik bisa menandai suku kata yang meleset.
class PencocokanUcapan {
  const PencocokanUcapan._();

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[^a-z ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static bool _ada(List<String> kataUcapan, String potongan) =>
      potongan.isNotEmpty && kataUcapan.contains(potongan);

  // Mengembalikan indeks suku kata yang cocok beserta daftar suku katanya.
  static ({List<int> cocok, List<String> sukuKata}) cocokkan(
    KataLatihan kata,
    String teksTerdeteksi,
  ) {
    final ucap = _norm(teksTerdeteksi).split(' ');
    final cocok = <int>[];
    var gabung = '';

    for (var i = 0; i < kata.sukuKata.length; i++) {
      final syl = _norm(kata.sukuKata[i]);
      gabung += syl;
      if (_ada(ucap, syl) || _ada(ucap, gabung)) cocok.add(i);
    }

    // Kalau seluruh kata diucapkan utuh, semua suku kata dianggap benar.
    if (_ada(ucap, _norm(kata.teks))) {
      for (var i = 0; i < kata.sukuKata.length; i++) {
        if (!cocok.contains(i)) cocok.add(i);
      }
      cocok.sort();
    }
    return (cocok: cocok, sukuKata: kata.sukuKata);
  }

  static StatusKecocokan status(KataLatihan kata, String teks) {
    final r = cocokkan(kata, teks);
    if (r.cocok.length == kata.sukuKata.length) return StatusKecocokan.benar;
    if (r.cocok.isEmpty) return StatusKecocokan.salah;
    return StatusKecocokan.sebagian;
  }
}

// RA-PRD-401: naik level setelah N benar berturut-turut, turun setelah M salah
// berturut-turut. N dan M dikonfigurasi sesuai PRD.
class MesinAdaptif {
  MesinAdaptif({this.naikSetelah = 3, this.turunSetelah = 2, this.levelMaks = 5});

  final int naikSetelah;
  final int turunSetelah;
  final int levelMaks;

  int _benar = 0;
  int _salah = 0;

  int get streakBenar => _benar;
  int get streakSalah => _salah;

  void reset() {
    _benar = 0;
    _salah = 0;
  }

  // Mengembalikan level baru (tidak berubah kalau belum memenuhi syarat).
  int evaluasi(int levelSaatIni, StatusKecocokan hasil) {
    switch (hasil) {
      case StatusKecocokan.benar:
        _benar++;
        _salah = 0;
        if (_benar >= naikSetelah) {
          _benar = 0;
          return (levelSaatIni + 1).clamp(1, levelMaks);
        }
      case StatusKecocokan.sebagian:
      case StatusKecocokan.salah:
        _salah++;
        _benar = 0;
        if (_salah >= turunSetelah) {
          _salah = 0;
          return (levelSaatIni - 1).clamp(1, levelMaks);
        }
    }
    return levelSaatIni;
  }
}