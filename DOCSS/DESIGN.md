---
name: Lentera
description: Tenun Kata. Membaca adalah menenun, setiap kata yang selesai menjadi satu benang.
colors:
  kunyit: "#F2B233"
  tarum-muda: "#5B8DEF"
  daun: "#45B07E"
  jingga: "#F39552"
  laut: "#4FB8C6"
  kesumba: "#F07A98"
  tarum: "#1E2A5E"
  on-thread: "#0F1430"
  ground: "#EEF1F8"
  surface: "#FFFFFF"
  surface-alt: "#E1E6F2"
  ink: "#0F1430"
  sub-ink: "#3C4466"
  line: "#CBD2E4"
  empty: "#D3D9EA"
  ok: "#0F6B45"
  ok-soft: "#D5F2E2"
  retry: "#7A5600"
  retry-soft: "#FFEFC2"
  letter-b: "#1D4FA8"
  letter-d: "#A4470A"
  letter-b-on-thread: "#1D3F8F"
  letter-d-on-thread: "#8A3A08"
  ground-dark: "#0F1430"
  surface-dark: "#1A2147"
  surface-alt-dark: "#252D5A"
  ink-dark: "#F1F3FA"
  sub-ink-dark: "#B9BFDA"
  line-dark: "#39427A"
  empty-dark: "#2E3768"
  ok-dark: "#6FD9A3"
  ok-soft-dark: "#173F35"
  retry-dark: "#F2C062"
  retry-soft-dark: "#3D3420"
  letter-b-dark: "#9DBBFF"
  letter-d-dark: "#FFAE73"
  tint-kuning: "#FFF3C4"
  tint-kuning-dark: "#3A3416"
  tint-biru: "#DCEBFF"
  tint-biru-dark: "#1C2D4D"
  tint-hijau: "#DDF5E6"
  tint-hijau-dark: "#173A2A"
  tint-merah-muda: "#FFE3EC"
  tint-merah-muda-dark: "#45222F"
typography:
  word-hero:
    fontFamily: "Lexend"
    fontSize: "72px"
    fontWeight: 700
    lineHeight: 1.05
    letterSpacing: "1.5px"
  syllable:
    fontFamily: "Lexend"
    fontSize: "34px"
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: "1.4px"
  display:
    fontFamily: "Lexend"
    fontSize: "40px"
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "-0.6px"
  title:
    fontFamily: "Lexend"
    fontSize: "28px"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.3px"
  heading:
    fontFamily: "Lexend"
    fontSize: "21px"
    fontWeight: 650
    lineHeight: 1.3
  reading:
    fontFamily: "Lexend"
    fontSize: "26px"
    fontWeight: 500
    lineHeight: 1.6
    letterSpacing: "0.8px"
  body:
    fontFamily: "Lexend"
    fontSize: "18px"
    fontWeight: 400
    lineHeight: 1.45
  body-strong:
    fontFamily: "Lexend"
    fontSize: "18px"
    fontWeight: 600
    lineHeight: 1.45
  body-guardian:
    fontFamily: "Lexend"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.45
  label:
    fontFamily: "Lexend"
    fontSize: "15px"
    fontWeight: 600
    lineHeight: 1.3
  caption:
    fontFamily: "Lexend"
    fontSize: "14px"
    fontWeight: 500
    lineHeight: 1.4
  metric:
    fontFamily: "Lexend"
    fontSize: "34px"
    fontWeight: 700
    lineHeight: 1.05
    letterSpacing: "-0.5px"
rounded:
  thread: "3px"
  column: "6px"
  indicator: "10px"
  tile: "12px"
  button: "14px"
  panel: "16px"
spacing:
  s1: "4px"
  s2: "8px"
  s3: "12px"
  s4: "16px"
  s5: "24px"
  s6: "32px"
  s7: "48px"
  gutter: "20px"
  gutter-medium: "28px"
  gutter-expanded: "36px"
  tap-child: "56px"
  tap-guardian: "48px"
  reading-width: "720px"
  content-width: "1100px"
