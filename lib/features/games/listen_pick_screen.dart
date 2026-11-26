import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';
import '../../domain/practice/models.dart';
import '../practice/session_screen.dart' show ChoiceButton;
import 'game_frame.dart';

/// Dengar dan Pilih: kata diucapkan, anak memilih satu dari tiga. Bisa dipakai tanpa mikrofon.
class ListenPickScreen extends ConsumerStatefulWidget {
  const ListenPickScreen({super.key, this.random});

  final Random? random;

  @override
  ConsumerState<ListenPickScreen> createState() => _ListenPickScreenState();
}

class _ListenPickScreenState extends ConsumerState<ListenPickScreen> {
  static const rounds = 6;
  late final Random _random = widget.random ?? Random();
  late final Speaker _speaker = ref.read(speakerProvider);
  String? _sessionId;
  int _level = 1;
  int _index = 0;
  final Set<String> _used = {};
  Word? _word;
  List<Word> _choices = const [];
  final Set<String> _wrong = {};
  bool _solved = false;
  int _tries = 0;

  @override
  void initState() {
    super.initState();
    _speaker;
    _start();
  }

  @override
  void dispose() {
    _speaker.stop();
    super.dispose();
  }

  Future<void> _start() async {
    final child = ref.read(activeChildProvider)!;
    final repo = ref.read(repositoryProvider);
    _level = await repo.currentLevel(child.id);
    final id = await repo.startSession(childId: child.id, kind: 'listen', level: _level, planned: rounds);
    if (!mounted) return;
    setState(() => _sessionId = id);
    _prepare();
  }

  void _prepare() {
    final content = ref.read(contentProvider);
    final word = content.pickWord(_level, _used, random: _random);
    _used.add(word.id);
    setState(() {
      _word = word;
      _choices = content.choicesFor(word, random: _random);
      _wrong.clear();
      _solved = false;
      _tries = 0;
    });
    _hear();
  }

  void _hear() => _speaker.speak(_word!.text.toLowerCase(), rate: ref.read(activeChildProvider)?.settings.speechRate ?? 0.4);

  Future<void> _pick(Word w) async {
    if (_solved || _wrong.contains(w.id)) return;
    final right = w.id == _word!.id;
    final tries = _tries + 1;
    final finished = right || tries >= 2;
    right ? HapticFeedback.selectionClick() : HapticFeedback.lightImpact();
    setState(() {
      _tries = tries;
      if (!right) _wrong.add(w.id);
      if (finished) _solved = true;
    });
    if (finished) _hear();
    final child = ref.read(activeChildProvider)!;
    await ref.read(repositoryProvider).saveAttempt(
          sessionId: _sessionId!,
          childId: child.id,
          wordId: _word!.id,
          contentVersion: ref.read(contentProvider).version,
          tryNumber: tries,
          status: right ? AttemptStatus.correct : AttemptStatus.wrong,
          matched: right ? List.generate(_word!.syllables.length, (i) => i) : const [],
          finished: finished,
          assisted: !right && finished,
          guardianOverride: false,
          engine: 'choice',
        );
  }

  Future<void> _next() async {
    if (_index + 1 >= rounds) {
      final child = ref.read(activeChildProvider)!;
      final repo = ref.read(repositoryProvider);
      await repo.finishSession(id: _sessionId!, childId: child.id, endLevel: await repo.currentLevel(child.id));
      if (mounted) setState(() => _index = rounds);
      return;
    }
    setState(() => _index++);
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionId == null || _word == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_index >= rounds) {
      return GameDone(
        color: Thread.laut,
        total: rounds,
        title: 'Telingamu jeli',
        line: 'Kamu mendengarkan $rounds kata sampai selesai.',
        onAgain: () => context.pushReplacement('/listen'),
      );
    }
    final p = Pal.of(context);
    final word = _word!;

    final stage = GameField(
      color: _solved ? Thread.daun : Thread.laut,
      child: Column(
        children: [
          Semantics(
            button: true,
            label: 'Dengarkan kata',
            excludeSemantics: true,
            child: Material(
              color: Thread.tarum,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: _hear,
                child: const SizedBox(width: 112, height: 112, child: Icon(Icons.volume_up_rounded, size: 52, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _solved ? word.text : 'Sentuh untuk mendengar lagi',
            style: _solved ? AppText.wordHero.copyWith(color: Thread.onThread, fontSize: 56) : AppText.bodyStrong.copyWith(color: Thread.onThread),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Mana kata yang kamu dengar?', style: AppText.bodyStrong, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        for (final w in _choices)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ChoiceButton(
              text: w.text,
              onTap: _solved ? null : () => _pick(w),
              state: _solved && w.id == word.id ? TileState.correct : (_wrong.contains(w.id) ? TileState.retry : TileState.idle),
            ),
          ),
        const SizedBox(height: 4),
        if (_solved) ...[
          StatusLine(
            icon: _tries == 1 ? Icons.check_circle_rounded : Icons.volume_up_rounded,
            color: _tries == 1 ? p.ok : p.ink,
            text: _tries == 1 ? 'Tepat sekali.' : 'Ini katanya. Dengarkan sekali lagi.',
          ),
          const SizedBox(height: 12),
          PrimaryAction(label: _index + 1 >= rounds ? 'Selesai' : 'Kata berikutnya', onPressed: _next),
        ] else if (_wrong.isNotEmpty)
          StatusLine(icon: Icons.hearing_rounded, color: p.retry, text: 'Dengarkan lagi, lalu pilih yang lain.'),
      ],
    );

    return GameFrame(color: Thread.laut, total: rounds, done: _index + (_solved ? 1 : 0), position: _index + 1, stage: stage, controls: controls);
  }
}
