import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/scenes.dart';
import '../../core/design/tokens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    if (child == null) return const Center(child: CircularProgressIndicator(color: AppColors.ink));
    final resume = ref.watch(hasOpenSessionProvider).value ?? false;
    final week = ref.watch(weekLanternsProvider);
    final days = week.where((d) => d).length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpace.gutter),
        children: [
          Row(
            children: [
              Expanded(child: Text('Halo, ${child.nickname}', style: AppText.title, overflow: TextOverflow.ellipsis)),
              HoldToOpen(
                label: 'Area pendamping, tahan untuk membuka',
                onOpen: () => context.push('/guardian-pin'),
                child: const Icon(Icons.lock_outline_rounded, size: 22, color: AppColors.subInk),
              ),
              const SizedBox(width: 4),
              Semantics(
                button: true,
                label: 'Akun ${child.nickname}',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => _showAccount(context, ref, child.nickname),
                  child: AvatarCircle(avatarId: child.avatarId, name: child.nickname, size: 52),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ReadCard(resume: resume),
          const SizedBox(height: 14),
          CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(days == 0 ? 'Minggu ini' : 'Minggu ini, $days hari berlatih', style: AppText.bodyStrong),
                const SizedBox(height: 14),
                WeekLanterns(lit: week),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mau main apa?', style: AppText.bodyStrong),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ActivityCircle(icon: Icons.record_voice_over_rounded, label: 'Baca', color: AppColors.lantern, onTap: () => context.push('/session')),
                    ),
                    Expanded(
                      child: ActivityCircle(icon: Icons.abc_rounded, label: 'Huruf', color: AppColors.sky, onTap: () => context.push('/letters')),
                    ),
                    Expanded(
                      child: ActivityCircle(icon: Icons.menu_book_rounded, label: 'Cerita', color: AppColors.leaf, onTap: () => context.go('/stories')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showAccount(BuildContext context, WidgetRef ref, String name) => showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Masuk sebagai $name', style: AppText.heading),
              const SizedBox(height: 16),
              PrimaryAction(
                label: 'Keluar',
                icon: Icons.logout_rounded,
                onPressed: () async {
                  Navigator.pop(sheet);
                  await ref.read(repositoryProvider).signOutChild();
                  if (context.mounted) context.go('/profiles');
                },
              ),
            ],
          ),
        ),
      ),
    );

class _ReadCard extends StatelessWidget {
  const _ReadCard({required this.resume});

  final bool resume;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AppSpace.cardRadius),
        child: Stack(
          children: [
            const Positioned.fill(child: SceneArt(scene: Scene.hills)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 200, 14, 14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      resume ? 'Bacaanmu masih menunggu' : 'Baca beberapa kata hari ini',
                      style: AppText.heading.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => context.push('/session'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.lantern,
                        foregroundColor: AppColors.ink,
                        minimumSize: const Size.fromHeight(AppSpace.tapChild),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        textStyle: AppText.bodyStrong,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow_rounded, size: 26),
                          const SizedBox(width: 6),
                          Flexible(child: Text(resume ? 'Lanjut Baca' : 'Mulai Baca')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
