import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';

/// Onboarding flow: Welcome -> Nama -> Avatar -> Selesai.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onSelesai});

  final VoidCallback onSelesai;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  final _namaCtrl = TextEditingController();
  int _halaman = 0;
  int _avatarId = 0;
  int _usia = 7;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _namaCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_halaman < 3) {
      setState(() => _halaman++);
      _pageCtrl.animateToPage(_halaman,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    }
  }

  void _prev() {
    if (_halaman > 0) {
      setState(() => _halaman--);
      _pageCtrl.animateToPage(_halaman,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    }
  }

  Future<void> _simpan() async {
    final nama = _namaCtrl.text.trim();
    if (nama.isEmpty) return;
    final profil = Pengguna(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      nama: nama,
      avatarId: _avatarId,
      peran: Peran.siswa,
      usia: _usia,
      tanggalDaftar: DateTime.now(),
    );
    await Store.instance.simpanProfil(profil);
    widget.onSelesai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => _Dot(aktif: i == _halaman)),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomePage(onNext: _next),
                  _NamaPage(
                    controller: _namaCtrl,
                    usia: _usia,
                    onUsiaChanged: (v) => setState(() => _usia = v),
                    onNext: () {
                      if (_namaCtrl.text.trim().isNotEmpty) _next();
                    },
                    onBack: _prev,
                  ),
                  _AvatarPage(
                    selectedId: _avatarId,
                    onSelected: (id) => setState(() => _avatarId = id),
                    onNext: _next,
                    onBack: _prev,
                  ),
                  _SelesaiPage(
                    nama: _namaCtrl.text.trim(),
                    avatarId: _avatarId,
                    onMulai: _simpan,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.aktif});
  final bool aktif;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: aktif ? 32 : 10,
        height: 10,
        decoration: BoxDecoration(
          color: aktif ? AppColors.primaryContainer : AppColors.surfaceHighest,
          borderRadius: BorderRadius.circular(999),
        ),
      );
}

// ─────────────────── Page 1: Welcome ───────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.menu_book_rounded, size: 56, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            Text(
              'Lentera',
              style: AppText.headlineXlMobile.copyWith(color: AppColors.primary),
            ),
            Text(
              'Membaca',
              style: AppText.headlineLgMobile.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(
              'Belajar membaca jadi seru dan menyenangkan! Tidak perlu terburu-buru, kita belajar bersama dengan santai.',
              textAlign: TextAlign.center,
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 40),
            ChunkyButton(
              label: 'Mulai Petualangan',
              icon: Icons.rocket_launch,
              onPressed: onNext,
            ),
          ],
        ),
      );
}

// ─────────────────── Page 2: Nama ───────────────────

class _NamaPage extends StatelessWidget {
  const _NamaPage({
    required this.controller,
    required this.usia,
    required this.onUsiaChanged,
    required this.onNext,
    required this.onBack,
  });

  final TextEditingController controller;
  final int usia;
  final ValueChanged<int> onUsiaChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(backgroundColor: AppColors.surfaceLow),
            ),
            const SizedBox(height: 24),
            const Text('Siapa namamu? 👋', style: AppText.headlineLgMobile),
            const SizedBox(height: 8),
            const Text(
              'Masukkan nama yang ingin dipanggil di dalam aplikasi.',
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.words,
              style: AppText.bodyReadingMd,
              decoration: const InputDecoration(
                hintText: 'Nama kamu...',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              ),
              onSubmitted: (_) => onNext(),
            ),
            const SizedBox(height: 24),
            const Text('Berapa usiamu?', style: AppText.headlineSm),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(8, (i) {
                final age = i + 5;
                final selected = age == usia;
                return GestureDetector(
                  onTap: () => onUsiaChanged(age),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryContainer : AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(16),
                      border: selected
                          ? Border.all(color: AppColors.primaryContainer, width: 2)
                          : null,
                      boxShadow: selected
                          ? const [BoxShadow(color: AppColors.shadowTeal, offset: Offset(0, 3))]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$age',
                        style: AppText.headlineSm.copyWith(
                          color: selected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ChunkyButton(
                label: 'Lanjut',
                icon: Icons.arrow_forward,
                onPressed: onNext,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────── Page 3: Avatar ───────────────────

class _AvatarPage extends StatelessWidget {
  const _AvatarPage({
    required this.selectedId,
    required this.onSelected,
    required this.onNext,
    required this.onBack,
  });

  final int selectedId;
  final ValueChanged<int> onSelected;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(backgroundColor: AppColors.surfaceLow),
            ),
            const SizedBox(height: 24),
            const Text('Pilih teman belajarmu! 🎭', style: AppText.headlineLgMobile),
            const SizedBox(height: 8),
            const Text(
              'Pilih avatar yang kamu suka.',
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: AvatarData.emojis.length,
                itemBuilder: (_, i) => AvatarBubble(
                  emoji: AvatarData.emojis[i],
                  radius: 32,
                  selected: i == selectedId,
                  background:
                      i == selectedId ? AppColors.primaryFixed : AppColors.surfaceLow,
                  onTap: () => onSelected(i),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ChunkyButton(
                label: 'Lanjut',
                icon: Icons.arrow_forward,
                onPressed: onNext,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────── Page 4: Selesai ───────────────────

class _SelesaiPage extends StatelessWidget {
  const _SelesaiPage({
    required this.nama,
    required this.avatarId,
    required this.onMulai,
  });

  final String nama;
  final int avatarId;
  final VoidCallback onMulai;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarBubble(
              emoji: AvatarData.emoji(avatarId),
              radius: 52,
              background: AppColors.primaryFixed,
            ),
            const SizedBox(height: 24),
            Text(
              'Halo, ${nama.isEmpty ? 'Teman' : nama}! 🌟',
              style: AppText.headlineLgMobile,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu sudah siap memulai petualangan membaca! Yuk kita belajar bersama dengan santai dan seru.',
              textAlign: TextAlign.center,
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                Pill(
                  label: '5 Level Adaptif',
                  background: AppColors.primaryTint,
                  foreground: AppColors.primary,
                  icon: Icons.trending_up,
                ),
                Pill(
                  label: 'Cerita Interaktif',
                  background: AppColors.tertiaryFixed,
                  foreground: AppColors.tertiary,
                  icon: Icons.auto_stories,
                ),
                Pill(
                  label: 'Lencana & Bintang',
                  background: AppColors.softPeach,
                  foreground: AppColors.secondary,
                  icon: Icons.military_tech,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ChunkyButton(
              label: 'Mulai Belajar!',
              icon: Icons.play_arrow_rounded,
              onPressed: onMulai,
            ),
          ],
        ),
      );
}
