import 'models.dart';

/// Bank kata per level (PRD BAB II.2: "daftar kata/suku kata per level").
/// Level 1 = suku kata 2 huruf -> Level 5 = kata panjang.
class BankKata {
  const BankKata._();

  static const List<KataLatihan> semua = [
    // Level 1 — suku kata 2 huruf
    KataLatihan(id: 'l1-1', teks: 'BA', tingkatKesulitan: 1, sukuKata: ['BA']),
    KataLatihan(id: 'l1-2', teks: 'BI', tingkatKesulitan: 1, sukuKata: ['BI']),
    KataLatihan(id: 'l1-3', teks: 'BU', tingkatKesulitan: 1, sukuKata: ['BU']),
    KataLatihan(id: 'l1-4', teks: 'MA', tingkatKesulitan: 1, sukuKata: ['MA']),
    KataLatihan(id: 'l1-5', teks: 'NI', tingkatKesulitan: 1, sukuKata: ['NI']),
    KataLatihan(id: 'l1-6', teks: 'RU', tingkatKesulitan: 1, sukuKata: ['RU']),
    KataLatihan(id: 'l1-7', teks: 'DA', tingkatKesulitan: 1, sukuKata: ['DA']),
    KataLatihan(id: 'l1-8', teks: 'DU', tingkatKesulitan: 1, sukuKata: ['DU']),

    // Level 2 — kata 2 suku kata sederhana
    KataLatihan(id: 'l2-1', teks: 'BUKU', tingkatKesulitan: 2, sukuKata: ['BU', 'KU'], jenisBunyi: 'b'),
    KataLatihan(id: 'l2-2', teks: 'BOLA', tingkatKesulitan: 2, sukuKata: ['BO', 'LA'], jenisBunyi: 'b'),
    KataLatihan(id: 'l2-3', teks: 'MATA', tingkatKesulitan: 2, sukuKata: ['MA', 'TA']),
    KataLatihan(id: 'l2-4', teks: 'DADA', tingkatKesulitan: 2, sukuKata: ['DA', 'DA'], jenisBunyi: 'd'),
    KataLatihan(id: 'l2-5', teks: 'DUKU', tingkatKesulitan: 2, sukuKata: ['DU', 'KU'], jenisBunyi: 'd'),
    KataLatihan(id: 'l2-6', teks: 'RUSA', tingkatKesulitan: 2, sukuKata: ['RU', 'SA']),
    KataLatihan(id: 'l2-7', teks: 'BIBI', tingkatKesulitan: 2, sukuKata: ['BI', 'BI'], jenisBunyi: 'b'),
    KataLatihan(id: 'l2-8', teks: 'DODO', tingkatKesulitan: 2, sukuKata: ['DO', 'DO'], jenisBunyi: 'd'),

    // Level 3 — kata 2 suku kata, konsonan akhir
    KataLatihan(id: 'l3-1', teks: 'BAJU', tingkatKesulitan: 3, sukuKata: ['BA', 'JU'], jenisBunyi: 'b'),
    KataLatihan(id: 'l3-2', teks: 'MIMPI', tingkatKesulitan: 3, sukuKata: ['MIM', 'PI']),
    KataLatihan(id: 'l3-3', teks: 'LAMPU', tingkatKesulitan: 3, sukuKata: ['LAM', 'PU']),
    KataLatihan(id: 'l3-4', teks: 'BADAK', tingkatKesulitan: 3, sukuKata: ['BA', 'DAK'], jenisBunyi: 'bd'),
    KataLatihan(id: 'l3-5', teks: 'KUPU', tingkatKesulitan: 3, sukuKata: ['KU', 'PU']),
    KataLatihan(id: 'l3-6', teks: 'PAPAN', tingkatKesulitan: 3, sukuKata: ['PA', 'PAN']),
    KataLatihan(id: 'l3-7', teks: 'DOMPET', tingkatKesulitan: 3, sukuKata: ['DOM', 'PET'], jenisBunyi: 'd'),
    KataLatihan(id: 'l3-8', teks: 'PAGAR', tingkatKesulitan: 3, sukuKata: ['PA', 'GAR']),

    // Level 4 — 3 suku kata
    KataLatihan(id: 'l4-1', teks: 'BINTANG', tingkatKesulitan: 4, sukuKata: ['BIN', 'TANG'], jenisBunyi: 'b'),
    KataLatihan(id: 'l4-2', teks: 'SEMANGGI', tingkatKesulitan: 4, sukuKata: ['SE', 'MANG', 'GI']),
    KataLatihan(id: 'l4-3', teks: 'KERBAU', tingkatKesulitan: 4, sukuKata: ['KER', 'BAU']),
    KataLatihan(id: 'l4-4', teks: 'SEKOLAH', tingkatKesulitan: 4, sukuKata: ['SE', 'KO', 'LAH']),
    KataLatihan(id: 'l4-5', teks: 'POHON', tingkatKesulitan: 4, sukuKata: ['PO', 'HON']),
    KataLatihan(id: 'l4-6', teks: 'DANAU', tingkatKesulitan: 4, sukuKata: ['DA', 'NAU'], jenisBunyi: 'd'),

    // Level 5 — kata panjang / 4 suku kata
    KataLatihan(id: 'l5-1', teks: 'KOMPUTER', tingkatKesulitan: 5, sukuKata: ['KOM', 'PU', 'TER']),
    KataLatihan(id: 'l5-2', teks: 'KECERDASAN', tingkatKesulitan: 5, sukuKata: ['KE', 'CER', 'DA', 'SAN']),
    KataLatihan(id: 'l5-3', teks: 'PEMBELAJARAN', tingkatKesulitan: 5, sukuKata: ['PEM', 'BE', 'LA', 'JA', 'RAN']),
    KataLatihan(id: 'l5-4', teks: 'PERPUSTAKAAN', tingkatKesulitan: 5, sukuKata: ['PER', 'PUS', 'TA', 'KA', 'AN']),
    KataLatihan(id: 'l5-5', teks: 'PENDIDIKAN', tingkatKesulitan: 5, sukuKata: ['PEN', 'DI', 'DI', 'KAN'], jenisBunyi: 'd'),
    KataLatihan(id: 'l5-6', teks: 'SAINS', tingkatKesulitan: 5, sukuKata: ['SA', 'INS']),
  ];

