# DESIGN.md: Lentera

Status: mengikuti aplikasi yang sudah dibangun, 31 Oktober 2026. Arah ditetapkan pemilik: dekat dengan dua referensi di `referensi/`, warna hidup, tanpa bentuk lengkung, ilustrasi digambar dengan kode. Sumber token: `lib/core/design/tokens.dart`.

Dial: ENERGY 2 / RHYTHM 2 / MOTION 1

## Warna

| Token | Hex | Peran |
|---|---|---|
| `ground` | `#F3F5F0` | Dasar layar |
| `surface` | `#FFFFFF` | Kartu |
| `ink` | `#121A18` | Teks, tombol utama, panel di atas gambar |
| `subInk` | `#4A5654` | Teks kedua |
| `deep` | `#0E4C63` | Layar pembuka |
| `lantern` | `#FFC22E` | Aksen utama, bidang kata, logo |
| `sky` | `#49A9EE` | Kategori huruf |
| `leaf` | `#35B779` | Kategori cerita, kata terbaca, cincin selesai |
| `ok` | `#0F6B45` | Status benar, selalu dengan ikon |
| `retry` | `#7A5600` | Status coba lagi, selalu dengan ikon telinga |
| `letterB` | `#1D5C8C` | Penanda huruf b |
| `letterD` | `#9A4A00` | Penanda huruf d |

Kontras terhitung: `ink` di `lantern` 10,96, di `leaf` 6,91, di `sky` 6,90, di `ground` 16,12. `subInk` di putih 7,64. `ok` di putih 6,54. `retry` di putih 6,65. `letterB` di `lantern` 4,39 dan `letterD` di `lantern` 3,88, jadi keduanya hanya untuk teks besar.

Merah tidak dipakai untuk kesalahan anak.

## Huruf

Lexend (font variabel, berat lewat sumbu `wght`). Kata target 72, judul 30, bacaan 26, teks anak 18, teks pendamping 16, terkecil 14.

## Bentuk dan komponen

- Kartu radius 28, ubin 20, tombol utama hitam tinggi 64.
- Tanpa bayangan pada kartu. Pemisahan lewat warna.
- `SceneArt`: ilustrasi datar buatan kode, dipotong seperti gambar cover.
- Kartu gambar dengan panel gelap (referensi travel): Beranda dan Rak Cerita.
- `DayRing`, `WeekLanterns`: cincin mingguan (referensi fitness).
- `ActivityCircle`: baris aktivitas bulat (referensi fitness).
- `_Pillar` dan `TrendBars`: tiga kolom warna dan batang berlapis, hanya di Area Pendamping.
- `WordField`: bidang warna penuh untuk kata, berubah hijau saat terbaca.
- `LogoMark`: huruf L hitam di atas kuning, sama dengan ikon Android.

## Gerak

Perubahan warna bidang kata, denyut saat mendengarkan, dan cincin tahan pada Area Pendamping. Semua mengikuti pengaturan kurangi gerakan.

## Alur masuk

Anak memasukkan nama atau menyentuh namanya sebelum Beranda, dan keluar lewat avatar. Ini identifikasi, bukan keamanan: nama tidak memakai kata sandi. Profil baru butuh PIN pendamping.
