import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';
import 'activities.dart';

class PracticeHubScreen extends ConsumerWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learned = ref.watch(learnedWordsProvider).length;
    final p = Pal.of(context);
    return SafeArea(
      child: PaneList(
        maxWidth: 980,
        children: [
          Text('Mau latihan apa?', style: AppText.title),
          const SizedBox(height: 16),
          FlowColumns(minItemWidth: 280, maxColumns: 2, children: [for (final a in Activity.values) _ActivityPanel(activity: a)]),
          const SizedBox(height: 14),
          Panel(
            padding: const EdgeInsets.all(16),
            onTap: () => context.push('/words'),
            semanticLabel: 'Kamus Kataku, $learned kata',
            child: Row(
              children: [
                MotifTile(motif: Motif.ceplok, ground: p.surfaceAlt, ink: p.ink, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kamus Kataku', style: AppText.bodyStrong),
                      Text(
                        learned == 0
                            ? 'Kata yang kamu baca akan tersimpan di sini.'
                            : '$learned kata sudah kamu baca. Sentuh untuk mendengar lagi.',
                        style: AppText.caption.copyWith(color: p.subInk),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) => Panel(
    color: activity.color,
    selvedge: Thread.tarum,
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
    onTap: () => activity.open(context),
    semanticLabel: '${activity.title}. ${activity.line}',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Sample(activity: activity),
        const SizedBox(height: 28),
        Text(activity.title, style: AppText.title.copyWith(color: Thread.onThread)),
        const SizedBox(height: 2),
        Text(activity.line, style: AppText.body.copyWith(color: Thread.onThread)),
      ],
    ),
  );
}

/// Potongan isi aktivitas yang sebenarnya, digambar besar.
class _Sample extends StatelessWidget {
  const _Sample({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    Widget tile(String t, {bool dim = false}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: dim ? Colors.white.withValues(alpha: 0.35) : Colors.white,
        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
      ),
      child: Text(t, style: AppText.syllable.copyWith(color: Thread.onThread, fontSize: 26)),
    );
    return ExcludeSemantics(
      child: SizedBox(
        height: 64,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: switch (activity) {
            Activity.read => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Thread.tarum, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 12),
                tile('BU'),
                const SizedBox(width: 8),
                tile('KU'),
              ],
            ),
            Activity.build => Row(
              mainAxisSize: MainAxisSize.min,
              children: [tile('KU', dim: true), const SizedBox(width: 8), tile('BU'), const SizedBox(width: 8), tile('?', dim: true)],
            ),
            Activity.listen => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.volume_up_rounded, size: 40, color: Thread.onThread),
                const SizedBox(width: 12),
                tile('MATA'),
                const SizedBox(width: 8),
                tile('MAMA', dim: true),
              ],
            ),
            Activity.letters => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                tile('b'),
                const SizedBox(width: 8),
                tile('d', dim: true),
                const SizedBox(width: 8),
                tile('b'),
                const SizedBox(width: 8),
                tile('p', dim: true),
              ],
            ),
          },
        ),
      ),
    );
  }
}
