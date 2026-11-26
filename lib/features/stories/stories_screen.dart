import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../content/content.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/scenes.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';

class StoriesScreen extends ConsumerStatefulWidget {
  const StoriesScreen({super.key});

  @override
  ConsumerState<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesScreen> {
  int? _level;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(contentProvider).stories;
    final progress = ref.watch(storyProgressProvider).value ?? const [];
    final levels = all.map((s) => s.level).toSet().toList()..sort();
    final stories = _level == null ? all : all.where((s) => s.level == _level).toList();
    final done = progress.where((p) => p.completedAt != null).length;
    return SafeArea(
      child: PaneList(
        children: [
          Text('Mau baca apa?', style: AppText.title),
          const SizedBox(height: 4),
          Text(
            done == 0 ? '${all.length} cerita menunggumu.' : '$done dari ${all.length} cerita sudah selesai kamu baca.',
            style: AppText.caption.copyWith(color: Pal.of(context).subInk),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _LevelChip(label: 'Semua', selected: _level == null, onTap: () => setState(() => _level = null)),
              for (final l in levels) _LevelChip(label: 'Level $l', selected: _level == l, onTap: () => setState(() => _level = l)),
            ],
          ),
          const SizedBox(height: 16),
          FlowColumns(
            minItemWidth: 260,
            gap: 14,
            children: [
              for (final story in stories)
                () {
                  final state = progress.where((p) => p.storyId == story.id).firstOrNull;
                  return _StoryCover(story: story, completed: state?.completedAt != null, page: state?.page ?? 0);
                }(),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: AppText.label.copyWith(color: selected ? Thread.onThread : p.ink),
      selectedColor: Thread.kesumba,
      backgroundColor: p.surface,
      side: BorderSide(color: selected ? Colors.transparent : p.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }
}

class _StoryCover extends StatelessWidget {
  const _StoryCover({required this.story, required this.completed, required this.page});

  final Story story;
  final bool completed;
  final int page;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final status = completed ? 'Sudah selesai' : (page > 0 ? 'Lanjut halaman ${page + 1}' : '${story.pages.length} halaman');
    final read = completed ? story.pages.length : page;
    return Panel(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/story/${story.id}'),
      semanticLabel: '${story.title}, level ${story.level}, $status',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(aspectRatio: 16 / 10, child: SceneArt(scene: sceneForStory(story.id))),
          Selvedge(lead: Thread.named(story.color), height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title, style: AppText.heading),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(completed ? Icons.check_circle_rounded : Icons.menu_book_rounded, size: 18, color: completed ? p.ok : p.subInk),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Level ${story.level} · $status', style: AppText.caption.copyWith(color: p.subInk))),
                  ],
                ),
                const SizedBox(height: 12),
                ThreadSlots(total: story.pages.length, filled: read, color: Thread.daun, height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoryReaderScreen extends ConsumerStatefulWidget {
  const StoryReaderScreen({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends ConsumerState<StoryReaderScreen> {
  int _page = 0;
  int _line = 0;
  bool _syllables = true;
  bool _done = false;

  /// Kata yang sedang dibacakan, untuk sorotan karaoke.
  int? _spoken;
  bool _reading = false;

  Story get _story => ref.read(contentProvider).stories.firstWhere((s) => s.id == widget.storyId);

  late final Speaker _speaker = ref.read(speakerProvider);

  @override
  void initState() {
    super.initState();
    _speaker;
    _restore();
  }

  @override
  void dispose() {
    _speaker.stop();
    super.dispose();
  }

  Future<void> _restore() async {
    final child = ref.read(activeChildProvider);
    if (child == null) return;
    final all = await ref.read(repositoryProvider).watchStoryProgress(child.id).first;
    final saved = all.where((p) => p.storyId == widget.storyId).firstOrNull;
    if (saved != null && saved.completedAt == null && mounted) {
      setState(() => _page = saved.page.clamp(0, _story.pages.length - 1));
    }
  }

  Future<void> _go(int delta) async {
    final child = ref.read(activeChildProvider)!;
    final repo = ref.read(repositoryProvider);
    final next = _page + delta;
    _stopReading();
    if (next >= _story.pages.length) {
      await repo.saveStoryPage(child.id, _story.id, _page, completed: true);
      HapticFeedback.mediumImpact();
      if (mounted) setState(() => _done = true);
      return;
    }
    if (next < 0) return;
    await repo.saveStoryPage(child.id, _story.id, next);
    if (mounted) {
      setState(() {
        _page = next;
        _line = 0;
      });
    }
  }

  double get _rate => ref.read(activeChildProvider)?.settings.speechRate ?? 0.4;

  void _stopReading() {
    _speaker.stop();
    if (mounted) {
      setState(() {
        _reading = false;
        _spoken = null;
      });
    }
  }

  Future<void> _readAloud() async {
    if (_reading) return _stopReading();
    final text = _story.pages[_page].text;
    setState(() {
      _reading = true;
      _spoken = 0;
    });
    await _speaker.speak(text, rate: _rate, onWord: (start, _) {
      if (!mounted) return;
      final index = RegExp(r'\S+').allMatches(text.substring(0, start.clamp(0, text.length))).length;
      setState(() => _spoken = index);
    });
    if (mounted) {
      setState(() {
        _reading = false;
        _spoken = null;
      });
    }
  }

  void _sayWord(int index) {
    final words = _story.pages[_page].text.split(RegExp(r'\s+'));
    if (index >= words.length) return;
    final clean = words[index].replaceAll(RegExp(r'[^\p{L}\-]', unicode: true), '');
    setState(() => _spoken = index);
    _speaker.speak(clean.toLowerCase(), rate: _rate).then((_) {
      if (mounted && !_reading) setState(() => _spoken = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final story = ref.watch(contentProvider).stories.where((s) => s.id == widget.storyId).firstOrNull;
    final child = ref.watch(activeChildProvider);
    if (story == null || child == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: MessageState(title: 'Cerita tidak ditemukan', motif: Motif.kawung)));
    }
    if (_done) return _StoryDone(story: story);

    final p = Pal.of(context);
    final settings = child.settings;
    final tint = ReadingTint.values.where((t) => t.name == settings.tint).firstOrNull ?? ReadingTint.none;
    final page = story.pages[_page];
    final last = _page + 1 >= story.pages.length;
    final wide = WindowSize.of(context).isWide || isShortLandscape(context);
    final g = gutterFor(context);

    final art = Stack(
      fit: StackFit.expand,
      children: [
        SceneArt(scene: sceneForStory(story.id)),
        SafeArea(
          bottom: false,
          right: !wide,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.topLeft,
              child: RoundButton(icon: Icons.arrow_back_rounded, label: 'Kembali', size: AppSpace.tapChild, onPressed: () => context.pop()),
            ),
          ),
        ),
      ],
    );

    final reading = Container(
      width: double.infinity,
      decoration: BoxDecoration(color: tint.of(Theme.of(context).brightness) ?? p.surface, borderRadius: BorderRadius.circular(AppSpace.panelRadius)),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      child: _ReadingText(
        text: _syllables ? page.syllables : page.text,
        ruler: settings.ruler,
        activeLine: _line,
        spoken: _spoken,
        spacing: settings.letterSpacing,
        onLine: (i) => setState(() => _line = i),
        onWord: _sayWord,
      ),
    );

    List<Widget> parts(bool scroll) => [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: AppText.heading),
                  Text('Halaman ${_page + 1} dari ${story.pages.length}', style: AppText.caption.copyWith(color: p.subInk)),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: _readAloud,
              icon: Icon(_reading ? Icons.stop_rounded : Icons.volume_up_rounded),
              label: Text(_reading ? 'Berhenti' : 'Bacakan'),
              style: FilledButton.styleFrom(minimumSize: const Size(0, AppSpace.tapGuardian), padding: const EdgeInsets.symmetric(horizontal: 16)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ThreadSlots(total: story.pages.length, filled: _page + 1, color: Thread.daun, height: 8, active: _page),
        const SizedBox(height: 14),
        if (scroll) reading else Expanded(child: SingleChildScrollView(child: reading)),
        const SizedBox(height: 12),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Suku kata')),
            ButtonSegment(value: false, label: Text('Kata utuh')),
          ],
          selected: {_syllables},
          showSelectedIcon: false,
          onSelectionChanged: (v) => setState(() {
            _syllables = v.first;
            _line = 0;
          }),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (_page > 0) ...[
              RoundButton(icon: Icons.arrow_back_rounded, label: 'Halaman sebelumnya', size: AppSpace.tapChild, onPressed: () => _go(-1)),
              const SizedBox(width: 10),
            ],
            Expanded(child: PrimaryAction(label: last ? 'Selesai' : 'Halaman berikutnya', onPressed: () => _go(1))),
          ],
        ),
      ];

    final body = LayoutBuilder(
      builder: (context, c) => c.maxHeight < 560
          ? ListView(padding: EdgeInsets.zero, children: parts(true))
          : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: parts(false)),
    );

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(flex: 5, child: art),
            Expanded(
              flex: 6,
              child: SafeArea(
                left: false,
                child: Padding(padding: EdgeInsets.all(g), child: Pane(maxWidth: AppSpace.readingWidth, child: body)),
              ),
            ),
          ],
        ),
      );
    }
    final artHeight = (MediaQuery.sizeOf(context).height * 0.26).clamp(150.0, 260.0);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: artHeight, child: art),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(padding: EdgeInsets.fromLTRB(g, 16, g, g), child: body),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryDone extends StatelessWidget {
  const _StoryDone({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: PaneList(
            maxWidth: 640,
            children: [
              Panel(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(aspectRatio: 16 / 10, child: SceneArt(scene: sceneForStory(story.id))),
                    const Selvedge(lead: Thread.daun),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ceritanya selesai', style: AppText.title),
                          const SizedBox(height: 6),
                          Text('"${story.title}" masuk ke Koleksi.', style: AppText.body),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryAction(label: 'Pilih cerita lain', onPressed: () => context.pop()),
            ],
          ),
        ),
      );
}

/// Teks bacaan per kata. Kata bisa disentuh untuk didengar, dan kata yang dibacakan disorot kesumba.
/// Dengan penggaris aktif, satu baris menyala dan baris lain mundur.
class _ReadingText extends StatelessWidget {
  const _ReadingText({
    required this.text,
    required this.ruler,
    required this.activeLine,
    required this.spoken,
    required this.spacing,
    required this.onLine,
    required this.onWord,
  });

  final String text;
  final bool ruler;
  final int activeLine;
  final int? spoken;
  final double spacing;
  final ValueChanged<int> onLine;
  final ValueChanged<int> onWord;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final style = AppText.reading.copyWith(letterSpacing: AppText.reading.letterSpacing! + spacing, wordSpacing: spacing * 2);
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    Widget word(int i, Color color) => GestureDetector(
          onTap: () => onWord(i),
          child: AnimatedContainer(
            duration: motionReduced(context) ? Duration.zero : AppMotion.quick,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(color: i == spoken ? Thread.kesumba : Colors.transparent, borderRadius: BorderRadius.circular(6)),
            child: Text('${words[i]} ', style: style.copyWith(color: i == spoken ? Thread.onThread : color)),
          ),
        );

    return Semantics(
      label: text.replaceAll('-', ''),
      excludeSemantics: true,
      child: !ruler
          ? Wrap(children: [for (var i = 0; i < words.length; i++) word(i, p.ink)])
          : LayoutBuilder(builder: (context, constraints) {
              final lines = _breakLines(words, style, constraints.maxWidth - 16, MediaQuery.textScalerOf(context));
              var start = 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var l = 0; l < lines.length; l++)
                    () {
                      final from = start;
                      start += lines[l];
                      final on = l == activeLine;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onLine(l),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: on ? Thread.kunyit.withValues(alpha: 0.35) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Wrap(children: [for (var i = from; i < from + lines[l]; i++) word(i, on ? p.ink : p.subInk)]),
                        ),
                      );
                    }(),
                ],
              );
            }),
    );
  }

  /// Jumlah kata per baris, diukur dengan gaya yang sama.
  List<int> _breakLines(List<String> words, TextStyle style, double width, TextScaler scaler) {
    final counts = <int>[];
    var current = 0;
    var used = 0.0;
    for (final w in words) {
      final painter = TextPainter(text: TextSpan(text: '$w ', style: style), textDirection: TextDirection.ltr, textScaler: scaler)..layout();
      final wWidth = painter.width + 4;
      painter.dispose();
      if (current > 0 && used + wWidth > width) {
        counts.add(current);
        current = 0;
        used = 0;
      }
      current++;
      used += wWidth;
    }
    if (current > 0) counts.add(current);
    return counts;
  }
}
