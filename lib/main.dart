import 'package:flutter/material.dart';

import 'models.dart';
import 'screens/home_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/progress_screen.dart';
import 'store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.instance.init();
  runApp(const ReadAdaptApp());
}

class ReadAdaptApp extends StatelessWidget {
  const ReadAdaptApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ReadAdapt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _Root(),
      );
}

class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    // Profil default kalau belum ada (RA-PRD-101: avatar + nama, tanpa teks panjang).
    var profil = Store.instance.bacaProfil();
    profil ??= const Pengguna(id: 'u1', nama: 'Bima', avatarId: 0, peran: Peran.siswa, levelSaatIni: 1);
    final akses = Store.instance.bacaAksesibilitas();

    final layar = [
      HomeScreen(pengguna: profil, akses: akses),
      PracticeScreen(pengguna: profil, akses: akses),
      const _PlaceholderTab(judul: 'Cerita', ikon: Icons.menu_book),
      ProgressScreen(pengguna: profil, akses: akses),
    ];

    return Scaffold(
      body: IndexedStack(index: _tab, children: layar),
      bottomNavigationBar: _Dock(
        aktif: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

/// Dock mengambang 4 tab (Beranda / Latihan / Cerita / Progres) sesuai UI Stitch.
class _Dock extends StatelessWidget {
  const _Dock({required this.aktif, required this.onTap});

  final int aktif;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.cottage_outlined, 'Beranda'),
    (Icons.extension_outlined, 'Latihan'),
    (Icons.menu_book_outlined, 'Cerita'),
    (Icons.stars_outlined, 'Progres'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.92),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), offset: Offset(0, -2), blurRadius: 12)],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < _items.length; i++)
                  _DockItem(
                    ikon: _items[i].$1,
                    label: _items[i].$2,
                    aktif: aktif == i,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ),
      );
}

class _DockItem extends StatelessWidget {
  const _DockItem({required this.ikon, required this.label, required this.aktif, required this.onTap});

  final IconData ikon;
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: aktif ? AppColors.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: aktif ? const [BoxShadow(color: AppColors.shadowTeal, offset: Offset(0, 4))] : null,
          ),
          child: Row(
            children: [
              Icon(ikon, size: 22, color: aktif ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant),
              if (aktif) ...[
                const SizedBox(width: 6),
                Text(label, style: AppText.labelMd.copyWith(color: AppColors.onPrimaryContainer)),
              ],
            ],
          ),
        ),
      );
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.judul, required this.ikon});

  final String judul;
  final IconData ikon;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 64, color: AppColors.primaryContainer),
              const SizedBox(height: 12),
              Text(judul, style: AppText.headlineMd),
              const SizedBox(height: 4),
              const Text('Modul ini menyusul.', style: AppText.bodyMd),
            ],
          ),
        ),
      );
}