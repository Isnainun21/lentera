import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../content/content.dart';
import '../../core/db/database.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../domain/practice/models.dart';
import '../../domain/progress/stats.dart';

class GuardianPinScreen extends ConsumerStatefulWidget {
  const GuardianPinScreen({super.key});

  @override
  ConsumerState<GuardianPinScreen> createState() => _GuardianPinScreenState();
}

class _GuardianPinScreenState extends ConsumerState<GuardianPinScreen> {
  final _pin = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (await ref.read(repositoryProvider).checkPin(_pin.text.trim())) {
      if (mounted) context.pushReplacement('/guardian');
    } else {
      setState(() {
        _error = 'PIN belum tepat.';
        _pin.clear();
      });
    }
  }

  Future<void> _forgot() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lupa PIN?'),
        content: const Text('PIN hanya tersimpan di perangkat ini. Untuk membuat PIN baru, semua data Lentera di perangkat ini harus dihapus. Data yang sudah tersinkron bisa diambil lagi setelah masuk ke akun.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus data perangkat')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(repositoryProvider).resetDevice();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Area Pendamping')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Masukkan PIN', style: AppText.title),
                const SizedBox(height: 16),
                TextField(
                  controller: _pin,
                  autofocus: true,
                  obscureText: true,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  style: AppText.heading,
                  decoration: const InputDecoration(labelText: 'PIN 4 angka', counterText: ''),
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: AppText.bodyGuardian.copyWith(color: AppColors.retry)),
                  ),
                const SizedBox(height: 16),
                PrimaryAction(label: 'Buka', onPressed: _submit),
                const SizedBox(height: 8),
                TextButton(onPressed: _forgot, child: Text('Lupa PIN', style: AppText.bodyGuardian)),
              ],
            ),
          ),
        ),
      );
}

/// Ringkasan yang dihitung sekali untuk layar dan laporan.
class ChildSummary {
  ChildSummary(List<AttemptRecord> attempts, List<PracticeSession> sessions, Content content, DateTime now)
      : wordAttempts = attempts.where((a) => a.wordId.startsWith('l')).toList(),
        letterAttempts = attempts.where((a) => a.wordId.startsWith('h')).toList() {
    final results = ProgressStats.wordResults(wordAttempts);
    final weekStart = ProgressStats.startOfWeek(now);
    final lastWeekStart = DateTime(weekStart.year, weekStart.month, weekStart.day - 7);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final thisWeek = ProgressStats.between(results, weekStart, tomorrow);
    final lastWeek = ProgressStats.between(results, lastWeekStart, weekStart);

    wordsThisWeek = thisWeek.where((r) => r.counted).length;
    accuracy = ProgressStats.accuracy(thisWeek);
    final previous = ProgressStats.accuracy(lastWeek);
    trend = accuracy != null && previous != null ? accuracy! - previous : null;

    final ended = sessions.where((s) => s.endedAt != null && !s.endedAt!.isBefore(weekStart));
    minutesThisWeek = ended.fold<int>(0, (sum, s) => sum + s.endedAt!.difference(s.startedAt).inSeconds) ~/ 60;

    difficult = [
      for (final id in ProgressStats.difficultWords(wordAttempts))
        if (content.wordById(id) != null) content.wordById(id)!,
    ];

    letterAccuracy = {
      for (final letter in const ['b', 'd'])
        letter: ProgressStats.accuracy(ProgressStats.wordResults([
          ...wordAttempts.where((a) => content.wordById(a.wordId)?.text.toLowerCase().contains(letter) ?? false),
          ...letterAttempts.where((a) => content.letters.any((q) => q.id == a.wordId && q.target == letter)),
        ])),
    };

    dayBars = [
      for (var i = 6; i >= 0; i--)
        () {
          final day = DateTime(now.year, now.month, now.day - i);
          final inDay = ProgressStats.between(results, day, DateTime(day.year, day.month, day.day + 1)).where((r) => r.counted);
          return DayBar(day, inDay.where((r) => r.correctAlone).length, inDay.where((r) => !r.correctAlone).length);
        }(),
    ];
  }