components:
  button-primary:
    backgroundColor: "{colors.tarum}"
    textColor: "{colors.surface}"
    typography: "{typography.body-strong}"
    rounded: "{rounded.button}"
    height: "60px"
  button-primary-dark:
    backgroundColor: "{colors.kunyit}"
    textColor: "{colors.on-thread}"
    typography: "{typography.body-strong}"
    rounded: "{rounded.button}"
    height: "60px"
  button-primary-on-thread:
    backgroundColor: "{colors.tarum}"
    textColor: "{colors.surface}"
    typography: "{typography.body-strong}"
    rounded: "{rounded.button}"
    height: "60px"
  button-primary-disabled:
    backgroundColor: "{colors.surface-alt}"
    textColor: "{colors.sub-ink}"
    rounded: "{rounded.button}"
    height: "60px"
  button-quiet:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.body-strong}"
    rounded: "{rounded.button}"
    height: "56px"
  button-quiet-destructive:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.retry}"
    rounded: "{rounded.button}"
    height: "56px"
  icon-button:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.tile}"
    size: "48px"
  panel:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.panel}"
    padding: "20px"
  panel-thread:
    backgroundColor: "{colors.kunyit}"
    textColor: "{colors.on-thread}"
    rounded: "{rounded.panel}"
    padding: "20px"
  syllable-tile:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.syllable}"
    rounded: "{rounded.tile}"
    padding: "8px 14px"
    size: "84px"
  syllable-tile-active:
    backgroundColor: "{colors.kesumba}"
    textColor: "{colors.on-thread}"
    rounded: "{rounded.tile}"
  syllable-tile-correct:
    backgroundColor: "{colors.ok-soft}"
    textColor: "{colors.ok}"
    rounded: "{rounded.tile}"
  syllable-tile-retry:
    backgroundColor: "{colors.retry-soft}"
    textColor: "{colors.retry}"
    rounded: "{rounded.tile}"
  nav-bar:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.sub-ink}"
    typography: "{typography.caption}"
    height: "76px"
  nav-indicator-active:
    backgroundColor: "{colors.kesumba}"
    textColor: "{colors.on-thread}"
    rounded: "{rounded.indicator}"
  segment-selected:
    backgroundColor: "{colors.kesumba}"
    textColor: "{colors.on-thread}"
    typography: "{typography.label}"
    rounded: "{rounded.tile}"
    height: "48px"
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.body-guardian}"
    rounded: "{rounded.tile}"
  reading-field:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.reading}"
    rounded: "{rounded.panel}"
  thread-slot-empty:
    backgroundColor: "{colors.empty}"
    rounded: "{rounded.thread}"
    height: "14px"
  week-column:
    backgroundColor: "{colors.surface-alt}"
    rounded: "{rounded.column}"
  pin-key:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.title}"
    rounded: "{rounded.tile}"
    height: "64px"
  snackbar:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.ground}"
    typography: "{typography.body-guardian}"
    rounded: "{rounded.tile}"
---

# Design System: Lentera

Status: dicatat dari aplikasi yang sudah dibangun dan lolos finish review (ship, setelah dua putaran perbaikan), 26 November 2026. Dunia visual "Tenun Kata" menggantikan seluruh dunia lama (lantern, kartu radius 28, cincin mingguan). Sumber token: `lib/core/design/tokens.dart`. Bukti render: `build/screens/*.png` (170 tangkapan, 5 ukuran layar, terang dan gelap, 17 rute) dan salinan pilihan di `.impeccable/review/`.

Satuan "px" di frontmatter adalah logical pixel Flutter.

## Overview

**Creative North Star: "Tenun Kata"**

Membaca adalah menenun. Setiap kata yang selesai menjadi satu benang, setiap sesi menjadi satu pita kain, dan seminggu menjadi selembar kain milik anak. Benang punya warna tetap per aktivitas, pinggir kain bergaris lurik menjadi tepi panel, dan motif tenun serta batik (kawung, tumpal, ceplok, parang, lurik, ikat) yang digambar dengan kode menjadi avatar dan stiker. Tidak ada maskot, tidak ada jalur level, tidak ada kartu bulat pastel.

Dasarnya biru kapas yang dicelup tarum di tema terang dan malam tarum di tema gelap. Benang tetap sama di kedua tema karena teks di atasnya selalu tinta gelap `on-thread`. Bidang datar, tanpa bayangan, sudut tegas 12 sampai 16. Satu huruf, Lexend, untuk semuanya. Permukaan baca hanya memakai dua tinta, dan satu warna saja, kesumba, menandai apa yang sedang aktif.

