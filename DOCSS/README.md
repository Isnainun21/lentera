# DOCSS: rencana rombak Lentera Membaca

Folder ini sumber kebenaran untuk rombak aplikasi. Kode belum diubah. Implementasi dimulai setelah keputusan di bawah disetujui.

| File | Isi |
|---|---|
| [01-PEMAHAMAN.md](01-PEMAHAMAN.md) | Kondisi project sekarang dan pembacaan referensi UI |
| [02-PRODUK-DAN-FLOW.md](02-PRODUK-DAN-FLOW.md) | Peran pengguna, daftar layar, dan flow |
| [DESIGN.md](DESIGN.md) | Arah visual: warna, huruf, bentuk, komponen, gerak |
| [04-ARSITEKTUR-DAN-BACKEND.md](04-ARSITEKTUR-DAN-BACKEND.md) | Struktur kode, database lokal, Supabase, protokol sinkron |
| [05-MATRIKS-SINKRON.md](05-MATRIKS-SINKRON.md) | Hubungan layar, use case, tabel, sinkronisasi, dan requirement PRD |
| [06-ROADMAP.md](06-ROADMAP.md) | Fase kerja dan syarat selesai |
| [referensi/](referensi/) | Dua gambar referensi UI |

## Ringkasan keputusan

| Topik | Keputusan | Status |
|---|---|---|
| Nama aplikasi | Lentera. ReadAdapt tetap nama proyek di dokumen akademik | Usulan, perlu konfirmasi |
| Arah UI | Bahasa visual dari kedua referensi, dengan motif lengkung lentera | Usulan, perlu konfirmasi |
| Dua mode | Mode Anak sederhana, Area Pendamping lebih padat dan terkunci | Usulan |
| Backend | Local-first dengan Drift, lalu sinkron ke Supabase | Usulan, perlu konfirmasi |
| Akun | Hanya pendamping yang punya akun. Anak tidak login | Usulan |
| Rekaman suara | Tidak pernah disimpan atau diunggah | Usulan. Lebih ketat dari PRD 2.7 |
| Engine ucapan | Belum diputuskan, menunggu hasil uji di Fase 1 | Terbuka |

## Pertanyaan yang masih terbuka

1. **Tenggat:** kapan aplikasi harus selesai? Jawaban ini menentukan apakah cerita dan laporan PDF ikut versi pertama.
2. **Ilustrasi:** referensi mengandalkan gambar besar. Dari mana sumbernya: Anda sediakan, kita buat dengan generator gambar, atau bentuk sederhana yang digambar dengan kode? Sampai ada jawaban, rencana memakai bidang warna polos sebagai placeholder yang jelas.
3. **Warna salah:** PRD meminta suku kata meleset ditandai merah. Rencana ini memakai kuning tua dengan ikon telinga, supaya anak tidak merasa dihukum. Setujukah menyimpang dari PRD di bagian ini?
4. **Mitra uji:** apakah ada anak, relawan, atau SLB untuk merekam sampel suara di Fase 1?

## Status implementasi (31 Oktober 2026)

| Fase | Status |
|---|---|
| 0 Pengaman | Selesai, kecuali `applicationId` final |
| 1 Uji ucapan | Alat uji ada di Area Pendamping. Belum diuji dengan suara sungguhan |
| 2 Fondasi | Selesai |
| 3 dan 4 Sisi anak | Selesai, termasuk masuk dan keluar dengan nama |
| 5 Area Pendamping | Selesai, tampilan belum diperiksa di perangkat |
| 6 dan 7 Backend dan sinkron | Kode dan skema SQL selesai, diuji dengan server tiruan. Belum dijalankan pada Supabase sungguhan |
| 8 Finalisasi | Belum. APK masih ditandatangani kunci debug |

## Rombak UI Tenun Kata (26 November 2026)

| Bagian | Status |
|---|---|
| Dunia visual | Tenun Kata: benang kunyit, tarum muda, daun, jingga, dan laut, dengan kesumba khusus untuk keadaan aktif. Token di `lib/core/design/tokens.dart` |
| Responsif | Navigasi bar bawah di ponsel dan rail di lipat atau tablet. Layar terbagi dua di tablet dan saat landscape. Diuji di 320, 390, 844 landscape, 800, dan 1280 |
| Tema | Terang, gelap, atau ikut sistem, diatur di Area Pendamping |
| Fitur baru anak | Susun Kata, Dengar dan Pilih, Beda Huruf 12 soal (6 per sesi), Kamus Kataku, karaoke dan ketuk kata di cerita, 3 cerita baru, Kain-ku dan stiker motif, avatar motif |
| Fitur baru pendamping | Keypad PIN, ganti anak, grafik 7 dan 30 hari, Semua kata dengan detail per kata, warna latar bacaan, jarak huruf |
| Belum | Pengingat latihan harian (butuh plugin notifikasi dan uji di perangkat), uji di HP dan tablet sungguhan |

Statistik: Susun Kata dan Dengar dan Pilih dicatat terpisah. Keduanya tidak menguji ucapan, jadi tidak ikut ketepatan membaca.
