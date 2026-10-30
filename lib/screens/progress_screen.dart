import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';

/// RA-PRD-501: Full progress screen with fonologi map, lencana, parent notes.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.pengguna, required this.akses});

  final Pengguna pengguna;
  final Aksesibilitas akses;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<SesiLatihan> _sesi = const [];
  List<Lencana> _lencana = const [];

  @override
  void initState() {
    super.initState();
    _muat();
  }

  void _muat() => setState(() {
        _sesi = Store.instance.bacaSesi(widget.pengguna.id);
        _lencana = Store.instance.bacaLencana();
      });

  @override
  Widget build(BuildContext context) {
    final skala = widget.akses.ukuranHuruf;
    final totalBenar = _sesi.fold<int>(0, (a, s) => a + s.jumlahBenar);
    final totalSalah = _sesi.fold<int>(0, (a, s) => a + s.jumlahSalah);
    final total = totalBenar + totalSalah;
    final akurasi = total == 0 ? 0.0 : totalBenar / total;
    final streak = Store.instance.streakHari();
    final rataRataPerHari = _sesi.isEmpty ? 0 : (totalBenar / 7).round();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // ── Header ──
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book, color: AppColors.tertiary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Lentera',
                              style: AppText.scale(AppText.headlineMd, skala)
                                  .copyWith(color: AppColors.primary)),
                          const SizedBox(width: 6),
                          Pill(
                            label: 'Level ${widget.pengguna.levelSaatIni}',
                            background: AppColors.tertiaryFixed,
                            foreground: AppColors.tertiary,
                            icon: Icons.local_fire_department,
                          ),
                        ],
                      ),
                      const Text('Progres', style: AppText.labelMd),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.text_fields, color: AppColors.onSurface),
                  style: IconButton.styleFrom(backgroundColor: AppColors.surfaceLow),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Profil Card ──
            SoftCard(
              child: Row(
                children: [
                  AvatarBubble(
                    emoji: AvatarData.emoji(widget.pengguna.avatarId),
                    radius: 32,
                    background: AppColors.tertiaryFixed,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.pengguna.nama, style: AppText.scale(AppText.headlineMd, skala)),
                        Row(
                          children: [
                            Text('Pembaca Hebat Kelas ${widget.pengguna.usia - 4}', style: AppText.labelMd),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('Aktif Belajar', style: AppText.labelSm.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune),
                    style: IconButton.styleFrom(backgroundColor: AppColors.surfaceLow),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Pencapaian Minggu Ini ──
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Pill(
                        label: 'PENCAPAIAN MINGGU INI',
                        background: AppColors.primaryTint,
                        foreground: AppColors.primary,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Minggu', style: AppText.labelSm),
                          Text('ke-${DateTime.now().weekday}', style: AppText.labelMd.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AvatarBubble(
                    emoji: AvatarData.emoji(widget.pengguna.avatarId),
                    radius: 28,
                    background: AppColors.tertiaryFixed,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kamu Sudah Membaca $totalBenar Suku Kata Minggu Ini! 🎉',
                    style: AppText.scale(AppText.headlineMd, skala),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill(
                        label: '${(akurasi * 100).round()}% Lancar',
                        background: AppColors.primaryTint,
                        foreground: AppColors.primary,
                        icon: Icons.task_alt,
                      ),
                      Pill(
                        label: 'Level ${widget.pengguna.levelSaatIni} Selesai',
                        background: AppColors.tertiaryFixed,
                        foreground: AppColors.tertiary,
                        icon: Icons.military_tech,
                      ),
                      Pill(
                        label: '$streak Hari Berturut',
                        background: AppColors.primaryFixed,
                        foreground: AppColors.onPrimaryContainer,
                        icon: Icons.local_fire_department,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Activity chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Aktivitas 7 Hari Terakhir', style: AppText.labelMd),
                      Text('Rata-rata $rataRataPerHari kata/hari', style: AppText.labelSm),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _MiniChart(sesi: _sesi),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Peta Kemampuan Fonologis ──
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.map_outlined, size: 22, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Peta Kemampuan Fonologis', style: AppText.scale(AppText.headlineSm, skala)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Analisis adaptif persepsi visual & suara', style: AppText.bodyMd),
                  const SizedBox(height: 16),
                  _SkillBar(
                    judul: 'Pembedaan Huruf Mirip',
                    deskripsi: 'Disambiguasi spasial (b vs d, p vs q)',
                    persen: (akurasi * 100).round().clamp(0, 100),
                    label: akurasi > 0.8 ? 'Sangat Bagus! 🔥' : 'Perlu Latihan',
                    labelColor: akurasi > 0.8 ? AppColors.primary : AppColors.tertiary,
                    catatan: 'Akurasi orientasi huruf konsisten meningkat',
                    skala: skala,
                  ),
                  const SizedBox(height: 14),
                  _SkillBar(
                    judul: 'Penggabungan Suku Kata',
                    deskripsi: 'Kombinasi bunyi pola (CV - CVC)',
                    persen: total == 0 ? 0 : ((totalBenar / total) * 88).round().clamp(0, 100),
                    label: 'Lancar',
                    labelColor: AppColors.primary,
                    catatan: 'Respon cepat saat membaca blok [BA-TU] dan [KU-DA]',
                    skala: skala,
                  ),
                  const SizedBox(height: 14),
                  _SkillBar(
                    judul: 'Kelancaran Membaca Cerita',
                    deskripsi: 'Tempo membaca per kalimat bersuara',
                    persen: total == 0 ? 0 : ((totalBenar / total) * 96).round().clamp(0, 100),
                    label: '${total == 0 ? 0 : ((totalBenar / total) * 96).round()}% Lancar',
                    labelColor: AppColors.primary,
                    catatan: 'Ritme intonasi stabil dengan bantuan mistar baca',
                    skala: skala,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Koleksi Lencana ──
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.military_tech, size: 22, color: AppColors.tertiary),
                          const SizedBox(width: 8),
                          Text('Koleksi Lencana', style: AppText.scale(AppText.headlineSm, skala)),
                        ],
                      ),
                      Text(
                        '${_lencana.length} Terbuka',
                        style: AppText.labelMd.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: JenisLencana.values.length,
                    itemBuilder: (_, i) {
                      final jenis = JenisLencana.values[i];
                      final punya = _lencana.any((l) => l.jenis == jenis);
                      return _LencanaCard(jenis: jenis, terbuka: punya);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Catatan untuk Ayah & Bunda ──
            SoftCard(
              color: AppColors.softPeach,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.family_restroom, size: 22, color: AppColors.tertiary),
                      const SizedBox(width: 8),
                      Text('Catatan untuk Ayah & Bunda 💡',
                          style: AppText.scale(AppText.headlineSm, skala)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('"', style: TextStyle(fontSize: 28, color: AppColors.primary)),
                        RichText(
                          text: TextSpan(
                            style: AppText.bodyLg.copyWith(color: AppColors.onSurface),
                            children: [
                              TextSpan(
                                text: '${widget.pengguna.nama} menunjukkan peningkatan ',
                              ),
                              TextSpan(
                                text: '${(akurasi * 100).round()}%',
                                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              const TextSpan(text: ' dalam kecepatan mengenali bunyi suku kata tanpa membalikkan huruf '),
                              TextSpan(
                                text: "'b'",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.hurufB,
                                  backgroundColor: AppColors.hurufB.withValues(alpha: 0.1),
                                ),
                              ),
                              const TextSpan(text: ' dan '),
                              TextSpan(
                                text: "'d'",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.hurufD,
                                  backgroundColor: AppColors.hurufD.withValues(alpha: 0.1),
                                ),
                              ),
                              const TextSpan(text: '. Pertahankan sesi 15 menit per hari!'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '⏰ Disarankan sesi malam sebelum tidur (pukul 19.00 - 19.15 WIB)',
                          style: AppText.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Unduh Laporan Lengkap (PDF)',
                    icon: Icons.download,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan tombol apa saja untuk mendengar pengucapan audio cerita',
                    style: AppText.bodyMd.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Statistik ──
            SoftCard(
              color: AppColors.surfaceLow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(label: 'Benar', nilai: '$totalBenar', warna: AppColors.primary, skala: skala),
                  _Stat(label: 'Salah', nilai: '$totalSalah', warna: AppColors.error, skala: skala),
                  _Stat(label: 'Akurasi', nilai: '${(akurasi * 100).round()}%', warna: AppColors.tertiary, skala: skala),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Riwayat Sesi ──
            Text('Riwayat Sesi', style: AppText.scale(AppText.headlineSm, skala)),
            const SizedBox(height: 8),
            if (_sesi.isEmpty)
              SoftCard(
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.history, size: 40, color: AppColors.outlineVariant),
                      const SizedBox(height: 8),
                      Text('Belum ada sesi latihan.', style: AppText.bodyMd),
                      const SizedBox(height: 4),
                      Text('Mulai latihan pertamamu!', style: AppText.labelMd.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              )
            else
              for (final s in _sesi.take(20))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SoftCard(
                    color: AppColors.surfaceLowest,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Pill(label: 'Lv ${s.level}', background: AppColors.primaryFixed, foreground: AppColors.onPrimaryContainer),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.tanggal.day}/${s.tanggal.month} · ${s.jenisLatihan == 'discriminasi' ? 'Beda Huruf' : 'Suku Kata'}',
                                style: AppText.labelMd,
                              ),
                              Text(
                                'benar ${s.jumlahBenar} · salah ${s.jumlahSalah} · ${(s.durasiDetik / 60).ceil()} mnt',
                                style: AppText.bodyMd,
                              ),
                            ],
                          ),
                        ),
                        Text('${(s.akurasi * 100).round()}%', style: AppText.labelLg.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({required this.sesi});

  final List<SesiLatihan> sesi;

  @override
  Widget build(BuildContext context) {
    final hari = List<double>.filled(7, 0);
    final now = DateTime.now();
    for (final s in sesi) {
      final d = now.difference(s.tanggal).inDays;
      if (d >= 0 && d < 7) hari[6 - d] += s.jumlahBenar.toDouble();
    }
    final maxV = hari.reduce((a, b) => a > b ? a : b);
    const label = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: maxV == 0 ? 4 : (hari[i] / maxV * 56).clamp(4.0, 56.0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.4 + 0.6 * (maxV == 0 ? 0 : hari[i] / maxV)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(label[i], style: AppText.labelMd.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({
    required this.judul,
    required this.deskripsi,
    required this.persen,
    required this.label,
    required this.labelColor,
    required this.catatan,
    required this.skala,
  });

  final String judul;
  final String deskripsi;
  final int persen;
  final String label;
  final Color labelColor;
  final String catatan;
  final double skala;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(judul, style: AppText.scale(AppText.labelLg, skala)),
                      Text(deskripsi, style: AppText.labelSm),
                    ],
                  ),
                ),
                Pill(
                  label: label,
                  background: labelColor.withValues(alpha: 0.15),
                  foreground: labelColor,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SteppedProgress(value: persen / 100, height: 10, color: AppColors.primaryContainer),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(catatan, style: AppText.labelSm),
                Text('$persen%', style: AppText.labelLg.copyWith(color: AppColors.primary)),
              ],
            ),
          ],
        ),
      );
}

class _LencanaCard extends StatelessWidget {
  const _LencanaCard({required this.jenis, required this.terbuka});

  final JenisLencana jenis;
  final bool terbuka;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: terbuka ? AppColors.surfaceLowest : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: terbuka
              ? Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.5))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              terbuka ? jenis.emoji : '🔒',
              style: TextStyle(fontSize: terbuka ? 28 : 22),
            ),
            const SizedBox(height: 6),
            Text(
              jenis.label,
              style: AppText.labelLg.copyWith(
                color: terbuka ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              terbuka ? jenis.sublabel : '',
              style: AppText.labelSm.copyWith(
                color: terbuka ? AppColors.primary : AppColors.outlineVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              jenis.deskripsi,
              style: AppText.labelSm,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.nilai, required this.warna, required this.skala});

  final String label;
  final String nilai;
  final Color warna;
  final double skala;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(nilai, style: AppText.scale(AppText.headlineMd, skala).copyWith(color: warna)),
          Text(label, style: AppText.labelMd),
        ],
      );
}