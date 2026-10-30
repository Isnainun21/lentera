# DESIGN.md: Lentera

Status: **draf arah, menunggu persetujuan pemilik.** Disusun dari dua referensi yang diberikan pemilik. Karena sebagian penerjemahannya dibuat oleh agent, hasil tetap harus dinilai pada layar sungguhan di Fase 3.

Dial: ENERGY 2 / RHYTHM 2 / MOTION 2

Design Read: aplikasi belajar membaca untuk anak disleksia dan pendampingnya, dengan bahasa kartu menumpuk dari referensi, dibedakan oleh motif lengkung lentera.

## Ide

**Membaca menerangi.** Bentuk lengkung lentera dari kolom referensi menjadi bingkai kata yang sedang dibaca. Saat anak berhasil atau berusaha, cahaya kuning mengisi lentera. Warna kuning hampir hanya berarti satu hal: cahaya dari usaha membaca.

Uji tukar logo: kolom lengkung, cahaya yang mengisi, dan rak lentera mingguan berasal dari nama produk, sehingga tidak bisa dipindahkan begitu saja ke aplikasi lain.

## Warna

Semua pasangan di tabel sudah dihitung dengan rumus WCAG.

| Token | Hex | Peran | Alasan |
|---|---|---|---|
| `ground` | `#DDE6E3` | Dasar layar | Sage tenang dari referensi 1, tidak silau seperti putih penuh |
| `surface` | `#FFFFFF` | Kartu | Permukaan baca yang jelas |
| `ink` | `#1B2422` | Teks dan tombol utama | Hitam kehijauan yang menyatu dengan dasar |
| `subInk` | `#46524F` | Teks kedua | Tetap kuat, bukan abu-abu pudar |
| `lantern` | `#EFC75E` | Aksen: cahaya dan pencapaian | Satu warna untuk momen penting |
| `sky` | `#8FB6C9` | Kolom kategori Latihan | Warna kategori dari referensi |
| `leaf` | `#7DB58F` | Kolom kategori Cerita | Warna kategori dari referensi |
| `ok` | `#1E6B46` | Status benar, selalu dengan ikon centang | Lolos untuk teks di atas putih |
| `retry` | `#7A5600` | Status coba lagi, selalu dengan ikon telinga | Bukan merah, supaya tidak terasa menghukum |
| `letterB` | `#1D5C8C` | Penanda huruf b | Tidak bentrok dengan status |
| `letterD` | `#9A4A00` | Penanda huruf d | Tidak memakai merah |

| Pasangan | Rasio | Hasil |
|---|---|---|
| `ink` di `ground` | 12,48 | Lolos |
| `ink` di `surface` | 15,88 | Lolos |
| `ink` di `lantern` | 9,83 | Lolos |
| `ink` di `sky` | 7,34 | Lolos |
| `ink` di `leaf` | 6,72 | Lolos |
| `subInk` di `surface` | 8,14 | Lolos |
| `subInk` di `ground` | 6,40 | Lolos |
| `ok` di `surface` | 6,47 | Lolos |
| `retry` di `surface` | 6,65 | Lolos |
| `letterB` di `surface` | 7,09 | Lolos |
| `letterD` di `surface` | 6,26 | Lolos |
| `letterB` di `lantern` | 4,39 | Hanya untuk teks besar |
| `letterD` di `lantern` | 3,88 | Hanya untuk teks besar |

Catatan: `leaf` di atas putih hanya 2,37, jadi cincin dan garis pada putih memakai `ok`. Warna lama `hurufD` (2,78) dan `hurufB` (3,12) gagal AA di atas putih, sehingga diganti.

Warna per huruf hanya tambahan. Bentuk huruf dan ikon tetap menjadi penanda utama, dan pendamping bisa mematikannya.

## Tipografi

**Lexend** untuk semua teks. Alasan: dirancang untuk kemudahan membaca dan sudah ada di project. Satu keluarga cukup, karena hierarki dibangun dari ukuran dan bobot.

Berat font perlu diverifikasi di Fase 3, karena belum dipastikan apakah `Lexend.ttf` adalah font variabel yang merespons `FontWeight`.

| Token | Ukuran | Dipakai untuk |
|---|---|---|
| `wordHero` | 56 sampai 72, menyesuaikan lebar | Kata target |
| `syllable` | 34 | Suku kata |
| `title` | 28 | Judul layar |
| `reading` | 22, tinggi baris 1,7, jarak huruf 0,04em | Teks cerita |
| `body` | 18 | Teks biasa di Mode Anak |
| `bodyGuardian` | 16 | Teks di Area Pendamping |
| `caption` | 14 | Hanya di Area Pendamping |

Aturan: tidak ada huruf kapital semua sebagai label dan tidak ada teks di bawah 14. Ukuran mengikuti pengaturan pendamping dan pengaturan teks sistem. Teks rata kiri.

## Bentuk dan permukaan