  static List<KataLatihan> untukLevel(int level) =>
      semua.where((k) => k.tingkatKesulitan == level).toList();
}

// ──────────────────────────── Bank Cerita ──────────────────────────

class BankCerita {
  const BankCerita._();

  static const List<Cerita> semua = [
    Cerita(
      id: 'c1',
      judul: 'Petualangan di Hutan Pinus',
      level: 1,
      jumlahBab: 4,
      durasiMenit: 6,
      jumlahLatihan: 120,
      halaman: [
        HalamanCerita(
          teks: 'Pada suatu hari, Kancil bertemu dengan Kelinci di tepi sungai.',
          sukuKataTerpisah:
              'Pa-da su-a-tu ha-ri, Kan-cil ber-te-mu de-ngan Ke-lin-ci di te-pi su-ngai.',
          kataHighlight: ['Kancil', 'Kelinci'],
        ),
        HalamanCerita(
          teks: 'Mereka bersama-sama mencari buah-buahan segar di sekitar semak.',
          sukuKataTerpisah:
              'Me-re-ka ber-sa-ma-sa-ma men-ca-ri bu-ah-bu-ah-an se-gar di se-ki-tar se-mak.',
          kataHighlight: [],
        ),
        HalamanCerita(
          teks: 'Kancil sangat gembira karena menemukan pohon apel manis.',
          sukuKataTerpisah:
              'Kan-cil sa-ngat gem-bi-ra ka-re-na me-ne-mu-kan po-hon a-pel ma-nis.',
          kataHighlight: ['Kancil'],
        ),
      ],
    ),
    Cerita(
      id: 'c2',
      judul: 'Bima dan Kucing Kecil',
      level: 1,
      jumlahBab: 3,
      durasiMenit: 4,
      jumlahLatihan: 80,
      halaman: [
        HalamanCerita(
          teks: 'Bima punya kucing kecil berwarna putih. Namanya Bubu.',
          sukuKataTerpisah:
              'Bi-ma pu-nya ku-cing ke-cil ber-war-na pu-tih. Na-ma-nya Bu-bu.',
          kataHighlight: ['Bima', 'Bubu'],
        ),
        HalamanCerita(
          teks: 'Bubu suka bermain bola di halaman rumah.',
          sukuKataTerpisah:
              'Bu-bu su-ka ber-ma-in bo-la di ha-la-man ru-mah.',
          kataHighlight: ['Bubu', 'bola'],
        ),
        HalamanCerita(
          teks: 'Bima dan Bubu adalah sahabat baik.',
          sukuKataTerpisah: 'Bi-ma dan Bu-bu a-da-lah sa-ha-bat ba-ik.',
          kataHighlight: ['Bima', 'Bubu'],
        ),
      ],
    ),
    Cerita(
      id: 'c3',
      judul: 'Hari di Kebun Binatang',
      level: 2,
      jumlahBab: 3,
      durasiMenit: 5,
      jumlahLatihan: 90,
      halaman: [
        HalamanCerita(
          teks: 'Dina pergi ke kebun binatang bersama ayah dan ibu.',
          sukuKataTerpisah:
              'Di-na per-gi ke ke-bun bi-na-tang ber-sa-ma a-yah dan i-bu.',
          kataHighlight: ['Dina', 'binatang'],
        ),
        HalamanCerita(
          teks: 'Dia melihat gajah besar dan jerapah tinggi.',
          sukuKataTerpisah:
              'Di-a me-li-hat ga-jah be-sar dan je-ra-pah ting-gi.',
          kataHighlight: ['gajah', 'jerapah'],
        ),
        HalamanCerita(
          teks: 'Dina paling suka burung-burung yang bernyanyi merdu.',
          sukuKataTerpisah:
              'Di-na pa-ling su-ka bu-rung-bu-rung yang ber-nya-nyi mer-du.',
          kataHighlight: ['Dina', 'burung'],
        ),
      ],
    ),
  ];
}

