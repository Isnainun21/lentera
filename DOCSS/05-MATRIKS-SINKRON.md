# 05. Matriks sinkron

Dokumen ini memastikan UI, flow, data, dan backend saling cocok. Setiap fitur baru menambah satu baris di sini. Baris tanpa tabel atau tanpa aturan sinkron berarti belum siap dibangun.

## Layar ke data

| Layar | Use case | Baca dari | Tulis ke | Ke server | Requirement |
|---|---|---|---|---|---|
| A2 Pilih profil | `SelectChild` | `children` | Pilihan lokal | Tidak | RA-PRD-101 |
| A3 Beranda | `WatchHome` | `children`, `level_events`, `reward_events`, `practice_sessions` | Tidak ada | Tidak | RA-PRD-101, 501 |
| A4 Latihan | `StartSession`, `SubmitSpeech` | Konten, `level_events` | `practice_sessions`, `attempts` | Ya, ditambah | RA-PRD-201, 202 |
| A5 Umpan balik | `FinishWord` | State sesi | `attempts`, `level_events` | Ya, ditambah | RA-PRD-301, 401 |
| A6 Ringkasan | `FinishSession` | `attempts` | `practice_sessions`, `reward_events` | Ya | RA-PRD-501 |
| A7 Beda Huruf | `SubmitLetterAnswer` | Konten | `practice_sessions`, `attempts` | Ya, ditambah | Tambahan di luar PRD |
| A8 Rak Cerita | `WatchStories` | Konten, `story_progress` | Tidak ada | Tidak | Tambahan di luar PRD |
| A9 Baca Cerita | `SaveStoryPage`, `FinishStory` | Konten, `story_progress` | `story_progress`, `reward_events` | Ya | Tambahan, PRD 2.7 |
| A10 Koleksi | `WatchRewards` | `reward_events` | Tidak ada | Tidak | Motivasi anak |
| P1 PIN | `UnlockGuardian` | Hash PIN lokal | Tidak ada | Tidak | PRD 2.5 |
| P2 Persetujuan | `GrantConsent` | Teks versi persetujuan | `consents` | Ya, ditambah | PRD 2.5, 2.7 |
| P3 Ringkasan | `WatchChildSummary` | `attempts`, `level_events`, `practice_sessions` | Tidak ada | Ditarik | RA-PRD-501 |
| P4 Riwayat | `WatchSessions` | `practice_sessions`, `attempts` | Tidak ada | Ditarik | RA-PRD-501 |
| P5 Pengaturan belajar | `UpdateLearningSettings`, `SetLevel` | `children` | `children`, `level_events` | Ya | RA-PRD-401 |
| P6 Aksesibilitas | `UpdateAccessibility` | `children.settings` | `children.settings` | Ya, terbaru menang | RA-PRD-601 |
| P7 Akun dan sinkron | `SignIn`, `SyncNow`, `JoinClass` | `sync_state`, `guardian_children` | `guardian_children` lewat server | Ya | PRD 2.2, 2.6 |
| P8 Data | `ExportReport`, `DeleteChild` | Semua data anak | `children.deleted_at` | Ya, penghapusan menang | PRD 2.5 |

## Kejadian ke perubahan

| Kejadian | Di database lokal | Outbox | Yang ikut terbarui |
|---|---|---|---|
| Hasil ucapan selesai | Satu baris `attempts` | Ya | Layar umpan balik |
| Kata selesai dan syarat level terpenuhi | Satu baris `level_events` | Ya | Level dan kata berikutnya |
| Sesi selesai | Tutup `practice_sessions`, tambah `reward_events` | Ya | Beranda, Koleksi, Ringkasan pendamping |
| Pendamping mengoreksi "Sudah benar" | Baris percobaan koreksi dengan `guardian_override` | Ya | Statistik dihitung ulang |
| Pendamping mengubah level | Satu baris `level_events` dengan aktor pendamping | Ya | Latihan berikutnya |
| Cerita selesai | `story_progress`, `reward_events` | Ya | Rak Cerita, Koleksi |
| Izin dicabut | `consents.revoked_at`, `guardian_children.revoked_at` | Ya | Akses guru berakhir |
| Sinkron tarik | Terapkan baris dari server | Tidak | Semua layar lewat stream |

## Definisi statistik

Satu definisi berlaku di semua layar dan laporan. Kata hanya dihitung jika sudah selesai, dan `unclear` tidak ikut dihitung.

| Metrik | Rumus | Syarat tampil |
|---|---|---|
| Kata selesai minggu ini | Jumlah kata unik yang selesai sejak Senin 00.00 waktu perangkat | Selalu |
| Ketepatan | Kata benar tanpa bantuan dibagi kata selesai | Minimal 10 kata, hanya untuk pendamping |
| Tren | Ketepatan minggu ini dibanding minggu lalu | Keduanya minimal 10 kata |
| Kemampuan b dan d | Ketepatan kata dan soal bertanda huruf itu | Minimal 10 data |
| Kata sulit | Kata dengan bantuan atau gagal paling sering | Minimal 2 percobaan |
| Waktu latihan | Jumlah durasi sesi yang selesai | Selalu, hanya untuk pendamping |

Metrik yang syaratnya belum terpenuhi menampilkan "Belum cukup data".

## Konten

Kata dan cerita dibundel dalam aplikasi sebagai JSON. Setiap `attempts` menyimpan `word_id` dan `content_version`, sehingga riwayat tetap benar saat konten berubah. Pembaruan konten dari server di luar cakupan versi pertama.

## Cakupan requirement PRD

| Requirement | Ditangani di | Fase |
|---|---|---|
| RA-PRD-101 Profil | A2, onboarding | 4 |
| RA-PRD-201 Tampil dan rekam | A4 | 3 |
| RA-PRD-202 Speech-to-text dan cocokkan | `SpeechMatcher`, port | 1, 2 |
| RA-PRD-301 Umpan balik per suku kata | A5 | 3 |
| RA-PRD-401 Adaptif | `AdaptiveEngine` | 2 |
| RA-PRD-501 Progres | P3, P4 | 5 |
| RA-PRD-601 Aksesibilitas | P6, audio | 3, 5 |
| Performa di bawah 3 detik | Pengukuran | 1, 8 |
| Mode dasar saat luring | Local-first, engine on-device jika terpilih | 1, 2 |
| Akses terbatas untuk pendamping terkait | RLS | 6 |
| Android 8.0 | `minSdk` 26 | 0 |
