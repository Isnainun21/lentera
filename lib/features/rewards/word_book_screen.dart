import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';
import '../../domain/practice/models.dart';

/// Kamus Kataku: semua kata yang pernah diselesaikan anak. Tidak ada tanda benar atau salah di sini.
class WordBookScreen extends ConsumerStatefulWidget {
  const WordBookScreen({super.key});

  @override
  ConsumerState<WordBookScreen> createState() => _WordBookScreenState();
}

class _WordBookScreenState extends ConsumerState<WordBookScreen> {
  late final Speaker _speaker = ref.read(speakerProvider);
  String? _playing;

  @override
  void initState() {
    super.initState();
    _speaker;
  }

  @override
  void dispose() {
    _speaker.stop();
    super.dispose();
  }

  Future<void> _play(Word w) async {
    setState(() => _playing = w.id);
    await _speaker.speak(w.text.toLowerCase(), rate: ref.read(activeChildProvider)?.settings.speechRate ?? 0.4);
    if (mounted && _playing == w.id) setState(() => _playing = null);
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(learnedWordsProvider);
    final letterColors = ref.watch(activeChildProvider)?.settings.letterColors ?? false;
    final p = Pal.of(context);
    final byLevel = <int, List<Word>>{};
    for (final w in words) {
      byLevel.putIfAbsent(w.level, () => []).add(w);
    }
    final levels = byLevel.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Kamus Kataku')),
      body: words.isEmpty
          ? Center(
              child: MessageState(
                title: 'Kamusmu masih kosong',
                body: 'Kata yang kamu baca, susun, atau dengar akan tersimpan di sini.',
                motif: Motif.ceplok,
                action: SizedBox(width: 260, child: PrimaryAction(label: 'Mulai Baca', onPressed: () => context.pushReplacement('/session'))),
              ),
            )
          : PaneList(
              children: [
                Text('${words.length} kata sudah kamu kenal. Sentuh kata untuk mendengarnya.', style: AppText.body.copyWith(color: p.subInk)),
                for (final level in levels) ...[
                  SectionTitle(switch (level) {
                    1 => 'Suku kata',
                    2 => 'Kata pendek',
                    _ => 'Kata level $level',
                  }),
                  FlowColumns(
                    minItemWidth: 160,
                    gap: 10,
                    maxColumns: 5,
                    children: [
                      for (final w in byLevel[level]!)
                        Panel(
                          color: _playing == w.id ? Thread.kesumba : null,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          onTap: () => _play(w),
                          semanticLabel: '${w.text.toLowerCase()}, sentuh untuk mendengar',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: LetterMarkedText(
                                        w.text,
                                        style: AppText.heading.copyWith(fontSize: 26, letterSpacing: 1, color: _playing == w.id ? Thread.onThread : null),
                                        markLetters: letterColors && _playing != w.id,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.volume_up_rounded, size: 20, color: _playing == w.id ? Thread.onThread : p.subInk),
                                ],
                              ),
                              if (w.syllables.length > 1)
                                Text(
                                  w.syllables.join(' · '),
                                  style: AppText.caption.copyWith(color: _playing == w.id ? Thread.onThread : p.subInk),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}
