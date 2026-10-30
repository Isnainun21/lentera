/// Domain models untuk ReadAdapt / Lentera Membaca.

enum Peran { siswa, guru, orangTua }

extension PeranX on Peran {
  String get label => switch (this) {
        Peran.siswa => 'Siswa',
        Peran.guru => 'Guru',
        Peran.orangTua => 'Orang Tua',
      };
}

enum StatusKecocokan { benar, sebagian, salah }

// ──────────────────────────── Pengguna ────────────────────────────

class Pengguna {
  const Pengguna({
    required this.id,
    required this.nama,
    required this.avatarId,
    required this.peran,
    this.usia = 7,
    this.levelSaatIni = 1,
    DateTime? tanggalDaftar,
  }) : tanggalDaftar = tanggalDaftar ?? null;

  final String id;
  final String nama;
  final int avatarId;
  final Peran peran;
  final int usia;
  final int levelSaatIni;
  final DateTime? tanggalDaftar;

  Pengguna copyWith({
    String? nama,
    int? avatarId,
    int? usia,
    int? levelSaatIni,
  }) =>
      Pengguna(
        id: id,
        nama: nama ?? this.nama,
        avatarId: avatarId ?? this.avatarId,
        peran: peran,
        usia: usia ?? this.usia,
        levelSaatIni: levelSaatIni ?? this.levelSaatIni,
        tanggalDaftar: tanggalDaftar,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'avatarId': avatarId,
        'peran': peran.name,
        'usia': usia,
        'levelSaatIni': levelSaatIni,
        'tanggalDaftar':
            (tanggalDaftar ?? DateTime.now()).toIso8601String(),
      };

  static Pengguna fromJson(Map<String, dynamic> j) => Pengguna(
        id: j['id'] as String,
        nama: j['nama'] as String,
        avatarId: (j['avatarId'] as num).toInt(),
        peran: Peran.values.firstWhere(
          (p) => p.name == j['peran'],
          orElse: () => Peran.siswa,
        ),
        usia: (j['usia'] as num?)?.toInt() ?? 7,
        levelSaatIni: (j['levelSaatIni'] as num?)?.toInt() ?? 1,
        tanggalDaftar: j['tanggalDaftar'] != null
            ? DateTime.tryParse(j['tanggalDaftar'] as String)
            : null,
      );
}

// ──────────────────────────── Kata Latihan ─────────────────────────

class KataLatihan {
  const KataLatihan({
    required this.id,
    required this.teks,
    required this.tingkatKesulitan,
    required this.sukuKata,
    this.jenisBunyi,
  });

  final String id;
  final String teks;

  /// 1 = termudah (suku kata 2 huruf), 5 = tersulit.
  final int tingkatKesulitan;
  final List<String> sukuKata;

  /// Jenis bunyi untuk color coding (huruf pembeda b/d/p/q).
  final String? jenisBunyi;

  Map<String, dynamic> toJson() => {
        'id': id,
        'teks': teks,
        'tingkatKesulitan': tingkatKesulitan,
        'sukuKata': sukuKata,
        'jenisBunyi': jenisBunyi,
      };

  static KataLatihan fromJson(Map<String, dynamic> j) => KataLatihan(
        id: j['id'] as String,
        teks: j['teks'] as String,
        tingkatKesulitan: (j['tingkatKesulitan'] as num).toInt(),
        sukuKata: (j['sukuKata'] as List).cast<String>(),
        jenisBunyi: j['jenisBunyi'] as String?,
      );
}

// ──────────────────────────── Hasil Ucapan ─────────────────────────

class HasilUcapan {
  const HasilUcapan({
    required this.kataId,
    required this.teksTerdeteksi,
    required this.status,
    required this.sukuKataBenar,
  });

  final String kataId;
  final String teksTerdeteksi;
  final StatusKecocokan status;

  /// Indeks suku kata yang berhasil dicocokkan (untuk highlight warna).
  final List<int> sukuKataBenar;

  bool get cocok => status == StatusKecocokan.benar;
}

// ──────────────────────────── Sesi Latihan ─────────────────────────

class SesiLatihan {
  const SesiLatihan({
    required this.id,
    required this.idPengguna,
    required this.tanggal,
    required this.level,
    required this.jumlahBenar,
    required this.jumlahSalah,
    required this.durasiDetik,
    this.jenisLatihan = 'suku_kata',
  });

  final String id;
  final String idPengguna;
  final DateTime tanggal;
  final int level;
  final int jumlahBenar;
  final int jumlahSalah;
  final int durasiDetik;
  final String jenisLatihan;

  int get total => jumlahBenar + jumlahSalah;

  double get akurasi => total == 0 ? 0 : jumlahBenar / total;

  Map<String, dynamic> toJson() => {
        'id': id,
        'idPengguna': idPengguna,
        'tanggal': tanggal.toIso8601String(),
        'level': level,
        'jumlahBenar': jumlahBenar,
        'jumlahSalah': jumlahSalah,
        'durasiDetik': durasiDetik,
        'jenisLatihan': jenisLatihan,
      };

