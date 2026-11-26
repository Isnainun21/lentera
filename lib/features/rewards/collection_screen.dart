import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/db/database.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';

/// Daftar pencapaian, semuanya berasal dari kejadian nyata di reward_events.
const _goals = [
  ('words', '10', '10 kata', 'Berlatih 10 kata berbeda', Motif.ceplok, Thread.kunyit),
  ('words', '25', '25 kata', 'Berlatih 25 kata berbeda', Motif.ikat, Thread.jingga),
  ('days', '3', '3 hari', 'Berlatih di 3 hari berbeda', Motif.tumpal, Thread.tarumMuda),
  ('days', '7', '7 hari', 'Berlatih di 7 hari berbeda', Motif.kawung, Thread.daun),
  ('days', '30', '30 hari', 'Berlatih di 30 hari berbeda', Motif.parang, Thread.laut),
];

/// Satu baris kain: satu sesi, satu benang per kata selesai.
final _clothRowsProvider = Provider<List<(PracticeSession, List<Color>)>>((ref) {
  final sessions = (ref.watch(sessionsProvider).value ?? const <PracticeSession>[]).where((s) => s.endedAt != null).toList()
    ..sort((a, b) => b.endedAt!.compareTo(a.endedAt!));
  final attempts = ref.watch(attemptsProvider).value ?? const [];
  final finished = <String, Set<String>>{};
  for (final a in attempts) {
    if (a.finished) finished.putIfAbsent(a.sessionId, () => {}).add(a.wordId);
  }
  return [
    for (final s in sessions.take(14))
      (s, List.filled(finished[s.id]?.length ?? 0, Thread.forKind(s.kind))),
  ];
});

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Pal.of(context);
    final rewards = ref.watch(rewardsProvider).value ?? const [];
    final sessions = rewards.where((r) => r.kind == 'session').length;
    final stories = ref.watch(contentProvider).stories;
    final rows = ref.watch(_clothRowsProvider);
    final learned = ref.watch(learnedWordsProvider).length;
    bool has(String kind, String source) => rewards.any((r) => r.kind == kind && r.sourceId == source);

    final cloth = Panel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Selvedge(lead: Thread.kunyit),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$sessions', style: AppText.wordHero.copyWith(fontSize: 64)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(sessions == 0 ? 'Selesaikan latihan pertamamu untuk mulai menenun.' : 'pita kain sudah kamu tenun.', style: AppText.body),
                      ),
                    ),
                  ],
                ),
                if (rows.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'Kain-ku: ${rows.length} pita terakhir',
                    excludeSemantics: true,
                    child: Column(
                      children: [
                        for (final (session, threads) in rows)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 52,
                                  child: Text('${session.endedAt!.day}/${session.endedAt!.month}', style: AppText.caption.copyWith(color: p.subInk)),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      for (var i = 0; i < 10; i++) ...[
                                        if (i > 0) const SizedBox(width: 3),
                                        Expanded(
                                          child: i < threads.length
                                              ? ThreadBar(color: threads[i], height: 12)
                                              : Container(height: 12, decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(2))),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    Widget sticker(String title, String detail, bool reached, Motif motif, Color color) => Semantics(
          label: '$title, ${reached ? 'tercapai' : 'belum tercapai'}. $detail',
          excludeSemantics: true,
          child: SizedBox(
            width: 104,
            child: Column(
              children: [
                Opacity(
                  opacity: reached ? 1 : 0.55,
                  child: MotifTile(motif: motif, ground: reached ? color : p.surfaceAlt, ink: reached ? Thread.onThread : p.line, size: 88, radius: 18),
                ),
                const SizedBox(height: 8),
                Text(title, style: AppText.label, textAlign: TextAlign.center),
                Text(reached ? 'Tercapai' : detail, style: AppText.caption.copyWith(color: p.subInk), textAlign: TextAlign.center, maxLines: 2),
              ],
            ),
          ),
        );

    return SafeArea(
      child: PaneList(
        maxWidth: 980,
        children: [
          Text('Koleksi', style: AppText.title),
          const SizedBox(height: 16),
          cloth,
          const SectionTitle('Stiker perjalanan'),
          Wrap(
            spacing: 12,
            runSpacing: 18,
            children: [for (final (kind, source, title, detail, motif, color) in _goals) sticker(title, detail, has(kind, source), motif, color)],
          ),
          const SectionTitle('Stiker cerita'),
          Wrap(
            spacing: 12,
            runSpacing: 18,
            children: [
              for (final (i, story) in stories.indexed)
                sticker(story.title, 'Baca sampai selesai', has('story', story.id), Motif.values[(i + 2) % Motif.values.length], Thread.daun),
            ],
          ),
          const SizedBox(height: 20),
          Panel(
            padding: const EdgeInsets.all(16),
            onTap: () => context.push('/words'),
            semanticLabel: 'Kamus Kataku, $learned kata',
            child: Row(
              children: [
                Text('$learned', style: AppText.metric),
                const SizedBox(width: 14),
                Expanded(child: Text('kata di Kamus Kataku', style: AppText.bodyStrong)),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
