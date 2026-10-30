# 04. Arsitektur dan backend

## Keputusan utama

**Monolit modular local-first di Flutter, dengan Supabase sebagai backend sinkron.**

| Pilihan | Dipilih | Alasan |
|---|---|---|
| Gaya arsitektur | Monolit modular dengan ports and adapters di tepi sistem | Satu aplikasi dan satu pengembang. Microservices dan event sourcing penuh terlalu berat |
| Database lokal | Drift (SQLite) | Relasional, bertipe, punya migrasi, dan sesuai PRD 2.6 |
| Backend | Supabase (Postgres, Auth, Row Level Security) | Relasi anak, pendamping, dan kelas cocok dengan SQL, serta aturan aksesnya bisa dipaksa di database |
| State | Riverpod | Dependensi mudah diganti saat tes |
| Navigasi | `go_router` | Mendukung pemisahan Mode Anak dan Area Pendamping |
| Speech | Port `SpeechRecognizer` | Engine ditentukan hasil uji Fase 1 |
| Suara | Audio contoh, cadangan `flutter_tts` | Audio rekaman lebih konsisten untuk suku kata |

PRD 2.6 menyebut Firebase/SQLite. Supabase dipilih karena model izinnya relasional. Jika dosen mewajibkan Firebase, hanya adapter sinkron yang berganti, karena domain dan UI tidak bergantung padanya.

## Aturan utama alur data

```text
UI -> Controller -> Use case -> Repository -> Drift
                                    |
                                  Outbox -> SyncEngine -> Supabase
```

1. **UI hanya membaca dari database lokal.** Layar tidak pernah menunggu jaringan.
2. **Setiap perubahan ditulis ke tabel dan outbox dalam satu transaksi.** Tidak ada perubahan yang hilang.
3. **Sinkron berjalan di belakang layar** dan hasil tarikannya masuk ke Drift, lalu UI terbarui lewat stream.
4. **Statistik dihitung dari log percobaan**, sehingga layar anak, pendamping, dan laporan selalu sama.

## Struktur folder

```text
lib/
  main.dart
  app/            router, tema, bootstrap, dependency
  core/           design system, database, sync, util
  domain/         model dan aturan murni, tanpa Flutter
    practice/     PracticeSession, AdaptiveEngine, SpeechMatcher
    progress/     perhitungan statistik
  features/
    onboarding/
    practice/
    letters/
    stories/
    rewards/
    guardian/
    account/
  content/        akses kata dan cerita
assets/
  content/        JSON berversi
  audio/          audio contoh
```

Aturan ketergantungan: `features` boleh memakai `domain` dan `core`. `domain` tidak boleh mengimpor Flutter, Drift, atau Supabase. Antar fitur berkomunikasi lewat domain atau router.

## Modul inti

### PracticeSession

State machine murni yang menggantikan logika di `practice_screen.dart`.

```text
wordReady -> listening -> processing -> resultCorrect -> wordReady | finished
                              |-> resultPartial -> listening | assisted
                              |-> resultWrong   -> listening | assisted
                              |-> unclear       -> listening
assisted -> wordReady | finished
```

Masukannya kejadian seperti `micPressed` atau `speechResult`. Keluarannya state baru dan daftar efek, seperti `playAudio` atau `saveAttempt`. Semua alur bisa diuji tanpa perangkat.

### SpeechMatcher

Fungsi murni. Masukan: kata target dan hasil pengenalan beserta keyakinan. Keluaran: status dan indeks suku kata cocok. Aturan toleransi fonetik ditentukan dari data uji Fase 1.

### AdaptiveEngine

Masukan: level dan hasil akhir kata. Status `unclear` dan kata berbantuan tidak menaikkan level. Nilai N dan M diatur per anak.

### Port eksternal

```dart
abstract interface class SpeechRecognizer {
  Stream<SpeechEvent> listen({required String localeId});
  Future<void> stop();
  Future<SpeechAvailability> availability();
}

abstract interface class Speaker {
  Future<void> play(SpeechClip clip);
  Future<void> stop();
}

abstract interface class SyncGateway {
  Future<PushResult> push(List<OutboxEntry> entries);
  Future<PullResult> pull(SyncCursor cursor);
}
```

## Skema data

Skema lokal dan server sengaja sama. Semua ID memakai UUID yang dibuat di perangkat.

