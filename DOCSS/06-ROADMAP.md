# 06. Roadmap

Urutan ini sengaja menguji risiko terbesar dulu. Estimasi durasi belum diberikan karena tenggat belum diketahui.

## Fase 0: Pengaman

- `git init`, commit kondisi awal, tambah `.claude` dan file besar sesuai kebijakan yang disepakati.
- Pindahkan PDF dan bahan tugas LMS yang tidak terkait dari akar project, setelah disetujui.
- Set `applicationId` final dan `minSdk` 26 (PRD: Android 8.0).
- Tambah izin mikrofon di Android dan iOS.

**Selesai jika:** `flutter analyze` tanpa error, build Android berjalan, dan kondisi awal tersimpan di git.

## Fase 1: Uji ucapan

- Aplikasi uji kecil, terpisah dari UI utama, memakai port `SpeechRecognizer`.
- Bandingkan `speech_to_text` dengan minimal satu engine on-device.
- Sampel: seluruh `BankKata`, dari anak atau relawan, pada minimal 2 HP.
- Ukur kecocokan, salah terima, salah tolak, waktu respons, kemampuan luring, dan ke mana suara dikirim.

**Selesai jika:** engine dipilih dengan data, aturan `SpeechMatcher` ditetapkan, dan hasilnya dicatat di `DOCSS/adr/`.

Jika tidak ada engine yang cukup akurat untuk suku kata tunggal, level 1 berubah menjadi latihan dengar dan pilih, atau menjadi latihan berpendamping.

## Fase 2: Fondasi

- Struktur folder, Riverpod, `go_router`, skema Drift dan outbox.
- `PracticeSession`, `AdaptiveEngine`, `SpeechMatcher`, statistik.
- Konten JSON dari `BankKata` yang sudah ditinjau.

**Selesai jika:** satu sesi penuh berjalan lewat tes tanpa UI, termasuk semua status dan pemulihan sesi terputus.

## Fase 3: Satu alur utuh dengan desain baru

- Design system dari `DESIGN.md`.
- A3, A4, A5, A6, audio contoh, gerak dasar.
- Uji di HP sungguhan lalu tinjau bersama sebelum lanjut.
- Verifikasi berat font Lexend dan kontras pada perangkat.

**Selesai jika:** satu sesi nyata berjalan di HP tanpa error, ukuran teks besar tidak merusak layout, dan Anda menyetujui tampilannya. Ini titik keputusan arah visual.

## Fase 4: Sisi anak lengkap

- Onboarding, persetujuan, PIN, pilih profil.
- Beda Huruf, Rak Cerita, Baca Cerita, penggaris, Koleksi.
- Semua keadaan kosong, memuat, gagal, dan tanpa izin mikrofon.

**Selesai jika:** tidak ada tombol mati dan seluruh flow di `02-PRODUK-DAN-FLOW.md` bisa ditelusuri di HP.

## Fase 5: Area Pendamping

- P1 sampai P6, statistik sesuai definisi di matriks, koreksi "Sudah benar".
- Ekspor laporan PDF.

**Selesai jika:** semua angka bisa ditelusuri ke `attempts` lewat tes, dan tidak ada angka buatan yang tersisa.

## Fase 6: Backend

- Proyek Supabase, skema SQL sebagai file migrasi, RLS, dan tes RLS.
- Auth pendamping dan P7.

**Selesai jika:** pengguna tanpa izin terbukti tidak bisa membaca data anak lain.

## Fase 7: Sinkron

- `SyncEngine`, push, pull, konflik, penghapusan, dan kode kelas guru.

**Selesai jika:** skenario dua perangkat lulus: luring di keduanya, lalu daring, data tergabung tanpa duplikat, dan pencabutan izin langsung berlaku setelah sinkron.

## Fase 8: Finalisasi

- Black-box test untuk RA-PRD-101 sampai 601 (PRD 4.1).
- Uji usability dengan pengguna target jika tersedia.
- Pengukuran waktu respons pada 2 HP.
- Delivery Gate anti-slop dengan catatan klik per elemen.
- Dokumen kebijakan privasi, README, APK rilis.

**Selesai jika:** semua indikator di PRD 4.4 terpenuhi dengan bukti.

## Jika waktu kurang

Urutan pemangkasan:

1. Kode kelas guru (Fase 7), diganti ekspor laporan.
2. Sinkron dua arah, diganti cadangan data satu arah.
3. Rak Cerita, dibatasi satu cerita.
4. Ekspor PDF.

Yang tidak boleh dipangkas: uji ucapan, satu alur latihan yang andal, Area Pendamping dengan data jujur, dan persetujuan.

## Risiko

| Risiko | Dampak | Penanganan |
|---|---|---|
| Speech tidak akurat untuk suara anak | Anak merasa salah padahal benar | Fase 1, status tidak jelas, koreksi pendamping |
| Suara anak dikirim ke layanan pihak ketiga | Masalah privasi | Dicek di Fase 1, diutamakan on-device |
| Ilustrasi belum tersedia | Tampilan referensi tidak tercapai | Konfirmasi sumber aset sebelum Fase 4 |
| Cakupan terlalu luas untuk tenggat | Tidak ada versi yang selesai | Fase dikerjakan berurutan, ada daftar pemangkasan |
| Belum ada pengguna target untuk diuji | Kebutuhan tidak tervalidasi | Relawan, dan batasannya dicatat di laporan |