| Elemen | Radius | Alasan |
|---|---|---|
| Lengkung lentera | Puncak setengah lingkaran, bawah 24 | Motif identitas |
| Kartu | 28 | Bahasa kartu dari referensi |
| Tombol utama | Tinggi 64, pil, warna `ink` | Satu aksi paling jelas per layar |
| Tombol kedua | Tinggi 56, radius 20, warna `surface` | Jelas lebih rendah dari aksi utama |
| Kotak suku kata | 20 | Terasa seperti ubin yang bisa disentuh |

Bayangan hanya untuk lembar yang mengambang, misalnya dialog. Kartu dipisahkan oleh perbedaan warna dengan `ground`. Tidak ada glass, glow, gradien, grid latar, atau blob.

Sentuhan minimum 56 di Mode Anak dan 48 di Area Pendamping.

## Komponen inti

| Komponen | Bentuk | Dipakai di |
|---|---|---|
| `LanternFrame` | Bingkai lengkung yang menampung kata dan bisa terisi cahaya | A4, A5, A6 |
| `SyllableTile` | Ubin suku kata dengan status warna dan ikon | A4, A5, A9 |
| `MicButton` | Tombol bulat 96 dengan keadaan siap, mendengar, memproses | A4 |
| `PrimaryAction` | Tombol hitam lebar di bawah layar | Semua layar |
| `WeekLanterns` | Tujuh lentera kecil berlabel hari | A3, A10, P3 |
| `ActivityPillar` | Kolom lengkung kategori | A3 |
| `StoryCover` | Kartu gambar besar dengan panel judul solid | A8 |
| `ReadingRuler` | Fokus satu baris saat membaca | A9 |
| `MetricGrid` | Kisi metrik terukur | P3 |
| `TrendBars` | Batang berlapis dua warna | P3 |

Setiap komponen data punya keadaan kosong, memuat, dan gagal.

## Komposisi layar utama

### A3 Beranda

```text
Halo, Bima                     [avatar]
----------------------------------
 ______
/      \    Kolom lentera besar
| Lanjut|   berisi kata terakhir atau tema hari ini
| baca  |
|______|
[        Mulai Baca        ]   <- satu focal point

Minggu ini  o o o o o o o
Latihan  |  Cerita  |  Koleksi
```

### A4 Latihan

```text
<  Kembali                  3 dari 6
   ____________
  /            \
 |     BU KU    |     <- bingkai lentera, kata paling besar
 |______________|
   [BU]  [KU]         sentuh untuk mendengar
      [ Mikrofon ]
Tekan lalu ucapkan
```

Tidak ada pill status, kamus, atau tugas lain di layar ini.

### A8 Rak Cerita

Mengikuti struktur referensi 2: sapaan singkat, lalu kartu sampul besar yang bisa digeser. Teks judul berada di panel solid agar kontras terjamin.

### P3 Ringkasan

Mengikuti struktur referensi 1: kartu tren, kisi metrik, dan daftar kata sulit. Inilah tempat kepadatan informasi boleh naik.

## Gerak

| Gerakan | Tujuan |
|---|---|
| Cahaya mengisi lentera saat kata selesai | Memberi tanda usaha diterima |
| Lingkaran berdenyut pelan saat mendengarkan | Menunjukkan mikrofon aktif |
| Suku kata menyala saat audio berjalan | Menghubungkan bunyi dan tulisan |
| Tombol turun sedikit saat ditekan | Respons sentuhan |

Durasi 150 sampai 400 ms. Gerakan berhenti saat pengaturan kurangi gerak aktif. Tidak ada animasi yang berulang tanpa henti selain status mendengarkan.

## Aset

Logo, ilustrasi cerita, dan avatar **belum ditentukan** (R-23). Sampai dikonfirmasi:

- Logo: tulisan "Lentera".
- Avatar: lingkaran warna dengan inisial atau hewan dari set yang dipilih pemilik.
- Sampul cerita: bidang warna dengan judul, ditandai sebagai placeholder.

Emoji tidak dipakai sebagai ikon atau ilustrasi.

## Bahasa

Kalimat pendek, kata sehari-hari, dan langsung pada tindakan. Tanpa em dash dan kata seperti "AI". Contoh: "Mulai Baca", "Kata berikutnya", "Coba ucapkan sekali lagi", "Kita baca bersama".

## Benturan yang perlu dicatat

| Elemen | Aturan | Keputusan sementara |
|---|---|---|
| Kolom warna dan kartu berulang dari referensi | R-14, R-30 | Dipakai dengan hierarki berbeda dan motif sendiri, bukan salinan |
| Tombol pil | R-11 | Hanya tombol utama. Elemen lain memakai radius lain |
| Tiga warna inti ditambah aksen dan warna status | R-29 | `sky`, `leaf`, dan `ink` adalah inti, `lantern` adalah aksen. Warna status dan huruf hanya fungsional |
