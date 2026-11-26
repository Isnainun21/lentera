import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';
import '../../domain/child.dart';
import '../practice/activities.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    if (child == null) return const Center(child: CircularProgressIndicator());
    final week = ref.watch(weekClothProvider);
    final days = week.where((d) => d.isNotEmpty).length;
    final wide = WindowSize.of(context) == WindowSize.expanded;

    final header = _Header(child: child, days: days);
    final read = _ReadPanel(child: child);
    final cloth = Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(days == 0 ? 'Kain minggu ini masih kosong' : 'Kain minggu ini', style: AppText.bodyStrong),
          const SizedBox(height: 2),
          Text(
            days == 0 ? 'Setiap kata yang kamu baca menjadi satu benang.' : 'Satu benang untuk setiap kata yang kamu selesaikan.',
            style: AppText.caption.copyWith(color: Pal.of(context).subInk),
          ),
          const SizedBox(height: 8),
          WeekCloth(days: week, maxRows: 9),
        ],
      ),
    );
    final story = _ContinueStory();
    final activities = [
      const SectionTitle('Main yang lain'),
      for (final a in Activity.values.skip(1)) ...[ActivityRow(activity: a), const SizedBox(height: 10)],
    ];

    return SafeArea(
      child: wide
          ? PaneList(
              maxWidth: 1200,
              children: [
                header,
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: Column(children: [read, const SizedBox(height: 14), story])),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [cloth, ...activities])),
                  ],
                ),
              ],
            )
          : PaneList(
              maxWidth: 680,
              children: [header, const SizedBox(height: 16), read, const SizedBox(height: 12), cloth, const SizedBox(height: 12), story, ...activities],
            ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.child, required this.days});

  final ChildProfile child;
  final int days;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: [
          Semantics(
            button: true,
            label: 'Akun ${child.nickname}',
            excludeSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showAccount(context, ref, child),
              child: AvatarMotif(avatarId: child.avatarId, size: 52),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, ${child.nickname}', style: AppText.title, maxLines: 2),
                if (days > 0) Text('Sudah berlatih $days hari minggu ini', style: AppText.caption.copyWith(color: Pal.of(context).subInk)),
              ],
            ),
          ),
          HoldToOpen(
            label: 'Area pendamping, tahan untuk membuka',
            onOpen: () => context.push('/guardian-pin'),
            child: Icon(Icons.lock_outline_rounded, size: 22, color: Pal.of(context).subInk),
          ),
        ],
      );
}

Future<void> _showAccount(BuildContext context, WidgetRef ref, ChildProfile child) => showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 0, AppSpace.gutter, AppSpace.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AvatarMotif(avatarId: child.avatarId, size: 56),
                  const SizedBox(width: 14),
                  Expanded(child: Text('Masuk sebagai ${child.nickname}', style: AppText.heading)),
                ],
              ),
              const SizedBox(height: 20),
              QuietAction(
                label: 'Kamus Kataku',
                icon: Icons.local_library_outlined,
                onPressed: () {
                  Navigator.pop(sheet);
                  context.push('/words');
                },
              ),
              const SizedBox(height: 10),
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

/// Panel utama: bidang kunyit penuh dengan pita sesi dan tombol Mulai Baca di zona jempol.
class _ReadPanel extends ConsumerWidget {
  const _ReadPanel({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(resumableProvider).value;
    final total = resume?.planned ?? child.settings.wordsPerSession;
    final done = resume?.doneWords.length ?? 0;
    final tall = !isShortLandscape(context);
    return Panel(
      color: Thread.kunyit,
      selvedge: Thread.tarum,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: tall ? 8 : 0),
          Text(
            resume != null ? 'Bacaanmu masih menunggu' : 'Baca $total kata hari ini',
            style: AppText.display.copyWith(color: Thread.onThread),
          ),
          const SizedBox(height: 8),
          Text(
            resume != null ? 'Tinggal ${total - done} kata lagi untuk menyelesaikan pita ini.' : 'Setiap kata menenun satu benang.',
            style: AppText.body.copyWith(color: Thread.onThread),
          ),
          SizedBox(height: tall ? 22 : 12),
          ThreadSlots(total: total, filled: done, onDark: true, height: 16),
          const SizedBox(height: 18),
          PrimaryAction(
            label: resume != null ? 'Lanjut Baca' : 'Mulai Baca',
            icon: Icons.play_arrow_rounded,
            onThread: true,
            onPressed: () => context.push('/session'),
          ),
        ],
      ),
    );
  }
}

/// Muncul hanya bila ada cerita yang sedang dibaca.
class _ContinueStory extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(storyProgressProvider).value ?? const [];
    final stories = ref.watch(contentProvider).stories;
    final open = progress.where((p) => p.completedAt == null && p.page > 0).toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    if (open.isEmpty) return const SizedBox.shrink();
    final story = stories.where((s) => s.id == open.first.storyId).firstOrNull;
    if (story == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Panel(
        selvedge: Thread.daun,
        padding: const EdgeInsets.all(16),
        onTap: () => context.push('/story/${story.id}'),
        semanticLabel: 'Lanjut cerita ${story.title}, halaman ${open.first.page + 1}',
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: Thread.daun, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
              child: const Icon(Icons.menu_book_rounded, color: Thread.onThread),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: AppText.bodyStrong),
                  Text('Lanjut baca halaman ${open.first.page + 1} dari ${story.pages.length}', style: AppText.caption.copyWith(color: Pal.of(context).subInk)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }
}
