---
version: 1
slug: "lib-app-app-dart"
primary_target: "lib/app/app.dart"
related_targets: ["lib"]
---

# Lentera app (seluruh aplikasi Flutter)

Mode: Operate (Mode Anak dan Area Pendamping). Platform: android utama, iOS, ponsel sampai tablet.
Audiens: anak disleksia 7-10 tahun dengan pendamping; orang tua dan guru.
Tugas: dengar lalu ucapkan kata, susun suku kata, dengar dan pilih, beda huruf, baca cerita. Pendamping memantau data nyata.
Batas: tidak ada merah untuk kesalahan anak, tap target anak 56, teks bacaan di atas bidang polos, semua angka dari log.

## Direction contract

THESIS: Membaca adalah menenun. Setiap kata yang selesai menjadi satu benang, setiap sesi menjadi satu pita kain, dan seminggu menjadi selembar kain milik anak. Aplikasi ini menolak susunan bawaan aplikasi belajar anak: maskot, jalur level, dan kartu bulat pastel.

OWN-WORLD: Ground biru kapas yang dicelup tarum (#EEF1F8), dengan malam tarum (#0F1430) untuk tema gelap. Benang punya peran tetap: kunyit untuk Baca, tarum muda untuk Huruf, daun untuk Cerita, jingga untuk Susun, laut (#4FB8C6) untuk Dengar dan Pilih. Laut ditambahkan saat build karena aktivitas kelima butuh benangnya sendiri. Kesumba (merah muda) hanya untuk hal yang sedang aktif, termasuk indikator navigasi, pilihan segmen, dan chip terpilih. Pinggir kain (selvedge) bergaris menjadi tepi panel. Sudut tegas berradius 12-16, tanpa bayangan, dengan Lexend. Permukaan baca hanya dua tinta.

STORY: Anak membuka aplikasi dan langsung melihat kainnya tumbuh. Anak menekan Mulai Baca, lalu setiap kata yang selesai menenun satu benang ke pita sesi di atas layar. Pendamping melihat angka jujur dengan skala tetap.

FIRST VIEWPORT: Beranda di ponsel menampilkan sapaan dan avatar motif di atas. Di bawahnya ada panel kunyit setinggi kira-kira 45% layar dengan slot benang sesi dan tombol tarum Mulai Baca di zona jempol, lalu pita kain minggu ini dengan 7 kolom benang. Di tablet, navigasi menjadi rail di kiri, panel Baca dan kain mingguan berdampingan, dan aktivitas ada di kolom kanan.

FORM: Tenun Kata, kandidat 7 dari daftar grounded, seed 6cb73057. Raise: dua tinta di permukaan baca (Ikeda), satu warna aktif (orienteering), skala tetap (folio botani), slot sesi pasti (j-card), kode warna aktivitas (Saville). Terjemahan: Susun memakai jingga karena kesumba dicadangkan untuk keadaan aktif.

Signature interaction: benang ditenun masuk ke slot pita sesi saat kata selesai, dari kiri dengan ease-out eksponensial 420ms. Saat kurangi gerakan aktif, benang muncul langsung.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
