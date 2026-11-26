import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../content/content.dart';
import '../../core/db/database.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';
import '../../domain/practice/models.dart';
import '../../domain/progress/stats.dart';

class GuardianPinScreen extends ConsumerStatefulWidget {
  const GuardianPinScreen({super.key});

  @override
  ConsumerState<GuardianPinScreen> createState() => _GuardianPinScreenState();
}

class _GuardianPinScreenState extends ConsumerState<GuardianPinScreen> {
  String? _error;

  Future<bool> _submit(String pin) async {
    if (await ref.read(repositoryProvider).checkPin(pin)) {
      if (mounted) context.pushReplacement('/guardian');
      return true;
    }
    setState(() => _error = 'PIN belum tepat.');
    return false;
  }

  Future<void> _forgot() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lupa PIN?'),
        content: const Text(
          'PIN hanya tersimpan di perangkat ini. Untuk membuat PIN baru, semua data Lentera di perangkat ini harus dihapus. Data yang sudah tersinkron bisa diambil lagi setelah masuk ke akun.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Pal.of(ctx).retry),
            child: const Text('Hapus data perangkat'),
          ),
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
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(gutterFor(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Masukkan PIN', style: AppText.title),
              const SizedBox(height: 6),
              Text('Area ini untuk orang tua dan guru.', style: AppText.bodyGuardian.copyWith(color: Pal.of(context).subInk)),
              const SizedBox(height: 24),
              PinPad(onComplete: _submit, error: _error),
              const SizedBox(height: 12),
              TextButton(onPressed: _forgot, child: const Text('Lupa PIN')),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Ringkasan yang dihitung sekali untuk layar dan laporan.
class ChildSummary {
  ChildSummary(List<AttemptRecord> attempts, List<PracticeSession> sessions, Content content, DateTime now) {
    // Susun Kata dan Dengar dan Pilih memakai kata yang sama, tetapi tidak menguji ucapan,
    // jadi tidak ikut ke ketepatan membaca.
    final notReading = {
      for (final s in sessions)
        if (s.kind == 'build' || s.kind == 'listen') s.id,
    };
    wordAttempts = attempts.where((a) => a.wordId.startsWith('l') && !notReading.contains(a.sessionId)).toList();
    letterAttempts = attempts.where((a) => a.wordId.startsWith('h')).toList();
    gameAttempts = attempts.where((a) => notReading.contains(a.sessionId)).toList();

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
    sessionsThisWeek = ended.length;

    difficult = [
      for (final id in ProgressStats.difficultWords(wordAttempts))
        if (content.wordById(id) != null) content.wordById(id)!,
    ];

    letterAccuracy = {
      for (final letter in const ['b', 'd'])
        letter: ProgressStats.accuracy(
          ProgressStats.wordResults([
            ...wordAttempts.where((a) => content.wordById(a.wordId)?.text.toLowerCase().contains(letter) ?? false),
            ...letterAttempts.where((a) => content.letters.any((q) => q.id == a.wordId && q.target == letter)),
          ]),
        ),
    };

    List<DayBar> bars(int days) => [
      for (var i = days - 1; i >= 0; i--)
        () {
          final day = DateTime(now.year, now.month, now.day - i);
          final inDay = ProgressStats.between(results, day, DateTime(day.year, day.month, day.day + 1)).where((r) => r.counted);
          return DayBar(day, inDay.where((r) => r.correctAlone).length, inDay.where((r) => !r.correctAlone).length);
        }(),
    ];
    dayBars = bars(7);
    dayBars30 = bars(30);
  }

  late final List<AttemptRecord> wordAttempts;
  late final List<AttemptRecord> letterAttempts;
  late final List<AttemptRecord> gameAttempts;
  late final int wordsThisWeek;
  late final double? accuracy;
  late final double? trend;
  late final int minutesThisWeek;
  late final int sessionsThisWeek;
  late final List<Word> difficult;
  late final Map<String, double?> letterAccuracy;
  late final List<DayBar> dayBars;
  late final List<DayBar> dayBars30;
}

class DayBar {
  const DayBar(this.day, this.alone, this.helped);

  final DateTime day;
  final int alone;
  final int helped;
}

String percent(double? v) => v == null ? 'Belum cukup data' : '${(v * 100).round()}%';

/// Statistik satu kata dari log percobaan.
class WordStat {
  WordStat(this.word, List<AttemptRecord> attempts)
    : tries = attempts.length,
      results = ProgressStats.wordResults(attempts),
      last = attempts.map((a) => a.occurredAt).reduce((a, b) => a.isAfter(b) ? a : b);

  final Word word;
  final int tries;
  final List<WordResult> results;
  final DateTime last;

  int get alone => results.where((r) => r.correctAlone).length;
  int get counted => results.where((r) => r.counted).length;
}

List<WordStat> wordStats(List<AttemptRecord> attempts, Content content) {
  final groups = <String, List<AttemptRecord>>{};
  for (final a in attempts) {
    groups.putIfAbsent(a.wordId, () => []).add(a);
  }
  return [
    for (final e in groups.entries)
      if (content.wordById(e.key) != null) WordStat(content.wordById(e.key)!, e.value),
  ]..sort((a, b) => b.tries.compareTo(a.tries));
}

Future<void> showWordDetail(BuildContext context, WidgetRef ref, WordStat s) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (sheet) {
    final p = Pal.of(sheet);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 0, AppSpace.gutter, AppSpace.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.word.text, style: AppText.title),
            Text('${s.word.syllables.join(' · ')} · level ${s.word.level}', style: AppText.caption.copyWith(color: p.subInk)),
            const SizedBox(height: 16),
            _Metric(label: 'Percobaan', value: '${s.tries}'),
            const SizedBox(height: 8),
            _Metric(label: 'Selesai dan terhitung', value: '${s.counted} kali'),
            const SizedBox(height: 8),
            _Metric(label: 'Benar tanpa bantuan', value: '${s.alone} kali'),
            const SizedBox(height: 8),
            _Metric(label: 'Terakhir dilatih', value: '${s.last.day}/${s.last.month}/${s.last.year}'),
            const SizedBox(height: 20),
            PrimaryAction(
              label: 'Latih di sesi berikutnya',
              onPressed: () {
                ref.read(priorityWordsProvider.notifier).add(s.word.id);
                Navigator.pop(sheet);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s.word.text} masuk sesi berikutnya.')));
              },
            ),
          ],
        ),
      ),
    );
  },
);

