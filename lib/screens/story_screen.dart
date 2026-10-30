import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';

/// Layar Cerita Interaktif: baca cerita dengan suku kata terpisah,
/// sentuh untuk dengar, highlight karakter, penggaris baca.
class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key, required this.pengguna, required this.akses});

  final Pengguna pengguna;
  final Aksesibilitas akses;

  @override
  Widget build(BuildContext context) {
    final skala = akses.ukuranHuruf;
    final ceritaList = BankCerita.semua;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text('Cerita Interaktif', style: AppText.scale(AppText.headlineLgMobile, skala)),
            const SizedBox(height: 4),
            Text(
              'Baca cerita seru dengan suku kata terpisah!',
              style: AppText.scale(AppText.bodyLg, skala),
            ),
            const SizedBox(height: 20),
            for (final cerita in ceritaList) ...[
              _CeritaCard(cerita: cerita, skala: skala, pengguna: pengguna, akses: akses),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _CeritaCard extends StatelessWidget {
  const _CeritaCard({
    required this.cerita,
    required this.skala,
    required this.pengguna,
    required this.akses,
  });

  final Cerita cerita;
  final double skala;
  final Pengguna pengguna;
  final Aksesibilitas akses;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _BacaCeritaScreen(
              cerita: cerita,
              pengguna: pengguna,
              akses: akses,
            ),
          ),
        ),
        child: SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image placeholder
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryTint, AppColors.primaryFixed],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(Icons.auto_stories, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Pill(
                        label: 'Level ${cerita.level} · Suku Kata',
                        background: AppColors.surfaceLowest.withValues(alpha: 0.9),
                        foreground: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                cerita.judul,
                style: AppText.scale(AppText.headlineMd, skala),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${cerita.durasiMenit} menit', style: AppText.labelMd),
                  const SizedBox(width: 12),
                  const Icon(Icons.check_circle_outline, size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${cerita.halaman.length} halaman', style: AppText.labelMd),
                  const SizedBox(width: 12),
                  const Icon(Icons.volume_up_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('Audio', style: AppText.labelMd.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 14),
              ChunkyButton(
                label: 'Mulai Baca',
                icon: Icons.play_arrow_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _BacaCeritaScreen(
                      cerita: cerita,
                      pengguna: pengguna,
                      akses: akses,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

// ──────────────── Baca Cerita Screen ────────────────

class _BacaCeritaScreen extends StatefulWidget {
  const _BacaCeritaScreen({
    required this.cerita,
    required this.pengguna,
    required this.akses,
  });

  final Cerita cerita;
  final Pengguna pengguna;
  final Aksesibilitas akses;

  @override
  State<_BacaCeritaScreen> createState() => _BacaCeritaScreenState();
}

class _BacaCeritaScreenState extends State<_BacaCeritaScreen> {
  int _halaman = 0;
  bool _sukuKataMode = true;
  bool _selesai = false;
  int _selectedWordIndex = -1;

  HalamanCerita get _hal => widget.cerita.halaman[_halaman];

  void _next() {
    if (_halaman + 1 >= widget.cerita.halaman.length) {
      setState(() => _selesai = true);
      Store.instance.tambahCeritaSelesai();
      return;
    }
    setState(() {
      _halaman++;
      _selectedWordIndex = -1;
    });
  }

  void _prev() {
    if (_halaman > 0) {
      setState(() {
        _halaman--;
        _selectedWordIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final skala = widget.akses.ukuranHuruf;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cerita.judul, style: AppText.headlineSm),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: SafeArea(
        child: _selesai
            ? _CeritaSelesai(skala: skala, cerita: widget.cerita)
            : _buildHalaman(skala),
      ),
    );
  }

  Widget _buildHalaman(double skala) => Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Pill(
                      label: 'Halaman ${_halaman + 1} dari ${widget.cerita.halaman.length}',
                      background: AppColors.primaryTint,
                      foreground: AppColors.primary,
                      icon: Icons.menu_book,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _sukuKataMode = !_sukuKataMode),
                      child: Pill(
                        label: _sukuKataMode ? 'Suku Kata ON' : 'Normal',
                        background:
                            _sukuKataMode ? AppColors.primaryContainer : AppColors.surfaceHigh,
                        foreground:
                            _sukuKataMode ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SteppedProgress(
                  value: (_halaman + 1) / widget.cerita.halaman.length,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Story content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                // Illustration placeholder
                Container(
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryFixed.withValues(alpha: 0.5),
                        AppColors.tertiaryFixed.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Pill(
                          label: 'Adegan ${_halaman + 1}',
                          background: AppColors.surfaceLowest.withValues(alpha: 0.8),
                          foreground: AppColors.onSurface,
                        ),
                        const SizedBox(height: 8),
                        Icon(Icons.image_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
                ),
                // Text content
                SoftCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTeks(skala),
                      if (_hal.kataHighlight.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.tertiary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Bantuan Huruf Serupa: b ➡️ perut depan · d ➡️ perut belakang',
                                  style: AppText.labelMd,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Syllable touch area
                SectionHeader(
                  title: 'Sentuh & Bunyikan Suku Kata',
                  trailing: Text('Ketuk untuk dengar', style: AppText.labelMd.copyWith(color: AppColors.primary)),
                ),
                const SizedBox(height: 10),
                _buildSyllableTouchRow(skala),
              ],
            ),
          ),
          // Bottom navigation
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                if (_halaman > 0)
                  Expanded(
                    child: SecondaryButton(
                      label: 'Kembali',
                      icon: Icons.arrow_back,
                      onPressed: _prev,
                    ),
                  ),
                if (_halaman > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ChunkyButton(
                    label: _halaman + 1 >= widget.cerita.halaman.length
                        ? 'Selesai ⭐'
                        : 'Lanjut Halaman',
                    icon: Icons.arrow_forward,
                    onPressed: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildTeks(double skala) {
    final teks = _sukuKataMode ? _hal.sukuKataTerpisah : _hal.teks;
    final words = teks.split(' ');

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: List.generate(words.length, (i) {
        final word = words[i];
        final isHighlight = _hal.kataHighlight.any(
          (h) => word.toLowerCase().contains(h.toLowerCase()),
        );
        final isSelected = i == _selectedWordIndex;

        return GestureDetector(
          onTap: () => setState(() => _selectedWordIndex = i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryContainer.withValues(alpha: 0.3)
                  : isHighlight
                      ? AppColors.tertiaryFixed.withValues(alpha: 0.5)
                      : null,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              word,
              style: AppText.scale(AppText.bodyReadingMd, skala).copyWith(
                color: isHighlight ? AppColors.primary : AppColors.onSurface,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSyllableTouchRow(double skala) {
    // Extract some syllables from current page
    final parts = _hal.sukuKataTerpisah.split(' ');
    final syllables = <String>[];
    for (final word in parts) {
      final s = word.replaceAll(RegExp('[,\.!?]'), '').split('-');
      for (final syl in s) {
        if (syl.trim().isNotEmpty && syllables.length < 6) {
          syllables.add(syl.trim().toUpperCase());
        }
      }
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: syllables.map((syl) => _SyllableTouchTile(syl: syl, skala: skala)).toList(),
    );
  }
}

class _SyllableTouchTile extends StatefulWidget {
  const _SyllableTouchTile({required this.syl, required this.skala});

  final String syl;
  final double skala;

  @override
  State<_SyllableTouchTile> createState() => _SyllableTouchTileState();
}

class _SyllableTouchTileState extends State<_SyllableTouchTile>
    with SingleTickerProviderStateMixin {
  bool _active = false;

  void _tap() {
    setState(() => _active = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _active = false);
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _tap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minWidth: 72, minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _active ? AppColors.primaryContainer : AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _active ? AppColors.primaryContainer : AppColors.outlineVariant,
              width: _active ? 2 : 1.5,
            ),
            boxShadow: _active
                ? const [
                    BoxShadow(
                      color: Color(0x2038C6B6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.syl,
                style: AppText.scale(AppText.labelLg, widget.skala).copyWith(
                  color: _active ? AppColors.onPrimaryContainer : AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '/${widget.syl.toLowerCase()}/',
                style: AppText.labelSm.copyWith(
                  color: _active ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
}

class _CeritaSelesai extends StatelessWidget {
  const _CeritaSelesai({required this.skala, required this.cerita});

  final double skala;
  final Cerita cerita;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.tertiaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_stories, size: 48, color: AppColors.tertiary),
            ),
            const SizedBox(height: 24),
            Text('Cerita Selesai! 🎉', style: AppText.scale(AppText.headlineLgMobile, skala)),
            const SizedBox(height: 8),
            Text(
              'Kamu sudah membaca "${cerita.judul}" sampai selesai!',
              textAlign: TextAlign.center,
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Pill(
                  label: '+10 Bintang',
                  background: AppColors.tertiaryFixed,
                  foreground: AppColors.tertiary,
                  icon: Icons.star,
                ),
                Pill(
                  label: '${cerita.halaman.length} Halaman',
                  background: AppColors.primaryTint,
                  foreground: AppColors.primary,
                  icon: Icons.check_circle,
                ),
              ],
            ),
            const SizedBox(height: 32),
            ChunkyButton(
              label: 'Kembali',
              icon: Icons.home,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
}