// ──────────────────────────── Discriminasi Huruf ───────────────────

class BankDiscriminasi {
  const BankDiscriminasi._();

  static const List<SoalDiscriminasi> soalBD = [
    SoalDiscriminasi(
      hurufTarget: 'b',
      pilihan: ['b', 'd', 'p', 'b'],
      jawaban: [0, 3],
      penjelasan: 'Huruf "b" perutnya ke arah depan (kanan), tangkainya di kiri.',
    ),
    SoalDiscriminasi(
      hurufTarget: 'd',
      pilihan: ['b', 'd', 'd', 'q'],
      jawaban: [1, 2],
      penjelasan: 'Huruf "d" perutnya ke arah belakang (kiri), tangkainya di kanan.',
    ),
    SoalDiscriminasi(
      hurufTarget: 'b',
      pilihan: ['d', 'b', 'q', 'p'],
      jawaban: [1],
      penjelasan: 'Huruf "b" perutnya ke arah depan (kanan).',
    ),
    SoalDiscriminasi(
      hurufTarget: 'd',
      pilihan: ['d', 'b', 'p', 'b'],
      jawaban: [0],
      penjelasan: 'Huruf "d" perutnya ke arah belakang (kiri).',
    ),
  ];

  static const List<SoalDiscriminasi> soalPQ = [
    SoalDiscriminasi(
      hurufTarget: 'p',
      pilihan: ['p', 'q', 'b', 'p'],
      jawaban: [0, 3],
      penjelasan: 'Huruf "p" ekornya ke bawah, perutnya ke kanan.',
    ),
    SoalDiscriminasi(
      hurufTarget: 'q',
      pilihan: ['p', 'q', 'q', 'd'],
      jawaban: [1, 2],
      penjelasan: 'Huruf "q" ekornya ke bawah, perutnya ke kiri.',
    ),
  ];
}

// ──────────────────────────── Avatar Data ──────────────────────────

class AvatarData {
  const AvatarData._();

  static const List<String> emojis = [
    '🦁', '🐻', '🦊', '🐰', '🐱', '🐶',
    '🦋', '🐢', '🦜', '🐼', '🦌', '🐸',
  ];

  static String emoji(int id) =>
      emojis[id.clamp(0, emojis.length - 1)];
}