Future<void> _switchChild(BuildContext context, WidgetRef ref) => showModalBottomSheet<void>(
  context: context,
  builder: (sheet) {
    final children = ref.read(childrenProvider).value ?? const [];
    final active = ref.read(activeChildProvider)?.id;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 0, AppSpace.gutter, AppSpace.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Lihat data anak', style: AppText.heading),
            const SizedBox(height: 12),
            for (final c in children)
              ListTile(
                minTileHeight: AppSpace.tapChild,
                leading: AvatarMotif(avatarId: c.avatarId, size: 40),
                title: Text(c.nickname, style: AppText.bodyStrong),
                trailing: c.id == active ? const Icon(Icons.check_rounded) : null,
                onTap: () async {
                  Navigator.pop(sheet);
                  await ref.read(repositoryProvider).writeKey('activeChild', c.id);
                },
              ),
            const SizedBox(height: 8),
            QuietAction(
              label: 'Tambah profil anak',
              icon: Icons.person_add_alt_rounded,
              onPressed: () {
                Navigator.pop(sheet);
                context.push('/setup?add=1');
              },
            ),
          ],
        ),
      ),
    );
  },
);

class GuardianSummaryScreen extends ConsumerStatefulWidget {
  const GuardianSummaryScreen({super.key});

  @override
  ConsumerState<GuardianSummaryScreen> createState() => _GuardianSummaryScreenState();
}

class _GuardianSummaryScreenState extends ConsumerState<GuardianSummaryScreen> {
  bool _month = false;

