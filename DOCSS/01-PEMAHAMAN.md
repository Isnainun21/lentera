# 01. Pemahaman project

Dicek pada 31 Oktober 2026 dari kode, PRD, mockup Stitch, dan dua gambar referensi. Aplikasi belum bisa dijalankan, jadi perilaku saat runtime disimpulkan dari kode.

## Produk

Aplikasi Flutter untuk anak disleksia berlatih membaca kata dan suku kata Bahasa Indonesia. Anak mengucapkan kata, sistem mencocokkan ucapan, memberi umpan balik per suku kata, lalu menyesuaikan level. Guru dan orang tua memantau progres. Target Android 8.0 ke atas (PRD 2.5).

## Kondisi kode

| Area | Temuan | Bukti |
|---|---|---|
| Build | Gagal, parameter wajib `onRefresh` tidak dikirim | `lib/main.dart:46`, `lib/main.dart:47` |
| Tes | 9 tes lulus, hanya logika murni | `test/readadapt_test.dart` |
| Mikrofon | Izin Android dan iOS tidak ditemukan, locale `id_ID` tidak diatur | `AndroidManifest.xml`, `Info.plist`, `practice_screen.dart:91` |
| Status rekam | `_merekam` langsung `false` setelah `listen()` | `practice_screen.dart:91-95` |
| Sesi | Jawaban salah hanya bisa "Ulangi", sesi bisa macet | `practice_screen.dart:896-903` |
| Level | Perubahan level tidak mengganti antrian kata | `practice_screen.dart:103-116` |
| Isi sesi | 6 sampai 8 kata, bukan 10 seperti `docs/FLOW.md` | `lib/data.dart` |
| Navigasi | Onboarding tidak terpakai, tab Cerita placeholder | `lib/main.dart:48` |
| Text-to-speech | Belum ada, padahal wajib (RA-PRD-601) | `pubspec.yaml` |
| Penyimpanan | Daftar sesi disimpan sebagai satu JSON di `shared_preferences`, hasil per kata tidak tersimpan | `lib/store.dart:54-61` |
| Pengaturan | Huruf ramah dan penggaris tidak berefek, ukuran huruf tidak bisa diubah | `lib/store.dart:169-175` |
| Backend | Belum ada, padahal PRD 2.1 dan 2.6 menyebut lokal dan/atau cloud | `pubspec.yaml` |

## Angka dan klaim yang harus dihapus

| Tampilan | Masalah | Lokasi |
|---|---|---|
| "Mengurangi kelelahan mata 78%" | Tanpa sumber | `home_screen.dart:302` |
| "96% Lancar" | Ditulis langsung di kode | `home_screen.dart:190` |
| "Adaptif AI" | Mesin berbasis aturan (PRD 1.2) | `home_screen.dart:479` |
| Skor fonologis | Akurasi total dikali 88 atau 96 | `progress_screen.dart:246`, `:256` |
| "Peningkatan X%" | Isinya akurasi, bukan peningkatan | `progress_screen.dart:340-343` |
| "Minggu ini", "Minggu ke-" | Menghitung semua sesi dan memakai nomor hari | `progress_screen.dart:159`, `:172` |
| "+10 Bintang" | Tidak pernah disimpan | `story_screen.dart:518` |

## Yang dipertahankan

- Logika dasar mesin adaptif dan tesnya, dengan aturan baru untuk hasil yang tidak terdengar jelas.
- Font Lexend.
- Isi `BankKata` dan `BankCerita` sebagai bahan awal, setelah ditinjau. Misalnya level 4 berlabel 3 suku kata tetapi berisi BINTANG yang hanya 2.
- Nama entitas domain dari PRD 3.1.

## Pembacaan referensi

### Referensi 1: aplikasi aktivitas (`referensi/ref-fitness-activities.png`)

| Yang dilihat | Dipakai untuk | Penyesuaian |
|---|---|---|
| Tiga kolom warna dengan puncak lengkung | Bentuk utama aplikasi, karena mirip lentera | Maksimal satu kolom besar di Mode Anak |
| Dasar sage dengan kartu putih menumpuk | Struktur semua layar | Kartu lebih sedikit di Mode Anak |
| Cincin mingguan | 7 lentera mingguan | Hari kosong tetap netral, tidak ada streak putus |
| Baris ikon bulat | Pilihan aktivitas | Ikon lebih besar dan selalu berlabel |
| Grafik batang dua warna | Tren di Area Pendamping | Hanya untuk pendamping |
| Kisi metrik | Ringkasan di Area Pendamping | Hanya metrik yang benar-benar terukur |
| Tombol kembali berbentuk pil | Navigasi layar turunan | Dipakai apa adanya |

### Referensi 2: aplikasi perjalanan (`referensi/ref-travel.png`)

| Yang dilihat | Dipakai untuk | Penyesuaian |
|---|---|---|
| Splash satu warna penuh | Layar pembuka | Tanpa gradien biru, memakai warna lentera |
| Sapaan dan avatar di atas | Beranda anak | Tanpa emoji di judul |
| Chip filter gelap | Filter level cerita | Hanya jika jumlah cerita sudah cukup |
| Kartu gambar besar dengan teks di atasnya | Sampul cerita | Teks di atas panel solid agar kontrasnya aman |
| Gambar penuh di atas layar detail | Detail cerita | Membutuhkan aset, lihat pertanyaan di README |
| Tombol utama hitam yang lebar | Aksi utama setiap layar | Dipakai, kontrasnya 15,88:1 |

### Yang sengaja tidak ditiru

- Teks abu-abu kecil dan paragraf pudar: anak disleksia butuh kontras dan ukuran yang cukup.
- Banyak angka di satu layar: anak tidak perlu melihat metrik.
- Seluruh tampilan salah satu aplikasi: referensi menjadi inspirasi (R-30). Identitasnya tetap harus milik Lentera.
