import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../screens/practice_screen.dart';
import '../screens/story_screen.dart';
import '../theme.dart';
import '../widgets.dart';

/// Layar Beranda — sesuai referensi Stitch "beranda_lentera_membaca".
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.pengguna, required this.akses, required this.onRefresh});

  final Pengguna pengguna;
  final Aksesibilitas akses;
  final VoidCallback onRefresh;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Aksesibilitas _akses;

  @override
  void initState() {
    super.initState();
    _akses = widget.akses;
  }

  void _toggleAudio() {
    setState(() {
      _akses = _akses.copyWith(textToSpeech: !_akses.textToSpeech);
    });
    Store.instance.simpanAksesibilitas(_akses);
  }

  void _toggleHurufRamah() {
    setState(() {
      _akses = _akses.copyWith(hurufRamahDisleksia: !_akses.hurufRamahDisleksia);
    });
    Store.instance.simpanAksesibilitas(_akses);
  }

  @override
  Widget build(BuildContext context) {
    final skala = _akses.ukuranHuruf;
    final menitHariIni = Store.instance.menitLatihanHariIni();
    final bintang = Store.instance.bintangHariIni();
    const targetMenit = 15;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // ── Header ──
            _Header(pengguna: widget.pengguna, akses: _akses),
            const SizedBox(height: 20),

            // ── Kartu Sapaan + Progress Harian ──
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${widget.pengguna.nama}! ⭐',
                              style: AppText.scale(AppText.headlineLgMobile, skala),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Yuk lanjutkan petualangan membaca hari ini tanpa terburu-buru!',
                              style: AppText.scale(AppText.bodyLg, skala),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            AvatarData.emoji(widget.pengguna.avatarId),
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Daily progress - real data
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.timer, color: AppColors.primary, size: 20),
                                const SizedBox(width: 6),
                                Text('$menitHariIni / $targetMenit Menit Hari Ini', style: AppText.labelLg),
                              ],
                            ),
                            Pill(
                              label: 'Bintang: $bintang',
                              background: AppColors.tertiaryFixed,
                              foreground: AppColors.tertiary,
                              icon: Icons.star,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SteppedProgress(value: menitHariIni / targetMenit),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Toggle aksesibilitas - functioning
                  Row(
                    children: [
                      Expanded(
                        child: _QuickToggle(
                          icon: Icons.volume_up,
                          label: 'Audio Fonik',
                          active: _akses.textToSpeech,
                          onTap: _toggleAudio,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickToggle(
                          icon: Icons.spellcheck,
                          label: 'Huruf Ramah',
                          active: _akses.hurufRamahDisleksia,
                          onTap: _toggleHurufRamah,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Misi Hari Ini ──
            _MisiCard(
              skala: skala,
              level: widget.pengguna.levelSaatIni,
              pengguna: widget.pengguna,
              akses: _akses,
              onRefresh: widget.onRefresh,
            ),
            const SizedBox(height: 24),

            // ── Pilihan Modul Seru ──
            SectionHeader(
              title: 'Pilihan Modul Seru',
              subtitle: 'Langkah kecil membaca percaya diri',
              trailing: GestureDetector(
                onTap: () {},
                child: Text(
                  'Lihat Semua',
                  style: AppText.labelMd.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ModulCard(
              judul: 'Tebak Suku Kata',
              deskripsi: 'Rangkai bunyi suku kata ...',
              icon: Icons.record_voice_over,
              label: '96% Lancar',
              labelColor: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PracticeScreen(
                    pengguna: widget.pengguna,
                    akses: _akses,
                    onRefresh: widget.onRefresh,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ModulCard(
              judul: 'Cerita Si Kancil Ce...',
              deskripsi: 'Teks terbimbing dengan p...',
              icon: Icons.auto_stories,
              label: 'Baca Mandiri',
              labelColor: AppColors.tertiary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryScreen(
                    pengguna: widget.pengguna,
                    akses: _akses,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ModulCard(
              judul: 'Labirin Huruf Mirip',
              deskripsi: 'Bedakan b, d, p, dan q se...',
              icon: Icons.grid_view_rounded,
              label: 'Fokus Visual',
              labelColor: AppColors.secondary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PracticeScreen(
                    pengguna: widget.pengguna,
                    akses: _akses,
                    mulaiDariDiscriminasi: true,
                    onRefresh: widget.onRefresh,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Penggaris Baca Ajaib ──
            SoftCard(
              color: AppColors.surfaceLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.straighten, size: 22, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Penggaris Baca Ajaib', style: AppText.scale(AppText.headlineSm, skala)),
                      ),
                      Icon(
                        _akses.penggarisAktif ? Icons.bookmark : Icons.bookmark_border,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Membantu mata fokus pada 1 baris kalimat agar teks tidak bergoyang atau melompat.',
                    style: AppText.scale(AppText.bodyMd, skala),
                  ),
                  const SizedBox(height: 12),
                  SoftCard(
                    color: AppColors.surfaceLowest,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Di suatu pagi yang cerah,',
                          style: AppText.bodyReadingMd.copyWith(color: AppColors.onSurface.withValues(alpha: 0.35)),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryFixed.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Ia menyapa burung hantu yang sedang mengantuk.',
                            style: AppText.bodyReadingMd,
                          ),
                        ),
                        Text(
                          'Lalu kancil menemukan jembatan bambu kecil.',
                          style: AppText.bodyReadingMd.copyWith(color: AppColors.onSurface.withValues(alpha: 0.35)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.visibility, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Mengurangi kelelahan mata 78%',
                          style: AppText.labelMd.copyWith(color: AppColors.primary),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _akses = _akses.copyWith(penggarisAktif: !_akses.penggarisAktif);
                          });
                          Store.instance.simpanAksesibilitas(_akses);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _akses.penggarisAktif ? AppColors.primaryContainer : AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            _akses.penggarisAktif ? 'Aktif ✓' : 'Coba Sekarang',
                            style: AppText.labelLg.copyWith(
                              color: _akses.penggarisAktif ? AppColors.onPrimaryContainer : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Setiap anak memiliki kecepatan membacanya sendiri ✨',
                style: AppText.bodyMd.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.pengguna, required this.akses});

  final Pengguna pengguna;
  final Aksesibilitas akses;

  @override
  Widget build(BuildContext context) => Row(
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
                        style: AppText.scale(AppText.headlineMd, akses.ukuranHuruf)
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(width: 6),
                    Pill(
                      label: 'Level ${pengguna.levelSaatIni}',
                      background: AppColors.tertiaryFixed,
                      foreground: AppColors.tertiary,
                      icon: Icons.local_fire_department,
                    ),
                  ],
                ),
                const Text('Beranda', style: AppText.labelMd),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Mode Aksesibilitas Font Disleksia',
            onPressed: () {},
            icon: const Icon(Icons.text_fields, color: AppColors.onSurface),
            style: IconButton.styleFrom(backgroundColor: AppColors.surfaceLow),
          ),
          const SizedBox(width: 4),
          AvatarBubble(
            emoji: AvatarData.emoji(pengguna.avatarId),
            radius: 18,
            background: AppColors.primaryFixed,
          ),
        ],
      );
}

class _QuickToggle extends StatelessWidget {
  const _QuickToggle({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryTint : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: active ? Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.5)) : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: active ? AppColors.primary : AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: AppText.labelMd, overflow: TextOverflow.ellipsis)),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.outlineVariant,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      );
}

class _MisiCard extends StatelessWidget {
  const _MisiCard({
    required this.skala,
    required this.level,
    required this.pengguna,
    required this.akses,
    required this.onRefresh,
  });

  final double skala;
  final int level;
  final Pengguna pengguna;
  final Aksesibilitas akses;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Pill(label: 'Level $level'),
                Pill(
                  label: 'Suku Kata: ba - bi - bu',
                  background: const Color(0x1A006A61),
                  foreground: AppColors.primary,
                  icon: Icons.auto_stories,
                ),
                const Pill(
                  label: 'Adaptif AI',
                  background: AppColors.softPeach,
                  foreground: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.surfaceLow, AppColors.surfaceContainer, AppColors.surfaceHigh],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarBubble(
                      emoji: AvatarData.emoji(pengguna.avatarId),
                      radius: 36,
                      background: AppColors.surfaceLowest,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LetterColorDot(huruf: 'b'),
                        const SizedBox(width: 4),
                        Text('b ke kanan', style: AppText.labelSm),
                        const SizedBox(width: 16),
                        const LetterColorDot(huruf: 'd'),
                        const SizedBox(width: 4),
                        Text('d ke kiri', style: AppText.labelSm),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('MISI HARI INI', style: AppText.scale(AppText.labelMd, skala).copyWith(color: AppColors.primary)),
            const SizedBox(height: 4),
            Text("Mengenal Bunyi Huruf 'B' & 'D'", style: AppText.scale(AppText.headlineMd, skala)),
            const SizedBox(height: 6),
            Text(
              'Latihan membedakan arah perut huruf dengan irama ketukan suara yang tenang dan santai.',
              style: AppText.scale(AppText.bodyMd, skala),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppText.labelMd,
                        children: [
                          const TextSpan(text: 'Warna Pembeda: Biru untuk '),
                          TextSpan(text: 'b', style: AppText.labelLg.copyWith(color: AppColors.hurufB)),
                          const TextSpan(text: ' dan Merah untuk '),
                          TextSpan(text: 'd', style: AppText.labelLg.copyWith(color: AppColors.hurufD)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ChunkyButton(
              label: 'Mulai Petualangan',
              icon: Icons.play_circle_filled,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PracticeScreen(
                    pengguna: pengguna,
                    akses: akses,
                    onRefresh: onRefresh,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}