Area Pendamping memakai dunia yang sama dengan kepadatan lebih tinggi: teks 16, tap target 48, angka dengan skala tetap supaya minggu sepi tidak terlihat setinggi minggu ramai.

**Key Characteristics:**
- Benang berwarna tetap per aktivitas: kunyit Baca, tarum muda Beda Huruf, daun Cerita, jingga Susun, laut Dengar dan Pilih.
- Kesumba hanya untuk keadaan aktif.
- Datar dan tanpa bayangan; kedalaman dari warna bidang dan pinggir kain.
- Sudut tegas 3 sampai 16, tidak ada bentuk pil atau lingkaran pada wadah.
- Lexend variabel di seluruh aplikasi, berat lewat sumbu `wght`.
- Ilustrasi cerita dan motif digambar dengan kode, bergaya datar.

## Colors

Lima benang jenuh di atas dasar biru kapas, satu tarum dalam untuk aksi, dan satu kesumba untuk keadaan aktif.

### Primary
- **Tarum** (`tarum`): tombol utama di tema terang dan di atas bidang benang di kedua tema, latar layar pembuka, tinta pinggir kain pada logo. Putih di atas tarum 13,57.
- **Kunyit** (`kunyit`): benang Baca Kata dan bidang kata (panel "Baca 6 kata hari ini", bidang kata sesi). Menjadi tombol utama di tema gelap dengan tinta `on-thread`. `on-thread` di atas kunyit 9,62.

### Secondary
Benang aktivitas. Selalu dengan tinta `on-thread` di atasnya, sama di terang dan gelap.
- **Tarum Muda** (`tarum-muda`): Beda Huruf. Kontras tinta 5,59.
- **Daun** (`daun`): Cerita. Kontras tinta 6,68.
- **Jingga** (`jingga`): Susun Suku Kata. Kontras tinta 7,94.
- **Laut** (`laut`): Dengar dan Pilih. Ditambahkan saat build karena aktivitas kelima butuh benangnya sendiri. Kontras tinta 7,74. Juga menggantikan warna cerita `pink` dari data konten.

### Tertiary
- **Kesumba** (`kesumba`): satu-satunya warna keadaan aktif. Indikator navigasi, segmen dan chip terpilih, suku kata yang sedang didengar, kata yang sedang dibacakan, slot sesi aktif (garis 2,5), cincin mikrofon saat mendengarkan, pilihan level dan pilihan jawaban Beda Huruf. Kontras tinta 6,83.

### Neutral
- **Biru Kapas** (`ground` / `ground-dark`): dasar layar. Tinta terang di atasnya 15,97; tinta gelap di atas malam tarum 16,29.
- **Permukaan** (`surface`, `surface-alt` dan pasangan `-dark`): panel, ubin, kolom kain minggu (`surface-alt`), tombol nonaktif.
- **Tinta** (`ink`, `sub-ink` dan pasangan `-dark`): teks utama dan teks kedua. `sub-ink` di permukaan putih 9,5; di permukaan gelap 8,52.
- **Garis** (`line`): tepi ubin diam, tepi tombol tenang, pembagi, garis bantu grafik.
- **Slot Kosong** (`empty`): slot benang yang belum terisi dan jalur progres.
- **Status** (`ok`, `ok-soft`, `retry`, `retry-soft`): tepat dan coba lagi. `ok` di putih 6,54; `retry` di putih 6,65; `retry` di `retry-soft` 5,82; `ok` di `ok-soft` 5,49. Status selalu ditemani ikon (centang, telinga).
- **Penanda Huruf** (`letter-b`, `letter-d`, dan varian `-on-thread` untuk bidang kunyit): mewarnai b dan d. Di putih 7,68 dan 6,03. Di kunyit 5,18 dan 4,16, jadi varian `-on-thread` hanya dipakai di ukuran suku kata ke atas.
- **Lapisan Bacaan** (`tint-*`): pilihan pendamping untuk latar bacaan (kuning, biru, hijau, merah muda), satu nilai terang dan satu gelap.

