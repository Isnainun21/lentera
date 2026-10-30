import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../content/content.dart';
import '../../core/design/components.dart';
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.gutter, AppSpace.gutter, AppSpace.gutter, 14),
            child: Text('Mau baca apa?', style: AppText.title),
          ),
          SizedBox(
            height: AppSpace.tapGuardian,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.gutter),
              children: [
                _LevelChip(label: 'Semua', selected: _level == null, onTap: () => setState(() => _level = null)),
                for (final l in levels) _LevelChip(label: 'Level $l', selected: _level == l, onTap: () => setState(() => _level = l)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.86),
              padEnds: false,
              itemCount: stories.length,
              itemBuilder: (_, i) {
                final story = stories[i];
                final state = progress.where((p) => p.storyId == story.id).firstOrNull;
                return Padding(
                  padding: EdgeInsets.fromLTRB(i == 0 ? AppSpace.gutter : 6, 0, 6, AppSpace.gutter),
                  child: _StoryCover(story: story, completed: state?.completedAt != null, page: state?.page ?? 0),
                );
              },
            ),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Semantics(
          button: true,
          selected: selected,
          child: Material(
            color: selected ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: Text(label, style: AppText.bodyGuardian.copyWith(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ),
      );
}

class _StoryCover extends StatelessWidget {
  const _StoryCover({required this.story, required this.completed, required this.page});

  final Story story;
  final bool completed;
  final int page;

  @override
  Widget build(BuildContext context) {
    final status = completed ? 'Sudah selesai' : (page > 0 ? 'Lanjut halaman ${page + 1}' : '${story.pages.length} halaman');
    return Semantics(
      button: true,
      label: '${story.title}, $status',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => context.push('/story/${story.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpace.cardRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SceneArt(scene: sceneForStory(story.id)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story.title, style: AppText.heading.copyWith(color: Colors.white)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(completed ? Icons.check_circle_rounded : Icons.menu_book_rounded, size: 18, color: AppColors.lantern),
                          const SizedBox(width: 6),
                          Expanded(child: Text(status, style: AppText.bodyGuardian.copyWith(color: const Color(0xFFE6EEF0)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
    _speaker.stop();
    if (next >= _story.pages.length) {
      await repo.saveStoryPage(child.id, _story.id, _page, completed: true);
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

  void _readAloud() {
    final rate = ref.read(activeChildProvider)?.settings.speechRate ?? 0.4;
    _speaker.speak(_story.pages[_page].text, rate: rate);
  }

  @override
  Widget build(BuildContext context) {
    final story = ref.watch(contentProvider).stories.where((s) => s.id == widget.storyId).firstOrNull;
    final child = ref.watch(activeChildProvider);
    if (story == null || child == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: MessageState(title: 'Cerita tidak ditemukan')));
    }
    if (_done) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.gutter),
            child: Column(
              children: [
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpace.cardRadius),
                  child: SizedBox(height: 280, width: double.infinity, child: SceneArt(scene: sceneForStory(story.id))),
                ),
                const SizedBox(height: 28),
                Text('Ceritanya selesai', style: AppText.title, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('"${story.title}" masuk ke Koleksi.', style: AppText.body, textAlign: TextAlign.center),
                const Spacer(),
                PrimaryAction(label: 'Pilih cerita lain', onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      );
    }
    final page = story.pages[_page];
    final last = _page + 1 >= story.pages.length;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 230,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SceneArt(scene: sceneForStory(story.id)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundButton(icon: Icons.arrow_back_rounded, label: 'Kembali', onPressed: () => context.pop()),
                          RoundButton(icon: Icons.volume_up_rounded, label: 'Bacakan halaman', onPressed: _readAloud, color: AppColors.ink, foreground: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(story.title, style: AppText.heading),
                    Text('Halaman ${_page + 1} dari ${story.pages.length}', style: AppText.caption),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _ReadingText(
                          text: _syllables ? page.syllables : page.text,
                          ruler: child.settings.ruler,
                          activeLine: _line,
                          onLine: (i) => setState(() => _line = i),
                        ),
                      ),
                    ),
                    SwitchListTile(
                      value: _syllables,
                      onChanged: (v) => setState(() {
                        _syllables = v;
                        _line = 0;
                      }),
                      title: Text('Pisah suku kata', style: AppText.bodyGuardian),
                      contentPadding: EdgeInsets.zero,
                    ),
                    Row(
                      children: [
                        if (_page > 0) ...[
                          RoundButton(icon: Icons.arrow_back_rounded, label: 'Halaman sebelumnya', onPressed: () => _go(-1)),
                          const SizedBox(width: 10),
                        ],
                        Expanded(child: PrimaryAction(label: last ? 'Selesai' : 'Halaman berikutnya', onPressed: () => _go(1))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Teks per baris. Dengan penggaris aktif, satu baris menyala dan baris lain mundur.
class _ReadingText extends StatelessWidget {
  const _ReadingText({required this.text, required this.ruler, required this.activeLine, required this.onLine});

  final String text;
  final bool ruler;
  final int activeLine;
  final ValueChanged<int> onLine;

  @override
  Widget build(BuildContext context) {
    if (!ruler) return Text(text, style: AppText.reading);
    return LayoutBuilder(builder: (context, constraints) {
      final lines = _breakLines(text, constraints.maxWidth - 16, MediaQuery.textScalerOf(context));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++)
            Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onLine(i),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: i == activeLine ? AppColors.lanternSoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    lines[i],
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: AppText.reading.copyWith(color: i == activeLine ? AppColors.ink : AppColors.subInk),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  List<String> _breakLines(String text, double width, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: AppText.reading),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout(maxWidth: width);
    final lines = <String>[];
    var offset = 0;
    while (offset < text.length) {
      final range = painter.getLineBoundary(TextPosition(offset: offset));
      if (range.end <= offset) break;
      final line = text.substring(range.start, range.end).trim();
      if (line.isNotEmpty) lines.add(line);
      offset = range.end;
    }
    painter.dispose();
    return lines;
  }
}