| Tabel | Kolom penting | Cara sinkron |
|---|---|---|
| `guardians` | `id`, `display_name`, `role` | Dimiliki server |
| `children` | `id`, `owner_guardian_id`, `nickname`, `avatar_id`, `settings`, `updated_at`, `deleted_at` | Dua arah, yang terbaru menang |
| `consents` | `id`, `child_id`, `guardian_id`, `version`, `granted_at`, `revoked_at` | Hanya ditambah |
| `guardian_children` | `guardian_id`, `child_id`, `role`, `granted_by`, `revoked_at` | Dimiliki server |
| `classes` | `id`, `teacher_id`, `name`, `join_code` | Dimiliki server |
| `practice_sessions` | `id`, `child_id`, `started_at`, `ended_at`, `start_level`, `end_level`, `kind`, `device_id` | Hanya ditambah, lalu ditutup sekali |
| `attempts` | `id`, `session_id`, `child_id`, `word_id`, `content_version`, `try_number`, `status`, `matched_syllables`, `confidence`, `engine`, `assisted`, `guardian_override`, `occurred_at` | Hanya ditambah |
| `level_events` | `id`, `child_id`, `from_level`, `to_level`, `reason`, `actor`, `occurred_at` | Hanya ditambah |
| `story_progress` | `child_id`, `story_id`, `page`, `completed_at`, `updated_at` | Dua arah, nilai terjauh menang |
| `reward_events` | `id`, `child_id`, `kind`, `source_id`, `occurred_at` | Hanya ditambah, unik per sumber |
| `outbox` | `id`, `table`, `row_id`, `op`, `payload`, `attempts`, `next_retry_at` | Hanya lokal |
| `sync_state` | `cursor`, `last_success_at`, `last_error` | Hanya lokal |

Teks hasil pengenalan **tidak dikirim ke server secara default**. Di perangkat, teks ini hanya disimpan jika diperlukan untuk uji akurasi.

Statistik seperti tren mingguan dihitung dari `attempts`, jadi tabel `ProgresMingguan` dari PRD menjadi hasil perhitungan, bukan tabel yang diisi terpisah.

## Protokol sinkron

**Push**

1. Ambil outbox yang sudah waktunya, urut berdasarkan waktu.
2. Kirim per batch ke Supabase dengan upsert berdasarkan `id`, sehingga pengiriman ulang aman.
3. Berhasil: hapus entri. Gagal jaringan: tunda dengan jeda yang makin panjang. Ditolak aturan: tandai dan tampilkan di P7.

**Pull**

1. Ambil baris dengan kolom sinkron server yang lebih baru dari cursor, untuk anak yang boleh diakses.
2. Terapkan ke Drift dalam satu transaksi, lalu perbarui cursor.

**Konflik**

| Jenis data | Aturan |
|---|---|
| `attempts`, `level_events`, `reward_events`, `consents` | Tidak ada konflik, hanya digabung |
| `children.settings` | `updated_at` terbaru menang |
| `story_progress` | Halaman terjauh menang |
| Level anak | Dihitung dari `level_events` terbaru |
| Penghapusan | `deleted_at` selalu menang, lalu dibersihkan permanen |

Pemicu sinkron: aplikasi dibuka, sesi selesai, jaringan kembali, dan tombol manual di P7. Waktu server dipakai untuk cursor agar tidak bergantung pada jam perangkat.

## Keamanan dan privasi

- **Anak tanpa akun.** Hanya pendamping yang login. Perangkat anak yang belum login tetap berfungsi penuh secara lokal.
- **Row Level Security di semua tabel.** Pendamping hanya bisa membaca anak yang terhubung lewat `guardian_children` dan izinnya belum dicabut. Tes RLS wajib ada.
- **Guru hanya bisa masuk dengan izin orang tua.** Orang tua memasukkan kode kelas, dan bisa mencabutnya.
- **Tidak ada audio yang disimpan atau diunggah oleh aplikasi.** Rekaman Lentera ditiadakan.
- **Perlu diverifikasi:** engine speech tertentu dapat mengirim suara ke layanan pihak ketiga. Hal ini menjadi kriteria seleksi di Fase 1, dan harus dinyatakan apa adanya di layar persetujuan.
- **Kunci:** hanya `anon key` di aplikasi. `service_role` tidak pernah masuk ke aplikasi.
- **PIN** untuk memisahkan area anak dan pendamping, bukan keamanan tingkat tinggi. Disimpan sebagai hash.
- **Kepatuhan:** data anak di Indonesia tunduk pada UU PDP (UU 27/2022), termasuk persetujuan orang tua atau wali. Teks persetujuan dan kebijakan privasi perlu ditinjau oleh dosen atau pihak yang berkompeten sebelum uji dengan anak sungguhan.

## Strategi tes

| Lapisan | Yang diuji |
|---|---|
| Unit | `PracticeSession`, `SpeechMatcher`, `AdaptiveEngine`, statistik |
| Database | Migrasi Drift, transaksi tabel dan outbox |
| Sinkron | Pengiriman ulang aman, konflik, perangkat luring lalu daring dengan `FakeSyncGateway` |
| RLS | Pendamping lain dan guru tanpa izin tidak bisa membaca |
| Widget | Setiap layar pada keadaan kosong, memuat, dan gagal, serta ukuran teks besar |
| Integrasi | Satu sesi penuh di emulator dan HP Android |
| Perangkat nyata | Minimal 2 HP Android (PRD 4.2) |

Target ukur dari PRD: evaluasi ucapan rata-rata di bawah 3 detik setelah selesai bicara. Angka ini dilaporkan hanya setelah diukur.

## Dokumentasi keputusan

Keputusan besar dicatat sebagai ADR di `DOCSS/adr/` saat implementasi dimulai: Drift, Supabase, engine speech, dan penyimpangan dari PRD.