### Named Rules
**The Satu Warna Aktif Rule.** Kesumba hanya menandai hal yang sedang aktif. Tidak pernah dipakai sebagai benang aktivitas, dekorasi, atau status. Karena itu Susun memakai jingga dan warna cerita `pink` dipetakan ke laut.

**The Tanpa Merah Rule.** Tidak ada merah untuk kesalahan anak. "Coba lagi" adalah `retry` cokelat kunyit dengan ikon telinga; ThemeData `error` juga dipetakan ke `retry`.

**The Benang Tetap Rule.** Warna benang tidak berubah antara terang dan gelap, dan teks di atasnya selalu `on-thread`. Hanya tombol di atas bidang benang yang memakai tarum dengan teks putih.

## Typography

**Display Font:** Lexend (font variabel bundel)
**Body Font:** Lexend
**Label/Mono Font:** Lexend

**Character:** Satu keluarga yang dirancang untuk kemudahan baca, dibedakan hanya lewat ukuran, berat, dan jarak huruf. Huruf untuk anak dilebarkan jaraknya; judul dirapatkan.

### Hierarchy
- **Word Hero** (700, 72, 1.05, jarak +1.5): kata target. Di layar diskalakan per konteks (52 pada sesi ponsel, 80 pada sesi lebar, 112 pada huruf Beda Huruf, 56 pada Dengar dan Pilih), selalu dalam `FittedBox`.
- **Syllable** (700, 34, 1.15, jarak +1.4): suku kata di ubin.
- **Display** (700, 40, 1.1, jarak -0.6): judul panel utama Beranda.
- **Title** (700, 28, 1.2, jarak -0.3): judul layar, angka PIN.
- **Heading** (650, 21, 1.3): judul bagian, judul app bar dan dialog.
- **Reading** (500, 26, 1.6, jarak +0.8): teks cerita. Jarak huruf dan kata bisa ditambah pendamping.
- **Body / Body Strong** (400 / 600, 18, 1.45): teks anak dan label tombol.
- **Body Guardian** (400, 16, 1.45): teks Area Pendamping, isian, dialog, snackbar.
- **Label** (600, 15, 1.3): tombol teks dan segmen.
- **Caption** (500, 14, 1.4): label navigasi, hari pada kain, keterangan. Terkecil di sisi anak.
- **Metric** (700, 34, 1.05, jarak -0.5): angka ringkasan pendamping.

### Named Rules
**The Sumbu Berat Rule.** Lexend di project ini font variabel, jadi berat selalu dikirim lewat `FontVariation('wght')` sekaligus `fontWeight`. Gaya baru dibuat lewat `AppText`, bukan `TextStyle` lepas.

**The Dua Tinta Rule.** Teks bacaan berdiri di bidang polos (permukaan atau lapisan bacaan), tidak pernah di atas gambar atau pinggir kain, dan hanya memakai dua tinta: `ink` untuk baris aktif dan `sub-ink` untuk baris yang mundur saat penggaris baca menyala. Baris aktif diberi latar kunyit 35%; kata yang sedang dibacakan diberi latar kesumba dengan tinta `on-thread`.

## Layout

Struktur ditentukan dari lebar jendela, bukan jenis perangkat: compact di bawah 600, medium 600 sampai 839, expanded 840 ke atas. Gutter 20 / 28 / 36. Isi dibatasi `content-width` 1100 dan teks bacaan `reading-width` 720, dipusatkan dengan sisa ruang di kiri dan kanan.

- Compact: satu kolom, `NavigationBar` di bawah (tinggi 76). Aksi utama di zona jempol, di dalam panel kunyit Beranda.
- Medium dan expanded: `NavigationRail` di kiri dengan logo di atas. Beranda menjadi dua kolom: panel Baca dan cerita lanjutan di kiri, kain minggu dan aktivitas lain di kanan.
- `FlowColumns`: grid yang menyusun 1 sampai 3 kolom dari lebar minimum 300, jarak 12, tinggi baris mengikuti isi.
- Ponsel mendatar (`isShortLandscape`: lebar > tinggi dan tinggi < 560) memakai susunan khusus agar bidang kata dan mikrofon muat tanpa gulir.
- Ritme jarak 4 / 8 / 12 / 16 / 24 / 32 / 48. Panel berpadding 20; antarpanel 12 sampai 24.
- Teks diuji pada 160% skala font di 320x568.

