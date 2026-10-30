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
