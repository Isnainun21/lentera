import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../domain/practice/models.dart';

class LettersScreen extends ConsumerStatefulWidget {
  const LettersScreen({super.key});

  @override
  ConsumerState<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends ConsumerState<LettersScreen> {
  int _index = 0;
  final _selected = <int>{};
  bool? _correct;
  int _tries = 0;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final child = ref.read(activeChildProvider)!;
    final repo = ref.read(repositoryProvider);
    final id = await repo.startSession(
      childId: child.id,
      kind: 'letters',
      level: await repo.currentLevel(child.id),
      planned: ref.read(contentProvider).letters.length,
    );
    if (mounted) setState(() => _sessionId = id);
  }

  Future<void> _check() async {
    final child = ref.read(activeChildProvider)!;
    final content = ref.read(contentProvider);
    final q = content.letters[_index];
    final right = _selected.length == q.answers.length && _selected.every(q.answers.contains);
    final tries = _tries + 1;
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
    final content = ref.read(contentProvider);
    final done = _correct == true || _tries >= 2;
    if (!done) {
      setState(() {
        _correct = null;
        _selected.clear();
      });
      return;
    }
    if (_index + 1 >= content.letters.length) {
      final child = ref.read(activeChildProvider)!;
      final repo = ref.read(repositoryProvider);
      await repo.finishSession(id: _sessionId!, childId: child.id, endLevel: await repo.currentLevel(child.id));
      if (mounted) setState(() => _index = content.letters.length);
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
    final letters = ref.watch(contentProvider).letters;
    final child = ref.watch(activeChildProvider);
    if (_sessionId == null || child == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.ink)));
    }
    if (_index >= letters.length) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.gutter),
            child: Column(
              children: [
                const Spacer(),
                Text('Latihan huruf selesai', style: AppText.title, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Matamu makin jeli membedakan huruf.', style: AppText.body, textAlign: TextAlign.center),
                const Spacer(),
                PrimaryAction(label: 'Selesai', onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      );
    }
    final q = letters[_index];
    final reveal = _correct != null;
    final colors = child.settings.letterColors;
    return Scaffold(
      appBar: AppBar(title: Text('${_index + 1} dari ${letters.length}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Sentuh semua huruf', style: AppText.title),
              const SizedBox(height: 16),
              WordField(
                height: 190,
                color: AppColors.sky,
                child: Center(child: Text(q.target, style: AppText.wordHero.copyWith(fontSize: 104))),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  for (var i = 0; i < q.options.length; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _LetterOption(
                          letter: q.options[i],
                          selected: _selected.contains(i),
                          isAnswer: reveal && _correct == true && q.answers.contains(i),
                          colors: colors,
                          onTap: reveal
                              ? null
                              : () => setState(() => _selected.contains(i) ? _selected.remove(i) : _selected.add(i)),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (reveal)
                Semantics(
                  liveRegion: true,
                  child: Text(_correct! ? 'Tepat. ${q.hint}' : 'Lihat lagi ya. ${q.hint}', style: AppText.bodyStrong),
                ),
              const Spacer(),
              PrimaryAction(
                label: reveal ? (_correct! || _tries >= 2 ? 'Lanjut' : 'Coba lagi') : 'Periksa',
                onPressed: reveal ? _next : (_selected.isEmpty ? null : _check),
              ),
            ],
          ),
        ),
      ),
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
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        label: 'Huruf $letter',
        excludeSemantics: true,
        child: Material(
          color: isAnswer ? AppColors.okSoft : (selected ? AppColors.lantern : AppColors.surface),
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpace.tileRadius),
            onTap: onTap,
            child: SizedBox(
              height: 92,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LetterMarkedText(letter, style: AppText.syllable.copyWith(fontSize: 42), markLetters: colors),
                  if (selected || isAnswer)
                    const Positioned(top: 6, right: 6, child: Icon(Icons.check_circle_rounded, size: 20, color: AppColors.ink)),
                ],
              ),
            ),
          ),
        ),
      );
}
