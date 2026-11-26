import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../content/content.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';
import '../../domain/practice/models.dart';
import '../games/game_frame.dart';

class LettersScreen extends ConsumerStatefulWidget {
  const LettersScreen({super.key, this.random});

  final Random? random;

  @override
  ConsumerState<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends ConsumerState<LettersScreen> {
  static const rounds = 6;
  late final Speaker _speaker = ref.read(speakerProvider);
  List<LetterQuestion> _questions = const [];
  int _index = 0;
  final _selected = <int>{};
  bool? _correct;
  int _tries = 0;
  String? _sessionId;

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
    final all = [...ref.read(contentProvider).letters]..shuffle(widget.random ?? Random());
    final questions = all.take(rounds).toList();
    final id = await repo.startSession(
      childId: child.id,
      kind: 'letters',
      level: await repo.currentLevel(child.id),
      planned: questions.length,
    );
    if (mounted) {
      setState(() {
        _questions = questions;
        _sessionId = id;
      });
    }
  }

  void _say(String letter) => _speaker.speak('huruf $letter', rate: ref.read(activeChildProvider)?.settings.speechRate ?? 0.4);

  Future<void> _check() async {
    final child = ref.read(activeChildProvider)!;
    final content = ref.read(contentProvider);
    final q = _questions[_index];
    final right = _selected.length == q.answers.length && _selected.every(q.answers.contains);
    final tries = _tries + 1;
    right ? HapticFeedback.selectionClick() : HapticFeedback.lightImpact();
    setState(() {
      _correct = right;
      _tries = tries;
    });
    await ref.read(repositoryProvider).saveAttempt(
          sessionId: _sessionId!,
          childId: child.id,
          wordId: q.id,
          contentVersion: content.version,
          tryNumber: tries,
          status: right ? AttemptStatus.correct : AttemptStatus.wrong,
          matched: _selected.toList(),
          finished: right || tries >= 2,
          assisted: !right && tries >= 2,
          guardianOverride: false,
          engine: 'tap',
        );
  }

  Future<void> _next() async {
    final done = _correct == true || _tries >= 2;
    if (!done) {
      setState(() {
        _correct = null;
        _selected.clear();
      });
      return;
    }
    if (_index + 1 >= _questions.length) {
      final child = ref.read(activeChildProvider)!;
      final repo = ref.read(repositoryProvider);
      await repo.finishSession(id: _sessionId!, childId: child.id, endLevel: await repo.currentLevel(child.id));
      if (mounted) setState(() => _index = _questions.length);
      return;
    }
    setState(() {
      _index++;
      _selected.clear();
      _correct = null;
      _tries = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = ref.watch(activeChildProvider);
    if (_sessionId == null || child == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_index >= _questions.length) {
      return GameDone(
        color: Thread.tarumMuda,
        total: _questions.length,
        title: 'Latihan huruf selesai',
        line: 'Matamu makin jeli membedakan huruf.',
        onAgain: () => context.pushReplacement('/letters'),
      );
    }
    final p = Pal.of(context);
    final q = _questions[_index];
    final reveal = _correct != null;
    final finished = _correct == true || _tries >= 2;
    final colors = child.settings.letterColors;

    final stage = GameField(
      color: Thread.tarumMuda,
      minHeight: 200,
      child: Column(
        children: [
          Text('Sentuh semua huruf', style: AppText.bodyStrong.copyWith(color: Thread.onThread)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(q.target, style: AppText.wordHero.copyWith(color: Thread.onThread, fontSize: 112)))),
              const SizedBox(width: 12),
              IconButton.filled(
                tooltip: 'Dengarkan huruf ${q.target}',
                onPressed: () => _say(q.target),
                icon: const Icon(Icons.volume_up_rounded),
                style: IconButton.styleFrom(backgroundColor: Thread.tarum, foregroundColor: Colors.white, minimumSize: const Size(56, 56)),
              ),
            ],
          ),
        ],
      ),
    );

    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var i = 0; i < q.options.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _LetterOption(
                    letter: q.options[i],
                    selected: _selected.contains(i),
                    isAnswer: reveal && finished && q.answers.contains(i),
                    colors: colors,
                    onTap: reveal ? null : () => setState(() => _selected.contains(i) ? _selected.remove(i) : _selected.add(i)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (reveal) ...[
          StatusLine(
            icon: _correct! ? Icons.check_circle_rounded : Icons.visibility_outlined,
            color: _correct! ? p.ok : p.retry,
            text: _correct! ? 'Tepat. ${q.hint}' : 'Lihat lagi ya. ${q.hint}',
          ),
          const SizedBox(height: 12),
        ],
        PrimaryAction(
          label: reveal ? (finished ? 'Lanjut' : 'Coba lagi') : 'Periksa',
          onPressed: reveal ? _next : (_selected.isEmpty ? null : _check),
        ),
      ],
    );

    return GameFrame(
      color: Thread.tarumMuda,
      total: _questions.length,
      done: _index + (reveal && finished ? 1 : 0),
      position: _index + 1,
      stage: stage,
      controls: controls,
    );
  }
}

class _LetterOption extends StatelessWidget {
  const _LetterOption({required this.letter, required this.selected, required this.isAnswer, required this.colors, required this.onTap});

  final String letter;
  final bool selected;
  final bool isAnswer;
  final bool colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final bg = isAnswer ? p.okSoft : (selected ? Thread.kesumba : p.surface);
    return Semantics(
      button: true,
      selected: selected,
      label: 'Huruf $letter',
      excludeSemantics: true,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          onTap: onTap,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpace.tileRadius),
              border: Border.all(color: selected || isAnswer ? Colors.transparent : p.line, width: 1.5),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LetterMarkedText(
                  letter,
                  style: AppText.syllable.copyWith(fontSize: 44, color: selected && !isAnswer ? Thread.onThread : null),
                  markLetters: colors && !selected,
                ),
                if (selected || isAnswer)
                  Positioned(top: 6, right: 6, child: Icon(Icons.check_circle_rounded, size: 20, color: isAnswer ? p.ok : Thread.onThread)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
