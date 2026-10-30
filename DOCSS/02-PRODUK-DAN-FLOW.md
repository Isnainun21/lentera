# 02. Produk dan flow

## Prinsip

1. **Satu layar, satu tugas** untuk anak.
2. **Kegagalan teknis bukan kesalahan anak.** Ucapan yang tidak terdengar jelas tidak memengaruhi level.
3. **Anak tidak pernah buntu.** Setelah dua percobaan, aplikasi membantu lalu lanjut.
4. **Anak melihat usaha, pendamping melihat data.**
5. **Semua angka berasal dari log percobaan.** Jika data belum cukup, angka tidak ditampilkan.

## Peran

| Peran | Akses | Login |
|---|---|---|
| Anak | Mode Anak | Tidak, cukup memilih avatar |
| Orang tua | Area Pendamping: anaknya sendiri | Opsional di perangkat sendiri, wajib untuk sinkron |
| Guru | Area Pendamping: siswa yang orang tuanya memberi izin | Wajib |

## Peta layar

### Mode Anak

| Kode | Layar | Tugas tunggal |
|---|---|---|
| A1 | Splash | Membuka aplikasi |
| A2 | Pilih profil | Memilih avatar |
| A3 | Beranda | Menekan "Mulai Baca" |
| A4 | Latihan: dengar dan ucapkan | Mengucapkan kata |
| A5 | Latihan: umpan balik | Lanjut ke kata berikutnya |
| A6 | Ringkasan sesi | Melihat lentera menyala |
| A7 | Beda Huruf | Memilih huruf target |
| A8 | Rak Cerita | Memilih cerita |
| A9 | Baca Cerita | Membaca satu halaman |
| A10 | Koleksi lentera | Melihat hasil usaha |

Bottom navigation Mode Anak: **Beranda, Latihan, Cerita, Koleksi**. Area Pendamping tidak berada di navigasi ini, melainkan lewat ikon kecil di Beranda dengan tahan 3 detik dan kunci PIN.

### Area Pendamping

| Kode | Layar | Isi |
|---|---|---|
| P1 | Kunci PIN | Membuka area |
| P2 | Persetujuan | Izin penggunaan data anak, wajib sebelum profil dibuat |
| P3 | Ringkasan anak | Tren mingguan, kemampuan, kata yang sulit |
| P4 | Riwayat sesi | Daftar dan detail per kata |
| P5 | Pengaturan belajar | Level, jumlah kata per sesi, nilai N dan M |
| P6 | Aksesibilitas | Ukuran huruf, kecepatan suara, penggaris, warna huruf |
| P7 | Akun dan sinkron | Login, status sinkron, kode kelas |
| P8 | Data | Ekspor laporan, hapus data |

## Flow pertama kali

```text
A1 Splash
 -> P2 Persetujuan pendamping
 -> Buat PIN
 -> Buat profil: nama panggilan, avatar, level awal
 -> Izin mikrofon, dengan penjelasan sebelum dialog sistem
      diizinkan: A3 Beranda
      ditolak: A3 Beranda, latihan memakai mode dengar dan pilih
```

Usia tidak diminta sampai ada fitur yang memakainya (minimalisasi data, PRD 2.5).

## Flow latihan

```text
A3 "Mulai Baca"
 -> Buat sesi dari level sekarang (default 6 kata, bisa diatur)
 -> A4 kata tampil besar, audio contoh diputar
 -> Anak menekan mikrofon sekali, berhenti otomatis saat diam
 -> Status: mendengarkan, lalu memproses
 -> Hasil:

    BENAR       semua suku kata cocok, level dihitung, tombol "Kata berikutnya"
    SEBAGIAN    suku kata cocok ditandai, sisanya ditandai "coba lagi"
    BELUM TEPAT tidak ada yang cocok, contoh diputar lagi
    TIDAK JELAS teks kosong, keyakinan rendah, atau gangguan layanan
                tidak dihitung, "Coba ucapkan sekali lagi"

 -> Setelah 2 percobaan tanpa BENAR:
    "Kita baca bersama", contoh diputar, tombol "Kata berikutnya"
 -> Kata terakhir: simpan sesi, A6 Ringkasan
```

Keputusan yang mengubah perilaku sekarang:

- **Tekan sekali**, bukan tekan tahan. PRD 2.3 menyebut tahan, sedangkan RA-PRD-201 menyebut tap. Tap lebih mudah bagi anak dengan kendali motorik yang masih berkembang.
- **Level berubah di antara sesi atau setelah kata selesai.** Kata berikutnya selalu diambil dari level terbaru, supaya mesin adaptif benar-benar terasa dalam sesi.
- **Yang dihitung adalah hasil akhir per kata**, bukan setiap percobaan, supaya mengulang tidak langsung menurunkan level.
- **Pendamping bisa menekan "Sudah benar"** dalam mode pendampingan. Koreksi ini tersimpan sebagai data terpisah.

## Flow gagal

| Kondisi | Yang dilihat anak | Yang dilakukan sistem |
|---|---|---|
| Izin mikrofon ditolak | Latihan dengar dan pilih | Pendamping diberi tahu cara mengaktifkan |
| Bahasa Indonesia tidak tersedia | Latihan dengar dan pilih | Ditandai di P7 |
| Tidak ada internet | Tidak ada perubahan bila engine on-device | Data masuk antrean sinkron |
| Ucapan kosong | "Coba ucapkan sekali lagi" | Tidak dihitung |
| Sesi terputus | "Lanjutkan baca?" | Sesi dipulihkan dari database |
| Sinkron gagal | Tidak terlihat oleh anak | Dicoba lagi, statusnya ada di P7 |

## Hadiah

- Setiap sesi yang selesai menyalakan lentera hari itu, berapa pun hasilnya.
- Koleksi bertambah dari hal yang benar-benar terjadi: kata dipelajari, cerita selesai, hari berlatih.
- Tidak ada skor persen, peringkat, atau pesan streak putus untuk anak.
- Tidak ada target menit di Beranda. Durasi tetap dicatat untuk pendamping.

## Flow pendamping

```text
Beranda -> tahan ikon pendamping 3 detik -> PIN -> P3 Ringkasan
P3 -> kata yang sulit -> "Latih kata ini di sesi berikutnya"
P5 -> ubah level -> tercatat sebagai perubahan level oleh pendamping
P7 -> login -> sinkron pertama -> guru bergabung lewat kode kelas yang dibuat orang tua
P8 -> hapus data -> konfirmasi -> hapus di perangkat dan server
```

## Di luar cakupan versi pertama

- Rekaman suara untuk ditinjau guru.
- Penilaian pelafalan berbasis machine learning buatan sendiri.
- Kalender rekomendasi waktu belajar dan konten dari guru.
- Dark mode. Alasan: satu tema dengan kontras terukur lebih aman untuk versi pertama, dan pengaturan warna huruf sudah menjadi prioritas aksesibilitas.
