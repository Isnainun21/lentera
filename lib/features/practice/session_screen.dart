import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';
import '../../domain/child.dart';
import '../../domain/practice/adaptive_engine.dart';
import '../../domain/practice/models.dart';
import '../../domain/practice/practice_session.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  late PracticeSession _machine;
  SessionState? _state;
  late ChildProfile _child;
  late String _sessionId;
  bool _useChoices = false;
  bool _failed = false;
  List<Word> _choices = const [];

  // Penulisan database dijalankan berurutan supaya urutan log tetap benar.
  Future<void> _writes = Future.value();

  late final Speaker _speaker = ref.read(speakerProvider);
  late final SpeechRecognizer _recognizer = ref.read(recognizerProvider);

  @override
  void initState() {
    super.initState();
    _speaker;
    _recognizer;
    _boot();
  }

  @override
  void dispose() {
    _speaker.stop();
    _recognizer.stop();
    super.dispose();
  }

  Future<void> _boot() async {
    try {
      final repo = ref.read(repositoryProvider);
      final content = ref.read(contentProvider);
      final child = ref.read(activeChildProvider)!;
      _child = child;
      final priority = ref.read(priorityWordsProvider);
      _machine = PracticeSession(
        picker: (level, used) => content.pickWord(level, used, priority: priority),
        engine: AdaptiveEngine(raiseAfter: child.settings.raiseAfter, lowerAfter: child.settings.lowerAfter),
      );

      final availability = await ref.read(recognizerProvider).prepare();
      _useChoices = availability != SpeechAvailability.ready;

      final level = await repo.currentLevel(child.id);
      final open = await repo.openSession(child.id, 'reading');
      final Transition t;
      if (open != null) {
        _sessionId = open.id;
        t = _machine.start(level: level, total: open.planned, alreadyDone: open.doneWords.length, used: open.doneWords);
      } else {
        final total = child.settings.wordsPerSession;
        _sessionId = await repo.startSession(childId: child.id, kind: 'reading', level: level, planned: total);
        t = _machine.start(level: level, total: total);
      }
      ref.read(priorityWordsProvider.notifier).clear();
      if (!mounted) return;
      _apply(t);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _dispatch(SessionEvent event) {
    final s = _state;
    if (s == null) return;
    _apply(_machine.reduce(s, event));
  }

  void _apply(Transition t) {
    final previous = _state;
    setState(() {
      _state = t.state;
      if (_useChoices && previous?.word.id != t.state.word.id) {
        _choices = ref.read(contentProvider).choicesFor(t.state.word);
      }
    });
    for (final effect in t.effects) {
      _run(effect);
    }
  }

  void _run(SessionEffect effect) {
    final repo = ref.read(repositoryProvider);
    final speaker = ref.read(speakerProvider);
    final recognizer = ref.read(recognizerProvider);
    switch (effect) {
      case PlayWord(:final word):
        speaker.speak(word.text.toLowerCase(), rate: _child.settings.speechRate);
      case StartListening():
        _listen(recognizer, speaker);
      case SaveAttempt():
        _queue(() => repo.saveAttempt(
              sessionId: _sessionId,
              childId: _child.id,
              wordId: effect.word.id,
              contentVersion: ref.read(contentProvider).version,
              tryNumber: effect.tryNumber,
              status: effect.status,
              matched: effect.matched,
              finished: effect.finished,
              assisted: effect.assisted,
              guardianOverride: effect.guardianOverride,
              engine: _useChoices ? 'choice' : recognizer.engineName,
              confidence: effect.confidence,
            ));
      case SaveLevelChange(:final from, :final to):
        _queue(() => repo.saveLevelChange(_child.id, from, to));
      case CloseSession(:final endLevel):
        _queue(() async {
          await repo.finishSession(id: _sessionId, childId: _child.id, endLevel: endLevel);
          unawaited(ref.read(syncEngineProvider)?.syncNow().catchError((_) {}));
        });
    }
  }

  void _queue(Future<void> Function() work) {
    _writes = _writes.then((_) => work()).catchError((Object _) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hasil belum tersimpan.')));
      }
    });
  }

  Future<void> _listen(SpeechRecognizer recognizer, Speaker speaker) async {
    await speaker.stop();
    SpeechHearing hearing;
    try {
      // Batas waktu menjaga anak tidak buntu bila layanan tidak pernah menjawab.
      hearing = await recognizer.listen().timeout(const Duration(seconds: 12), onTimeout: () => const SpeechHearing(''));
    } catch (_) {
      hearing = const SpeechHearing('');
    }
    if (mounted) _dispatch(SpeechHeard(hearing));
  }

  void _stopListening() {
    _dispatch(const SpeechStopped());
    ref.read(recognizerProvider).stop();
  }

  void _speak(String text) => ref.read(speakerProvider).speak(text.toLowerCase(), rate: _child.settings.speechRate);

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: MessageState(
            title: 'Latihan belum bisa dibuka',
            body: 'Coba kembali, lalu mulai lagi.',
            action: QuietAction(label: 'Kembali', onPressed: () => context.pop()),
          ),
        ),
      );
    }
    final s = _state;
    if (s == null) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.ink)));
    if (s.phase == SessionPhase.finished) return _SessionSummary(words: s.total);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.gutter),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 4,
                children: [
                  _BackPill(onPressed: () => context.pop()),
                  Semantics(
                    label: 'Kata ${s.position} dari ${s.total}',
                    excludeSemantics: true,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('${s.position} dari ${s.total}', style: AppText.bodyStrong),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _WordLantern(state: s, onTap: () => _speak(s.word.text), letterColors: _child.settings.letterColors),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var i = 0; i < s.word.syllables.length; i++)
                            SyllableTile(
                              text: s.word.syllables[i],
                              state: s.phase == SessionPhase.result || s.phase == SessionPhase.assisted
                                  ? tileStateFor(i, s.lastStatus, s.matched)
                                  : TileState.idle,
                              letterColors: _child.settings.letterColors,
                              onTap: () => _speak(s.word.syllables[i]),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _Controls(
                state: s,
                useChoices: _useChoices,
                choices: _choices,
                guided: _child.settings.guided,
                onMic: () => _dispatch(const MicPressed()),
                onStop: _stopListening,
                onNext: () => _dispatch(const NextPressed()),
                onConfirm: () => _dispatch(const GuardianConfirmed()),
                onChoice: (w) => _dispatch(ChoiceAnswered(w.id == s.word.id)),
                onHear: () => _speak(s.word.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text('Kembali'),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.ink,
          minimumSize: const Size(0, AppSpace.tapGuardian),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: AppText.bodyGuardian,
        ),
      );
}

class _WordLantern extends StatelessWidget {
  const _WordLantern({required this.state, required this.onTap, required this.letterColors});

  final SessionState state;
  final VoidCallback onTap;
  final bool letterColors;

  @override
  Widget build(BuildContext context) {
    final done = state.phase == SessionPhase.result && state.lastStatus == AttemptStatus.correct;
    return Semantics(
      button: true,
      label: 'Kata ${state.word.text.toLowerCase()}, sentuh untuk mendengar',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: LanternFrame(
          light: done ? 1 : 0,
          height: 240,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: LetterMarkedText(state.word.text, style: AppText.wordHero, markLetters: letterColors && !done),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.state,
    required this.useChoices,
    required this.choices,
    required this.guided,
    required this.onMic,
    required this.onStop,
    required this.onNext,
    required this.onConfirm,
    required this.onChoice,
    required this.onHear,
  });

  final SessionState state;
  final bool useChoices;
  final List<Word> choices;
  final bool guided;
  final VoidCallback onMic;
  final VoidCallback onStop;
  final VoidCallback onNext;
  final VoidCallback onConfirm;
  final ValueChanged<Word> onChoice;
  final VoidCallback onHear;

  bool get _last => state.position >= state.total;

  @override
  Widget build(BuildContext context) {
    switch (state.phase) {
      case SessionPhase.ready:
        return useChoices ? _choiceControls() : _micControls();
      case SessionPhase.listening:
        return Column(
          children: [
            _MicButton(listening: true, onPressed: onStop),
            const SizedBox(height: 12),
            Text('Lentera mendengarkan', style: AppText.bodyStrong, textAlign: TextAlign.center),
          ],
        );
      case SessionPhase.processing:
        return Column(
          children: [
            const SizedBox(height: 96, child: Center(child: CircularProgressIndicator(color: AppColors.ink))),
            const SizedBox(height: 12),
            Text('Sebentar ya', style: AppText.bodyStrong),
          ],
        );
      case SessionPhase.result:
        return _resultControls();
      case SessionPhase.assisted:
        return Column(
          children: [
            _Message(
              icon: Icons.volume_up_rounded,
              color: AppColors.ink,
              text: 'Kita baca bersama. Dengarkan, lalu lanjut.',
            ),
            const SizedBox(height: 12),
            QuietAction(label: 'Dengarkan lagi', icon: Icons.volume_up_rounded, onPressed: onHear),
            if (guided) ...[const SizedBox(height: 8), _confirmButton()],
            const SizedBox(height: 8),
            PrimaryAction(label: _last ? 'Selesai' : 'Kata berikutnya', onPressed: onNext),
          ],
        );
      case SessionPhase.finished:
        return const SizedBox.shrink();
    }
  }

  Widget _micControls() => Column(
        children: [
          _MicButton(listening: false, onPressed: onMic),
          const SizedBox(height: 12),
          Text('Tekan, lalu ucapkan', style: AppText.bodyStrong, textAlign: TextAlign.center),
        ],
      );

  Widget _choiceControls() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuietAction(label: 'Dengarkan', icon: Icons.volume_up_rounded, onPressed: onHear),
          const SizedBox(height: 8),
          Text('Mana kata yang kamu dengar?', style: AppText.bodyStrong, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          for (final w in choices)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Semantics(
                button: true,
                label: w.text.toLowerCase(),
                excludeSemantics: true,
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                    onTap: () => onChoice(w),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 64),
                      alignment: Alignment.center,
                      child: Text(w.text, style: AppText.heading),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _confirmButton() => QuietAction(label: 'Pendamping: sudah benar', icon: Icons.check_rounded, onPressed: onConfirm);

  Widget _resultControls() {
    final (Widget message, String action) = switch (state.lastStatus) {
      AttemptStatus.correct => (
          _Message(icon: Icons.check_circle_rounded, color: AppColors.ok, text: 'Terbaca dengan baik.'),
          _last ? 'Selesai' : 'Kata berikutnya',
        ),
      AttemptStatus.partial => (
          _Message(icon: Icons.hearing_rounded, color: AppColors.retry, text: 'Hampir. Dengarkan bagian yang bertanda, lalu coba lagi.'),
          'Coba lagi',
        ),
      AttemptStatus.unclear => (
          _Message(icon: Icons.hearing_rounded, color: AppColors.subInk, text: 'Lentera belum mendengar jelas. Coba ucapkan sekali lagi.'),
          'Coba lagi',
        ),
      _ => (
          _Message(icon: Icons.hearing_rounded, color: AppColors.retry, text: 'Dengarkan sekali lagi, lalu coba ya.'),
          'Coba lagi',
        ),
    };
    return Column(
      children: [
        message,
        const SizedBox(height: 12),
        if (guided && state.lastStatus != AttemptStatus.correct) ...[_confirmButton(), const SizedBox(height: 8)],
        PrimaryAction(label: action, onPressed: onNext),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: AppText.bodyStrong)),
          ],
        ),
      );
}

class _MicButton extends StatefulWidget {
  const _MicButton({required this.listening, required this.onPressed});

  final bool listening;
  final VoidCallback onPressed;

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton> with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animate = widget.listening && !motionReduced(context);
    if (animate && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!animate && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
    return Semantics(
      button: true,
      label: widget.listening ? 'Berhenti mendengarkan' : 'Mulai membaca dengan mikrofon',
      excludeSemantics: true,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, _) => Container(
                width: 96 + 24 * _pulse.value,
                height: 96 + 24 * _pulse.value,
                decoration: BoxDecoration(
                  color: widget.listening ? AppColors.lantern : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Material(
              color: AppColors.ink,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onPressed,
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Icon(widget.listening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 44),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionSummary extends StatelessWidget {
  const _SessionSummary({required this.words});

  final int words;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.gutter),
            child: Column(
              children: [
                const Spacer(),
                const SizedBox(
                  width: 160,
                  height: 210,
                  child: LanternFrame(color: AppColors.surface, light: 1, height: 210, child: SizedBox.shrink()),
                ),
                const SizedBox(height: 24),
                Text('Lentera hari ini menyala', style: AppText.title, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Kamu sudah berlatih $words kata.', style: AppText.body, textAlign: TextAlign.center),
                const Spacer(),
                PrimaryAction(label: 'Kembali ke Beranda', onPressed: () => context.go('/home')),
              ],
            ),
          ),
        ),
      );
}
