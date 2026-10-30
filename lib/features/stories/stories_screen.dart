import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../content/content.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(contentProvider).stories;
    final progress = ref.watch(storyProgressProvider).value ?? const [];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpace.gutter),
            child: Text('Mau baca apa?', style: AppText.title),
          ),
          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.84),
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
      child: Material(
        color: AppColors.named(story.color),
        shape: const LanternShape(bottomRadius: AppSpace.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/story/${story.id}'),
          child: Column(
            children: [
              const Expanded(child: Center(child: Icon(Icons.menu_book_rounded, size: 72, color: AppColors.ink))),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(story.title, style: AppText.heading),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (completed) ...[
                          const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.ok),
                          const SizedBox(width: 4),
                        ],
                        Expanded(child: Text(status, style: AppText.bodyGuardian)),
                      ],
                    ),
                  ],
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
    ref.read(speakerProvider).stop();
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
    ref.read(speakerProvider).speak(_story.pages[_page].text, rate: rate);
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
                const SizedBox(width: 140, height: 180, child: LanternFrame(light: 1, height: 180, child: SizedBox.shrink())),
                const SizedBox(height: 24),
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
      appBar: AppBar(
        title: Text('Halaman ${_page + 1} dari ${story.pages.length}'),
        actions: [
          IconButton(
            tooltip: 'Bacakan halaman',
            onPressed: _readAloud,
            icon: const Icon(Icons.volume_up_rounded),
            style: IconButton.styleFrom(backgroundColor: AppColors.surface, minimumSize: const Size(48, 48)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.gutter),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CardBox(
                    padding: const EdgeInsets.all(24),
                    child: _ReadingText(
                      text: _syllables ? page.syllables : page.text,
                      ruler: child.settings.ruler,
                      activeLine: _line,
                      onLine: (i) => setState(() => _line = i),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _syllables,
                onChanged: (v) => setState(() {
                  _syllables = v;
                  _line = 0;
                }),
                title: Text('Pisah suku kata', style: AppText.bodyStrong),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (_page > 0) ...[
                    Expanded(child: QuietAction(label: 'Sebelumnya', onPressed: () => _go(-1))),
                    const SizedBox(width: 10),
                  ],
                  Expanded(flex: 2, child: PrimaryAction(label: last ? 'Selesai' : 'Halaman berikutnya', onPressed: () => _go(1))),
                ],
              ),
            ],
          ),
        ),
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