**The Skala Tetap Rule.** Kain minggu (`WeekCloth`) punya tinggi kolom tetap (default 12 baris, 9 di Beranda supaya muat di atas navigasi); lebih dari itu ditulis `+n` di atas kolom. Grafik pendamping (`TrendBars`) berplafon paling sedikit 10 kata dan naik per 5. Tinggi tidak pernah dinormalisasi ke data minggu itu.

## Elevation & Depth

Datar sepenuhnya. Tidak ada bayangan pada panel, tombol, navigasi, atau app bar (elevation 0, scrolled-under 0). Pemisahan datang dari perbedaan bidang: `ground` di bawah, `surface` di atasnya, bidang benang jenuh untuk panel utama, dan `surface-alt` untuk lekukan seperti kolom kain. Pinggir kain bergaris memberi tepi panel penting tanpa garis tepi atau bayangan.

**The Kain Datar Rule.** Kedalaman hanya lewat warna bidang dan pinggir kain. Bila sebuah elemen perlu menonjol, ganti bidangnya, jangan beri bayangan.

## Shapes

Sudut tegas tapi lunak, bertingkat menurut ukuran: benang 3, kolom kain dan sorot kata 6, indikator navigasi 10, ubin dan isian 12, tombol 14, panel dan dialog 16. Avatar motif memakai radius 28% sisi, logo 22% sisi. Bottom sheet hanya membulat di atas (16).

Pinggir kain (`Selvedge`): pita garis tegak berulang dengan lebar 7-2-3-2-12-2-4-2-3-6 satuan (satuan = tinggi/4), warna bergiliran warna pemimpin, tinta, daun, tarum muda, jingga, laut. Tinggi 10 di panel, 14 di layar pembuka. Selalu di tepi atas, tidak pernah di balik teks.

Benang (`ThreadBar`, isi slot): bidang warna dengan tekstur silang `on-thread` 12% per 6, supaya terbaca sebagai kain dan bukan batang grafik.

## Components

### Buttons
- **Shape:** sudut 14.
- **Primary (`PrimaryAction`):** satu per layar, lebar penuh, tinggi 60, Body Strong. Tarum dengan teks putih di terang; kunyit dengan tinta `on-thread` di gelap. Di atas bidang benang selalu tarum dan putih di kedua tema. Ketukan memicu haptic selection.
- **Disabled:** `surface-alt` dengan `sub-ink`.
- **Quiet (`QuietAction`):** permukaan dengan garis `line`, tinggi 56, tinta `ink`; versi destruktif bertinta `retry`.
- **Icon (`RoundButton`):** walau namanya bulat, bentuknya persegi bersudut 12 di atas permukaan. 56 untuk tombol anak, 48 untuk pendamping.
- **Tekan:** ripple InkSparkle bawaan tema; tidak ada perubahan bayangan.

### Chips
- **Style:** `ChoiceChip` untuk filter level cerita dan lapisan bacaan, bersudut tegas.
- **State:** terpilih berlatar kesumba dengan tinta `on-thread`; tidak terpilih berlatar permukaan.

### Cards / Containers
- **Corner Style:** 16 (`Panel`).
- **Background:** `surface`, atau benang (kunyit untuk Baca) untuk panel aksi utama.
- **Shadow Strategy:** tidak ada, lihat Elevation & Depth.
- **Border:** tidak ada; pinggir kain opsional di atas lewat `selvedge`.
- **Internal Padding:** 20.

### Inputs / Fields
- **Style:** terisi `surface`, garis `line` 1, sudut 12, label Body Guardian `sub-ink`.
- **Focus:** garis berubah menjadi `ink` setebal 2.
- **Error:** pesan bertinta `retry`, tidak pernah merah.
- **Kontrol lain:** switch aktif `ok`; checkbox terisi `primary`; slider jalur `ink` setebal 6; segmen terpilih kesumba, tinggi minimal 48.