  @override
  Widget build(BuildContext context) {
    final child = ref.watch(activeChildProvider);
    final attempts = ref.watch(attemptsProvider);
    final sessions = ref.watch(sessionsProvider);
    final content = ref.watch(contentProvider);
    final p = Pal.of(context);
    if (child == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: MessageState(title: 'Pilih profil anak terlebih dahulu', motif: Motif.kawung),
        ),
      );
    }
    final many = (ref.watch(childrenProvider).value ?? const []).length > 1;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AvatarMotif(avatarId: child.avatarId, size: 36),
            const SizedBox(width: 12),
            Flexible(child: Text(child.nickname, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _switchChild(context, ref),
            icon: const Icon(Icons.swap_horiz_rounded),
            label: Text(many ? 'Ganti anak' : 'Anak'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: attempts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: MessageState(title: 'Data belum bisa dimuat', body: 'Tutup lalu buka lagi Area Pendamping.'),
        ),
        data: (list) {
          final s = ChildSummary(list, sessions.value ?? const [], content, DateTime.now());
          final stats = Panel(
            child: Column(
              children: [
                _Metric(label: 'Level sekarang', value: '${child.level}'),
                const SizedBox(height: 14),
                _Metric(label: 'Waktu latihan minggu ini', value: '${s.minutesThisWeek} menit'),
                const SizedBox(height: 14),
                _Metric(label: 'Ketepatan minggu ini', value: percent(s.accuracy)),
                if (s.accuracy == null) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ketepatan muncul setelah ${ProgressStats.minWordsForAccuracy} kata terhitung.',
                      style: AppText.caption.copyWith(color: p.subInk),
                    ),
                  ),
                ],
              ],
            ),
          );
          final trend = Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${s.wordsThisWeek} kata', style: AppText.metric),
                          Text('selesai minggu ini, ${s.sessionsThisWeek} sesi', style: AppText.bodyGuardian.copyWith(color: p.subInk)),
                        ],
                      ),
                    ),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('7 hari')),
                        ButtonSegment(value: true, label: Text('30 hari')),
                      ],
                      selected: {_month},
                      showSelectedIcon: false,
                      onSelectionChanged: (v) => setState(() => _month = v.first),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TrendBars(bars: _month ? s.dayBars30 : s.dayBars),
                const SizedBox(height: 10),
                const _Legend(),
              ],
            ),
          );
          final compare = Panel(
            child: Column(
              children: [
                _Metric(
                  label: 'Dibanding minggu lalu',
                  value: s.trend == null ? 'Belum cukup data' : '${s.trend! >= 0 ? '+' : ''}${(s.trend! * 100).round()} poin',
                ),
                const SizedBox(height: 14),
                _Metric(label: 'Huruf b', value: percent(s.letterAccuracy['b'])),
                const SizedBox(height: 14),
                _Metric(label: 'Huruf d', value: percent(s.letterAccuracy['d'])),
                const SizedBox(height: 14),
                _Metric(label: 'Kata di permainan', value: '${ProgressStats.wordResults(s.gameAttempts).length}'),
              ],
            ),
          );
          final stat = {for (final w in wordStats(s.wordAttempts, content)) w.word.id: w};
          final difficult = Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kata yang perlu latihan', style: AppText.bodyStrong),
                const SizedBox(height: 8),
                if (s.difficult.isEmpty)
                  Text('Belum ada. Kata muncul di sini setelah 2 kali belum tepat.', style: AppText.bodyGuardian.copyWith(color: p.subInk)),
                for (final w in s.difficult)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: AppSpace.tapGuardian,
                    title: Text(w.text, style: AppText.bodyStrong),
                    subtitle: stat[w.id] == null ? null : Text('${stat[w.id]!.tries} percobaan', style: AppText.caption),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: stat[w.id] == null ? null : () => showWordDetail(context, ref, stat[w.id]!),
                  ),
              ],
            ),
          );
          const navItems = [
            ('Riwayat sesi', Icons.history_rounded, '/guardian/history'),
            ('Semua kata', Icons.list_alt_rounded, '/guardian/words'),
            ('Pengaturan belajar', Icons.tune_rounded, '/guardian/learning'),
            ('Tampilan dan aksesibilitas', Icons.accessibility_new_rounded, '/guardian/access'),
            ('Akun dan sinkron', Icons.sync_rounded, '/guardian/account'),
            ('Data, laporan, dan profil', Icons.folder_outlined, '/guardian/data'),
          ];
          final nav = Panel(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (final (i, (label, icon, path)) in navItems.indexed) ...[
                  if (i > 0) const Divider(indent: 56),
                  _NavRow(label: label, icon: icon, path: path),
                ],
              ],
            ),
          );
          if (WindowSize.of(context).isWide) {
            return PaneList(
              maxWidth: 1200,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: Column(children: [stats, const SizedBox(height: 12), trend, const SizedBox(height: 12), difficult])),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: Column(children: [compare, const SizedBox(height: 12), nav])),
                  ],
                ),
              ],
            );
          }
          return PaneList(
            maxWidth: 760,
            children: [
              stats,
              const SizedBox(height: 12),
              trend,
              const SizedBox(height: 12),
              compare,
              const SizedBox(height: 12),
              difficult,
              const SizedBox(height: 12),
              nav,
            ],
          );
        },
      ),
    );
  }
}