  final List<AttemptRecord> wordAttempts;
  final List<AttemptRecord> letterAttempts;
  late final int wordsThisWeek;
  late final double? accuracy;
  late final double? trend;
  late final int minutesThisWeek;
  late final List<Word> difficult;
  late final Map<String, double?> letterAccuracy;
  late final List<DayBar> dayBars;
}

class DayBar {
  const DayBar(this.day, this.alone, this.helped);

  final DateTime day;
  final int alone;
  final int helped;
}

String percent(double? v) => v == null ? 'Belum cukup data' : '${(v * 100).round()}%';

class GuardianSummaryScreen extends ConsumerWidget {
  const GuardianSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    final attempts = ref.watch(attemptsProvider);
    final sessions = ref.watch(sessionsProvider);
    final content = ref.watch(contentProvider);
    if (child == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: MessageState(title: 'Pilih profil anak terlebih dahulu')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(child.nickname)),
      body: attempts.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.ink)),
        error: (_, _) => const Center(child: MessageState(title: 'Data belum bisa dimuat', body: 'Tutup lalu buka lagi Area Pendamping.')),
        data: (list) {
          final s = ChildSummary(list, sessions.value ?? const [], content, DateTime.now());
          return ListView(
            padding: const EdgeInsets.all(AppSpace.gutter),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _Pillar(color: AppColors.sky, icon: Icons.abc_rounded, label: 'Level', value: '${child.level}')),
                  const SizedBox(width: 10),
                  Expanded(child: _Pillar(color: AppColors.leaf, icon: Icons.schedule_rounded, label: 'Menit', value: '${s.minutesThisWeek}')),
                  const SizedBox(width: 10),
                  Expanded(child: _Pillar(color: AppColors.lantern, icon: Icons.check_rounded, label: 'Ketepatan', value: s.accuracy == null ? '-' : percent(s.accuracy))),
                ],
              ),
              const SizedBox(height: 12),
              CardBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${s.wordsThisWeek} kata', style: AppText.metric),
                    Text('selesai minggu ini', style: AppText.bodyGuardian),
                    const SizedBox(height: 16),
                    TrendBars(bars: s.dayBars),
                    const SizedBox(height: 10),
                    const _Legend(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CardBox(
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    _Metric(
                      label: 'Dibanding minggu lalu',
                      value: s.trend == null ? 'Belum cukup data' : '${s.trend! >= 0 ? '+' : ''}${(s.trend! * 100).round()} poin',
                    ),
                    _Metric(label: 'Huruf b', value: percent(s.letterAccuracy['b'])),
                    _Metric(label: 'Huruf d', value: percent(s.letterAccuracy['d'])),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CardBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kata yang perlu latihan', style: AppText.bodyStrong),
                    const SizedBox(height: 8),
                    if (s.difficult.isEmpty)
                      Text('Belum ada. Kata muncul di sini setelah 2 kali belum tepat.', style: AppText.bodyGuardian),
                    for (final w in s.difficult)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(w.text, style: AppText.bodyStrong),
                        trailing: TextButton(
                          onPressed: () {
                            ref.read(priorityWordsProvider.notifier).add(w.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${w.text} masuk sesi berikutnya.')));
                          },
                          child: const Text('Latih di sesi berikutnya'),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _NavRow(label: 'Riwayat sesi', icon: Icons.history_rounded, path: '/guardian/history'),
              _NavRow(label: 'Pengaturan belajar', icon: Icons.tune_rounded, path: '/guardian/learning'),
              _NavRow(label: 'Aksesibilitas', icon: Icons.accessibility_new_rounded, path: '/guardian/access'),
              _NavRow(label: 'Akun dan sinkron', icon: Icons.sync_rounded, path: '/guardian/account'),
              _NavRow(label: 'Data, laporan, dan profil', icon: Icons.folder_outlined, path: '/guardian/data'),
            ],
          );
        },
      ),
    );
  }
}

class _Pillar extends StatelessWidget {
  const _Pillar({required this.color, required this.icon, required this.label, required this.value});