### Navigation
- **Compact:** `NavigationBar` permukaan, tinggi 76, ikon 26, label Caption. Aktif: indikator kesumba bersudut 10, ikon `on-thread`, label `ink` 700. Tidak aktif: `sub-ink` 500.
- **Wide:** `NavigationRail` dengan perilaku sama, label selalu tampil, logo di atas.
- **Transisi halaman:** predictive back di Android, Cupertino di iOS.

### Ubin Suku Kata (`SyllableTile`)
Minimal 84 persegi, sudut 12, Syllable. Diam: permukaan, garis `line` 1,5, penanda b/d opsional. Aktif: kesumba dengan ikon speaker. Tepat: `ok-soft`/`ok` dengan centang. Coba lagi: `retry-soft`/`retry` dengan ikon telinga. Perubahan warna 160 ms.

### Pita Sesi (`ThreadSlots`)
Satu slot per kata yang direncanakan, jarak 4, tinggi 14, sudut 3. Slot kosong `empty` (di atas bidang benang: `on-thread` 18%). Slot aktif bergaris kesumba 2,5. Interaksi khas: benang ditenun masuk dari kiri selama 420 ms dengan ease-out eksponensial `(0.16, 1, 0.3, 1)`; saat kurangi gerakan aktif, benang muncul langsung.

### Kain Minggu (`WeekCloth`)
Tujuh kolom Senin sampai Minggu, jarak 8, kolom `surface-alt` sudut 6, benang setinggi 7 berjarak 3, skala tetap per layar (9 baris di Beranda). Hari ini bergaris `ink` 2 dan labelnya `ink` 700.

### Motif dan Avatar (`MotifTile`, `AvatarMotif`, `LogoMark`)
Enam motif digambar dengan kode di atas lima benang (tanpa kesumba). Logo: huruf L `on-thread` di atas kunyit dengan dua benang kecil tarum dan jingga di kakinya, sama dengan ikon aplikasi.

### Pendukung
- **`StatusLine`:** ikon 28 berwarna status plus teks Body Strong, live region. Warna tidak pernah tanpa ikon.
- **`HoldToOpen`:** tahan 3 detik untuk membuka Area Pendamping, cincin progres `ink` 42 di area 48.
- **`PinPad`:** tombol 64 tinggi bersudut 12, angka Title, titik persegi 20 bersudut 4 bergaris `ink`. PIN tidak pernah tampil.
- **`MessageState`:** motif 72 di `surface-alt` bertinta `sub-ink`, judul Heading, isi Body Guardian.
- **Gerak:** `quick` 160 ms untuk perubahan keadaan, `panel` 240 ms, `weave` 420 ms; semua memakai kurva yang sama dan mematuhi kurangi gerakan.

## Do's and Don'ts

### Do:
- **Do** pakai kesumba hanya untuk hal yang sedang aktif, dengan tinta `on-thread` (6,83).
- **Do** pakai benang aktivitas sesuai perannya (kunyit Baca, tarum muda Huruf, daun Cerita, jingga Susun, laut Dengar dan Pilih), selalu dengan tinta `on-thread`.
- **Do** beri tap target 56 untuk semua yang disentuh anak dan 48 untuk Area Pendamping.
- **Do** letakkan teks bacaan di bidang polos dengan dua tinta saja, `ink` dan `sub-ink`.
- **Do** jaga skala tetap: kain minggu bertinggi kolom tetap, grafik pendamping berplafon minimal 10 naik per 5.
- **Do** temani setiap warna status dengan ikon.
- **Do** satu `PrimaryAction` per layar; aksi lain memakai `QuietAction`.
- **Do** pakai `Pal.of(context)` untuk warna yang berubah tema dan `Thread` untuk warna benang.

### Don't:
- **Don't** pakai merah untuk kesalahan anak, termasuk lewat `error` bawaan Material.
- **Don't** pakai kesumba sebagai benang aktivitas, warna kategori, atau dekorasi.
- **Don't** beri bayangan pada panel, tombol, atau navigasi.
- **Don't** letakkan teks di atas pinggir kain atau di atas ilustrasi.
- **Don't** normalisasi tinggi kain minggu atau grafik ke data minggu itu.
- **Don't** pakai warna penanda huruf varian `-on-thread` di bawah ukuran suku kata (letter-d di kunyit hanya 4,16).
- **Don't** kembali ke maskot, jalur level, atau kartu bulat pastel.