/// Label dan nilai. Di kartu sempit nilai turun ke bawah label, supaya tidak ada yang terlipat di tengah.
class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, c) {
          final labelText = Text(label, style: AppText.bodyGuardian.copyWith(color: Pal.of(context).subInk));
          final valueText = Text(value, style: AppText.bodyStrong);
          if (c.maxWidth < 520) {
            return SizedBox(
              width: double.infinity,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [labelText, const SizedBox(height: 2), valueText]),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: labelText), const SizedBox(width: 16), valueText],
          );
        },
      );
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.label, required this.icon, required this.path});

  final String label;
  final IconData icon;
  final String path;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: AppSpace.tapChild,
    leading: Icon(icon),
    title: Text(label, style: AppText.bodyGuardian),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: () => context.push(path),
  );
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    Widget key(Color c, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 10,
          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: AppText.caption)),
      ],
    );
    return Wrap(spacing: 14, runSpacing: 4, children: [key(p.ok, 'Benar sendiri'), key(Thread.kunyit, 'Dibantu')]);
  }
}

/// Batang berlapis per hari dengan skala tetap dari puncak periode.
class TrendBars extends StatelessWidget {
  const TrendBars({super.key, required this.bars});

  final List<DayBar> bars;
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final peak = bars.fold<int>(0, (m, b) => b.alone + b.helped > m ? b.alone + b.helped : m);
    final total = bars.fold<int>(0, (m, b) => m + b.alone + b.helped);
    final dense = bars.length > 7;
    // Skala tetap: paling sedikit 10 kata, naik per 5, supaya minggu sepi tidak tampak setinggi minggu ramai.
    final ceiling = peak <= 10 ? 10 : ((peak + 4) ~/ 5) * 5;
    const plot = 96.0;
    return Semantics(
      label: '${bars.length} hari terakhir: $total kata selesai',
      excludeSemantics: true,
      child: SizedBox(
        height: 140,
        child: total == 0
            ? Center(
                child: Text('Belum ada latihan ${bars.length} hari terakhir.', style: AppText.bodyGuardian.copyWith(color: p.subInk)),
              )
            : Stack(
                children: [
                  for (final (value, y) in [(ceiling, 0.0), (ceiling ~/ 2, plot / 2)])
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 140 - 24 - plot + y - 8,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text('$value', style: AppText.caption.copyWith(fontSize: 12, color: p.subInk)),
                          ),
                          Expanded(child: Container(height: 1, color: p.line)),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final (i, b) in bars.indexed)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: dense ? 1.5 : 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (b.helped > 0)
                                    Container(
                                      height: plot * b.helped / ceiling,
                                      decoration: const BoxDecoration(
                                        color: Thread.kunyit,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                                      ),
                                    ),
                                  if (b.alone > 0)
                                    Container(
                                      height: plot * b.alone / ceiling,
                                      decoration: BoxDecoration(
                                        color: p.ok,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(b.helped > 0 ? 0 : 3)),
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 18,
                                    child: !dense
                                        ? Text(_days[b.day.weekday - 1], style: AppText.caption, softWrap: false, overflow: TextOverflow.visible)
                                        : (i % 7 == bars.length % 7 || i == bars.length - 1)
                                        ? Text(
                                            '${b.day.day}',
                                            style: AppText.caption.copyWith(fontSize: 12),
                                            softWrap: false,
                                            overflow: TextOverflow.visible,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
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

class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat sesi')),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: MessageState(title: 'Riwayat belum bisa dimuat')),
        data: (list) => list.isEmpty
            ? const Center(
                child: MessageState(title: 'Belum ada sesi', body: 'Riwayat muncul setelah anak mulai berlatih.', motif: Motif.lurik),
              )
            : PaneList(
                maxWidth: 760,
                children: [
                  for (final s in list) ...[_SessionTile(session: s), const SizedBox(height: 8)],
                ],
              ),
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session});

  final PracticeSession session;

  static String kindLabel(String kind) => switch (kind) {
    'letters' => 'Beda Huruf',
    'build' => 'Susun Kata',
    'listen' => 'Dengar dan Pilih',
    _ => 'Baca Kata',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Pal.of(context);
    final t = session.startedAt;
    final status = session.endedAt == null ? 'belum selesai' : 'level ${session.startLevel} ke ${session.endLevel ?? session.startLevel}';
    return Material(
      color: p.surface,
      borderRadius: BorderRadius.circular(AppSpace.tileRadius),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        leading: Container(
          width: 8,
          height: 36,
          decoration: BoxDecoration(color: Thread.forKind(session.kind), borderRadius: BorderRadius.circular(2)),
        ),
        title: Text('${kindLabel(session.kind)}, ${t.day}/${t.month}/${t.year}', style: AppText.bodyStrong),
        subtitle: Text(status, style: AppText.caption.copyWith(color: p.subInk)),
        children: [
          StreamBuilder<List<Attempt>>(
            stream: ref.watch(repositoryProvider).watchSessionAttempts(session.id),
            builder: (context, snap) {
              final attempts = snap.data ?? const <Attempt>[];
              if (attempts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Belum ada percobaan.', style: AppText.bodyGuardian),
                );
              }
              final content = ref.read(contentProvider);
              String name(String id) =>
                  content.wordById(id)?.text ?? content.letters.where((q) => q.id == id).map((q) => 'Huruf ${q.target}').firstOrNull ?? id;
              return Column(
                children: [
                  for (final a in attempts)
                    ListTile(
                      dense: true,
                      title: Text(name(a.wordId), style: AppText.bodyGuardian),
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

/// Semua kata yang pernah dilatih di Baca Kata, dengan angka dari log percobaan.
class WordStatsScreen extends ConsumerWidget {
  const WordStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attempts = ref.watch(attemptsProvider).value ?? const [];
    final s = ChildSummary(attempts, ref.watch(sessionsProvider).value ?? const [], ref.watch(contentProvider), DateTime.now());
    final stats = wordStats(s.wordAttempts, ref.watch(contentProvider));
    final p = Pal.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Semua kata')),
      body: stats.isEmpty
          ? const Center(
              child: MessageState(title: 'Belum ada kata', body: 'Daftar muncul setelah anak berlatih Baca Kata.', motif: Motif.ceplok),
            )
          : PaneList(
              maxWidth: 760,
              children: [
                Text('Diurutkan dari yang paling sering dilatih. Sentuh kata untuk detail.', style: AppText.bodyGuardian.copyWith(color: p.subInk)),
                const SizedBox(height: 12),
                Panel(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      for (final (i, w) in stats.indexed) ...[
                        if (i > 0) const Divider(indent: 16, endIndent: 16),
                        ListTile(
                          minTileHeight: AppSpace.tapChild,
                          title: Text(w.word.text, style: AppText.bodyStrong),
                          subtitle: Text(
                            '${w.tries} percobaan · benar sendiri ${w.alone} dari ${w.counted}',
                            style: AppText.caption.copyWith(color: p.subInk),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => showWordDetail(context, ref, w),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