  final Color color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Semantics(
        label: '$label $value',
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 18),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(40)),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 12),
              FittedBox(fit: BoxFit.scaleDown, child: Text(label, style: AppText.caption.copyWith(color: AppColors.ink))),
              const SizedBox(height: 6),
              FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: AppText.metric.copyWith(fontSize: 26))),
            ],
          ),
        ),
      );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, c) => SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label, style: AppText.bodyGuardian)),
              const SizedBox(width: 12),
              Flexible(child: Text(value, style: AppText.bodyStrong, textAlign: TextAlign.end)),
            ],
          ),
        ),
      );
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.label, required this.icon, required this.path});

  final String label;
  final IconData icon;
  final String path;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          child: ListTile(
            minTileHeight: AppSpace.tapChild,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
            leading: Icon(icon, color: AppColors.ink),
            title: Text(label, style: AppText.bodyGuardian),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.ink),
            onTap: () => context.push(path),
          ),
        ),
      );
}

class _Legend extends StatelessWidget {
  const _Legend();

  Widget _key(Color c, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Flexible(child: Text(label, style: AppText.caption)),
        ],
      );

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 14,
        runSpacing: 4,
        children: [_key(AppColors.ok, 'Benar sendiri'), _key(AppColors.lantern, 'Dibantu')],
      );
}

/// Batang berlapis untuk 7 hari terakhir.
class TrendBars extends StatelessWidget {
  const TrendBars({super.key, required this.bars});

  final List<DayBar> bars;
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final peak = bars.fold<int>(0, (m, b) => b.alone + b.helped > m ? b.alone + b.helped : m);
    final total = bars.fold<int>(0, (m, b) => m + b.alone + b.helped);
    return Semantics(
      label: '7 hari terakhir: $total kata selesai',
      excludeSemantics: true,
      child: SizedBox(
        height: 130,
        child: total == 0
            ? Center(child: Text('Belum ada latihan 7 hari terakhir.', style: AppText.bodyGuardian))
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final b in bars)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (b.helped > 0)
                              Container(
                                height: 90 * b.helped / peak,
                                decoration: const BoxDecoration(
                                  color: AppColors.lantern,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                                ),
                              ),
                            if (b.alone > 0)
                              Container(
                                height: 90 * b.alone / peak,
                                decoration: BoxDecoration(
                                  color: AppColors.ok,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(b.helped > 0 ? 0 : 6)),
                                ),
                              ),
                            const SizedBox(height: 6),
                            Text(_days[b.day.weekday - 1], style: AppText.caption, softWrap: false, overflow: TextOverflow.visible),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat sesi')),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.ink)),
        error: (_, _) => const Center(child: MessageState(title: 'Riwayat belum bisa dimuat')),
        data: (list) => list.isEmpty
            ? const Center(child: MessageState(title: 'Belum ada sesi', body: 'Riwayat muncul setelah anak mulai berlatih.'))
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpace.gutter),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _SessionTile(session: list[i]),
              ),
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session});

  final PracticeSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = session.startedAt;
    final kind = session.kind == 'letters' ? 'Beda Huruf' : 'Baca Kata';
    final status = session.endedAt == null ? 'belum selesai' : 'level ${session.startLevel} ke ${session.endLevel ?? session.startLevel}';
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpace.tileRadius),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        title: Text('$kind, ${t.day}/${t.month}/${t.year}', style: AppText.bodyStrong),
        subtitle: Text(status, style: AppText.caption),
        children: [
          StreamBuilder<List<Attempt>>(
            stream: ref.watch(repositoryProvider).watchSessionAttempts(session.id),
            builder: (context, snap) {
              final attempts = snap.data ?? const <Attempt>[];
              if (attempts.isEmpty) {
                return Padding(padding: const EdgeInsets.all(16), child: Text('Belum ada percobaan.', style: AppText.bodyGuardian));
              }
              final content = ref.read(contentProvider);
              return Column(
                children: [
                  for (final a in attempts)
                    ListTile(
                      dense: true,
                      title: Text(content.wordById(a.wordId)?.text ?? a.wordId, style: AppText.bodyGuardian),
                      trailing: Text(_statusLabel(a), style: AppText.caption),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _statusLabel(Attempt a) {
    if (a.guardianOverride) return 'Dikoreksi pendamping';
    return switch (AttemptStatus.values.byName(a.status)) {
      AttemptStatus.correct => 'Benar',
      AttemptStatus.partial => 'Sebagian',
      AttemptStatus.wrong => 'Belum tepat',
      AttemptStatus.unclear => 'Tidak terdengar',
    };
  }
}
