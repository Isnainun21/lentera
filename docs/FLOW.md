# ReadAdapt — Flow & Schema

Sumber: `ReadAdapt PRD DAN SRD_ISNA INUN WULAN SARI.pdf` (BAB II.3, 3.1, 3.4) + UI `stitch_dyslexia_adaptive_reading_app/`.

## 1. Alur Utama (dari PRD BAB II.3)

```
[Beranda] pilih profil
   |
   v
[Latihan] tampil 1 kata/suku kata sesuai level + tombol mikrofon besar
   |
   v  tekan & tahan tombol
[rekam audio] -> speech-to-text
   |
   v
[cocokkan teks vs kata target]
   |
   +-- cocok        -> [Umpan Balik] highlight HIJAU per suku kata -> "Lanjut"
   |
   +-- belum cocok  -> [Umpan Balik] suku kata meleset ditandai MERAH + catatan -> "Ulangi"
   |
   v
[Mesin Adaptif] hitung streak: N benar berturut-turut -> level NAIK
                                M salah berturut-turut -> level TURUN
   |
   v
sesi selesai (jumlah kata tertentu) -> simpan ringkasan sesi
   |
   v
[Progres] grafik mingguan (guru / orang tua)
```

## 2. Layar & Navigasi (bottom dock 4 tab, dari UI Stitch)

`Beranda` | `Latihan` | `Cerita` | `Progres`  +  layar turunan: `Umpan Balik` (overlay di Latihan), `Pengaturan Aksesibilitas`.

Navigasi maksimal 2 langkah dari Beranda (kebutuhan non-fungsional PRD).

## 3. Schema Entitas (dari PRD 3.1)

| Entitas | Field |
|---|---|
| `Pengguna` | id, nama, peran (siswa/guru/orangTua), avatarId, levelSaatIni |
| `SesiLatihan` | id, idPengguna, tanggal, level, jumlahBenar, jumlahSalah, durasi |
| `KataLatihan` | id, teks, tingkatKesulitan (1..5), sukuKata[], audioReferensi |
| `HasilUcapan` | id, idSesi, idKata, teksTerdeteksi, statusKecocokan (benar/sebagian/salah), sukuKataBenar[] |
| `ProgresMingguan` | idPengguna, minggu, rataRataAkurasi, totalKata |

## 4. Mesin Adaptif (RA-PRD-401)

Naik level setelah N = 3 benar berturut-turut. Turun level setelah M = 2 salah berturut-turut.
Sesi = 10 kata. N, M, dan jumlah kata per sesi bisa dikonfigurasi (PRD: "N, M dikonfigurasi").

## 5. Pencocokan Ucapan (RA-PRD-202)

Pecah kata target jadi suku kata, cocokkan per suku kata terhadap teks hasil speech-to-text
(normalisasi: lowercase, buang tanda baca). Status:
- `benar`   = semua suku kata cocok
- `sebagian`= ada suku kata cocok, ada yang tidak  -> suku kata yang meleset ditandai MERAH
- `salah`   = tidak ada yang cocok