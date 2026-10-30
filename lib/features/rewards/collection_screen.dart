import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';

/// Daftar pencapaian, semuanya berasal dari kejadian nyata di reward_events.
const _goals = [
  ('words', '10', '10 kata', 'Berlatih 10 kata berbeda'),
  ('words', '25', '25 kata', 'Berlatih 25 kata berbeda'),
  ('days', '3', '3 hari', 'Berlatih di 3 hari berbeda'),
  ('days', '7', '7 hari', 'Berlatih di 7 hari berbeda'),
  ('days', '30', '30 hari', 'Berlatih di 30 hari berbeda'),
];

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardsProvider).value ?? const [];
    final sessions = rewards.where((r) => r.kind == 'session').length;
    final stories = ref.watch(contentProvider).stories;
    bool has(String kind, String source) => rewards.any((r) => r.kind == kind && r.sourceId == source);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpace.gutter),
        children: [
          Text('Koleksi', style: AppText.title),
          const SizedBox(height: 16),
          CardBox(
            color: AppColors.lantern,
            child: Row(
              children: [
                Text('$sessions', style: AppText.wordHero),
                const SizedBox(width: 16),
                Expanded(child: Text(sessions == 0 ? 'Selesaikan latihan pertamamu.' : 'latihan sudah kamu selesaikan.', style: AppText.body)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Perjalanan membaca', style: AppText.heading),
          const SizedBox(height: 10),
          CardBox(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                for (final (kind, source, title, detail) in _goals) _GoalRow(title: title, detail: detail, reached: has(kind, source)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('Cerita', style: AppText.heading),
          const SizedBox(height: 10),
          CardBox(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                for (final story in stories) _GoalRow(title: story.title, detail: 'Baca sampai selesai', reached: has('story', story.id)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.title, required this.detail, required this.reached});

  final String title;
  final String detail;
  final bool reached;

  @override
  Widget build(BuildContext context) => Semantics(
        label: '$title, ${reached ? 'tercapai' : 'belum tercapai'}. $detail',
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              DayRing(done: reached, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.bodyStrong),
                    Text(detail, style: AppText.bodyGuardian),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
