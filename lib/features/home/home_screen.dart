import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    if (child == null) return const Center(child: CircularProgressIndicator());
    final resume = ref.watch(hasOpenSessionProvider).value ?? false;
    final week = ref.watch(weekLanternsProvider);
    final practicedToday = week[DateTime.now().weekday - 1];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpace.gutter),
        children: [
          Row(
            children: [
              Semantics(
                button: true,
                label: 'Ganti profil',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => context.go('/profiles'),
                  child: AvatarCircle(avatarId: child.avatarId, name: child.nickname, size: 56),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('Halo, ${child.nickname}', style: AppText.title, overflow: TextOverflow.ellipsis)),
              HoldToOpen(
                label: 'Area pendamping, tahan untuk membuka',
                onOpen: () => context.push('/guardian-pin'),
                child: const Icon(Icons.lock_outline_rounded, size: 22, color: AppColors.subInk),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LanternFrame(
            color: AppColors.lanternSoft,
            light: practicedToday ? 1 : 0.18,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 260),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 72, 28, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resume ? 'Bacaanmu masih menunggu' : 'Yuk nyalakan lentera hari ini', style: AppText.title),
                    const SizedBox(height: 6),
                    Text(resume ? 'Lanjutkan dari kata terakhir.' : 'Baca beberapa kata bersama Lentera.', style: AppText.body),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryAction(
            label: resume ? 'Lanjut Baca' : 'Mulai Baca',
            icon: Icons.play_arrow_rounded,
            onPressed: () => context.push('/session'),
          ),
          const SizedBox(height: 20),
          CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lentera minggu ini', style: AppText.bodyStrong),
                const SizedBox(height: 14),
                WeekLanterns(lit: week),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ActivityPillar(
                  label: 'Cerita',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.leaf,
                  onTap: () => context.go('/stories'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActivityPillar(
                  label: 'Beda Huruf',
                  icon: Icons.abc_rounded,
                  color: AppColors.sky,
                  onTap: () => context.push('/letters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Kolom lengkung pembuka aktivitas.
class ActivityPillar extends StatelessWidget {
  const ActivityPillar({super.key, required this.label, required this.icon, required this.color, required this.onTap, this.height = 180, this.description});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double height;
  final String? description;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: color,
          shape: const LanternShape(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              constraints: BoxConstraints(minHeight: height),
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text(label, style: AppText.bodyStrong, textAlign: TextAlign.center),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(description!, style: AppText.bodyGuardian, textAlign: TextAlign.center),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