  static SesiLatihan fromJson(Map<String, dynamic> j) => SesiLatihan(
        id: j['id'] as String,
        idPengguna: j['idPengguna'] as String,
        tanggal: DateTime.parse(j['tanggal'] as String),
        level: (j['level'] as num).toInt(),
        jumlahBenar: (j['jumlahBenar'] as num).toInt(),
        jumlahSalah: (j['jumlahSalah'] as num).toInt(),
        durasiDetik: (j['durasiDetik'] as num).toInt(),
        jenisLatihan: j['jenisLatihan'] as String? ?? 'suku_kata',
      );
}

// ──────────────────────────── Lencana ──────────────────────────────

enum JenisLencana {
  penjelajahFonik,
  rajaSukuKata,
  sahabatKancil,
  masterHuruf,
  rajinBerlatih,
  bintangCerita,
}

extension JenisLencanaX on JenisLencana {
  String get label => switch (this) {
        JenisLencana.penjelajahFonik => 'Penjelajah Fonik',
        JenisLencana.rajaSukuKata => 'Raja Suku Kata',
        JenisLencana.sahabatKancil => 'Sahabat Kancil',
        JenisLencana.masterHuruf => 'Master Huruf b & d',
        JenisLencana.rajinBerlatih => 'Rajin Berlatih',
        JenisLencana.bintangCerita => 'Bintang Cerita',
      };

  String get deskripsi => switch (this) {
        JenisLencana.penjelajahFonik => 'Bunyi Fonem',
        JenisLencana.rajaSukuKata => '40+ Kata',
        JenisLencana.sahabatKancil => '5 Cerita Selesai',
        JenisLencana.masterHuruf => 'Nilai Terbaik',
        JenisLencana.rajinBerlatih => '7 Hari Berturut',
        JenisLencana.bintangCerita => '10 Bab Selesai',
      };

  String get emoji => switch (this) {
        JenisLencana.penjelajahFonik => '🔍',
        JenisLencana.rajaSukuKata => '👑',
        JenisLencana.sahabatKancil => '🦌',
        JenisLencana.masterHuruf => '🏆',
        JenisLencana.rajinBerlatih => '⭐',
        JenisLencana.bintangCerita => '📖',
      };

  String get sublabel => switch (this) {
        JenisLencana.penjelajahFonik => 'LENCANA EMAS',
        JenisLencana.rajaSukuKata => 'PEMBERANI',
        JenisLencana.sahabatKancil => 'PENCINTA BUKU',
        JenisLencana.masterHuruf => 'JUARA FOKUS',
        JenisLencana.rajinBerlatih => 'KONSISTEN',
        JenisLencana.bintangCerita => 'PEMBACA HEBAT',
      };
}

class Lencana {
  const Lencana({
    required this.jenis,
    required this.tanggalDapat,
    this.terbuka = true,
  });

  final JenisLencana jenis;
  final DateTime tanggalDapat;
  final bool terbuka;

  Map<String, dynamic> toJson() => {
        'jenis': jenis.name,
        'tanggalDapat': tanggalDapat.toIso8601String(),
        'terbuka': terbuka,
      };

  static Lencana fromJson(Map<String, dynamic> j) => Lencana(
        jenis: JenisLencana.values.firstWhere(
          (l) => l.name == j['jenis'],
          orElse: () => JenisLencana.penjelajahFonik,
        ),
        tanggalDapat: DateTime.parse(j['tanggalDapat'] as String),
        terbuka: j['terbuka'] as bool? ?? true,
      );
}

// ──────────────────────────── Cerita ───────────────────────────────

class HalamanCerita {
  const HalamanCerita({
    required this.teks,
    required this.sukuKataTerpisah,
    this.kataHighlight = const [],
  });

  /// Teks biasa paragraph.
  final String teks;

  /// Teks dengan suku kata dipisah tanda hubung.
  final String sukuKataTerpisah;

  /// Kata-kata yang perlu di-highlight (karakter target).
  final List<String> kataHighlight;
}

class Cerita {
  const Cerita({
    required this.id,
    required this.judul,
    required this.level,
    required this.halaman,
    this.jumlahBab = 1,
    this.durasiMenit = 5,
    this.jumlahLatihan = 0,
  });

  final String id;
  final String judul;
  final int level;
  final List<HalamanCerita> halaman;
  final int jumlahBab;
  final int durasiMenit;
  final int jumlahLatihan;
}

// ──────────────────────────── Discriminasi Huruf ───────────────────

class SoalDiscriminasi {
  const SoalDiscriminasi({
    required this.hurufTarget,
    required this.pilihan,
    required this.jawaban,
    required this.penjelasan,
  });

  final String hurufTarget;
  final List<String> pilihan;

  /// Indeks jawaban benar dalam [pilihan].
  final List<int> jawaban;
  final String penjelasan;
}