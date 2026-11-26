import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
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

  /// Kata yang sudah selesai di sesi ini, untuk pita benang dan ringkasan.
  final List<Word> _done = [];
  int _alreadyDone = 0;

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
        _alreadyDone = open.doneWords.length;
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
        if (effect.finished && !_done.any((w) => w.id == effect.word.id)) _done.add(effect.word);
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
            motif: Motif.lurik,
            action: QuietAction(label: 'Kembali', onPressed: () => context.pop()),
          ),
        ),
      );
    }
    final s = _state;
    if (s == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (s.phase == SessionPhase.finished) {
      return _SessionSummary(words: _done, total: s.total, onHear: _speak, onAgain: () => context.pushReplacement('/session'));
    }

    final filled = (_alreadyDone + _done.length).clamp(0, s.total);
    final topBar = Row(
      children: [
        RoundButton(icon: Icons.close_rounded, label: 'Berhenti, lanjutkan nanti', size: AppSpace.tapChild, onPressed: () => context.pop()),
        const SizedBox(width: 14),
        Expanded(child: ThreadSlots(total: s.total, filled: filled, active: filled < s.total ? filled : null)),
        const SizedBox(width: 14),
        Semantics(
          label: 'Kata ${s.position} dari ${s.total}',
          excludeSemantics: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 96),
            child: FittedBox(fit: BoxFit.scaleDown, child: Text('${s.position} dari ${s.total}', style: AppText.bodyStrong)),
          ),
        ),
      ],
    );
    final short = isShortLandscape(context);
    final split = WindowSize.of(context).isWide || short;
    final word = _WordField(state: s, onTap: () => _speak(s.word.text), letterColors: _child.settings.letterColors, compact: short);
    final tiles = s.word.syllables.length > 1
        ? Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < s.word.syllables.length; i++)
                SyllableTile(
                  text: s.word.syllables[i],
                  state: s.phase == SessionPhase.result || s.phase == SessionPhase.assisted ? tileStateFor(i, s.lastStatus, s.matched) : TileState.idle,
                  letterColors: _child.settings.letterColors,
                  onTap: () => _speak(s.word.syllables[i]),
                ),
            ],
          )
        : const SizedBox.shrink();
    final controls = _Controls(
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
    );
    final g = gutterFor(context);
    final wordArea = SingleChildScrollView(child: Column(children: [word, const SizedBox(height: 16), tiles]));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(g, 12, g, g),
          child: Pane(
            maxWidth: split ? 1200 : 640,
            child: Column(
              children: [
                topBar,
                const SizedBox(height: 16),
                Expanded(
                  child: split
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 6, child: wordArea),
                            SizedBox(width: g),
                            Expanded(flex: 4, child: Center(child: SingleChildScrollView(child: controls))),
                          ],
                        )
                      : Column(children: [Expanded(child: wordArea), const SizedBox(height: 12), controls]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WordField extends StatelessWidget {
  const _WordField({required this.state, required this.onTap, required this.letterColors, this.compact = false});

  final SessionState state;
  final VoidCallback onTap;
  final bool letterColors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final done = state.phase == SessionPhase.result && state.lastStatus == AttemptStatus.correct;
    final height = compact ? 150.0 : (MediaQuery.sizeOf(context).height * 0.36).clamp(220.0, 380.0);
    return Semantics(
      button: true,
      label: 'Kata ${state.word.text.toLowerCase()}, sentuh untuk mendengar',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: motionReduced(context) ? Duration.zero : AppMotion.panel,
          curve: AppMotion.ease,
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(color: done ? Thread.daun : Thread.kunyit, borderRadius: BorderRadius.circular(AppSpace.panelRadius)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned(top: 0, left: 0, right: 0, child: Selvedge(lead: Thread.tarum, height: 8)),
              const Positioned(top: 22, right: 18, child: Icon(Icons.volume_up_rounded, size: 30, color: Thread.onThread)),
              if (done) const Positioned(top: 22, left: 18, child: Icon(Icons.check_circle_rounded, size: 30, color: Thread.onThread)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: LetterMarkedText(
                      state.word.text,
                      style: AppText.wordHero.copyWith(color: Thread.onThread, fontSize: compact ? 52 : 80),
                      markLetters: letterColors && !done,
                      onThread: true,
                    ),
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
    final p = Pal.of(context);
    switch (state.phase) {
      case SessionPhase.ready:
        return useChoices ? _choiceControls(p) : _micControls();
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
            const SizedBox(height: 104, child: Center(child: CircularProgressIndicator())),
            const SizedBox(height: 12),
            Text('Sebentar ya', style: AppText.bodyStrong),
          ],
        );
      case SessionPhase.result:
        return _resultControls(p);
      case SessionPhase.assisted:
        return Column(
          children: [
            StatusLine(icon: Icons.volume_up_rounded, color: p.ink, text: 'Kita baca bersama. Dengarkan, lalu lanjut.'),
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

  Widget _choiceControls(Pal p) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuietAction(label: 'Dengarkan', icon: Icons.volume_up_rounded, onPressed: onHear),
          const SizedBox(height: 12),
          Text('Mana kata yang kamu dengar?', style: AppText.bodyStrong, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          for (final w in choices)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ChoiceButton(text: w.text, onTap: () => onChoice(w)),
            ),
        ],
      );

  Widget _confirmButton() => QuietAction(label: 'Pendamping: sudah benar', icon: Icons.check_rounded, onPressed: onConfirm);

  Widget _resultControls(Pal p) {
    final (Widget message, String action) = switch (state.lastStatus) {
      AttemptStatus.correct => (
          StatusLine(icon: Icons.check_circle_rounded, color: p.ok, text: 'Terbaca dengan baik.'),
          _last ? 'Selesai' : 'Kata berikutnya',
        ),
      AttemptStatus.partial => (
          StatusLine(icon: Icons.hearing_rounded, color: p.retry, text: 'Hampir. Dengarkan bagian yang bertanda, lalu coba lagi.'),
          'Coba lagi',
        ),
      AttemptStatus.unclear => (
          StatusLine(icon: Icons.hearing_rounded, color: p.subInk, text: 'Lentera belum mendengar jelas. Coba ucapkan sekali lagi.'),
          'Coba lagi',
        ),
      _ => (
          StatusLine(icon: Icons.hearing_rounded, color: p.retry, text: 'Dengarkan sekali lagi, lalu coba ya.'),
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

/// Pilihan jawaban besar untuk mode dengar dan pilih.
class ChoiceButton extends StatelessWidget {
  const ChoiceButton({super.key, required this.text, required this.onTap, this.state = TileState.idle});

  final String text;
  final VoidCallback? onTap;
  final TileState state;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final (bg, fg, icon) = switch (state) {
      TileState.correct => (p.okSoft, p.ok, Icons.check_rounded),
      TileState.retry => (p.retrySoft, p.retry, Icons.hearing_rounded),
      _ => (p.surface, p.ink, null),
    };
    return Semantics(
      button: true,
      label: text.toLowerCase(),
      excludeSemantics: true,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 68),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpace.tileRadius),
              border: Border.all(color: state == TileState.idle ? p.line : Colors.transparent, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text(text, style: AppText.heading.copyWith(color: fg, fontSize: 24, letterSpacing: 1))),
                if (icon != null) ...[const SizedBox(width: 8), Icon(icon, color: fg)],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol mikrofon. Saat mendengarkan, cincin kesumba berdenyut: kesumba adalah warna keadaan aktif.
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
    final p = Pal.of(context);
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
        width: 132,
        height: 132,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, _) => Container(
                width: 104 + 26 * _pulse.value,
                height: 104 + 26 * _pulse.value,
                decoration: BoxDecoration(
                  color: widget.listening ? Thread.kesumba : Colors.transparent,
                  borderRadius: BorderRadius.circular(30 + 6 * _pulse.value),
                ),
              ),
            ),
            Material(
              color: p.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: InkWell(
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onPressed();
                },
                child: SizedBox(
                  width: 104,
                  height: 104,
                  child: Icon(widget.listening ? Icons.stop_rounded : Icons.mic_rounded, color: p.onPrimary, size: 46),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ringkasan: pita sesi selesai ditenun, dan daftar kata yang bisa didengar lagi. Tanpa skor.
class _SessionSummary extends StatelessWidget {
  const _SessionSummary({required this.words, required this.total, required this.onHear, required this.onAgain});

  final List<Word> words;
  final int total;
  final ValueChanged<String> onHear;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final wide = WindowSize.of(context).isWide;
    final cloth = Panel(
      color: Thread.kunyit,
      selvedge: Thread.tarum,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sesi selesai', style: AppText.display.copyWith(color: Thread.onThread)),
          const SizedBox(height: 6),
          Text('Satu pita kain selesai kamu tenun.', style: AppText.body.copyWith(color: Thread.onThread)),
          const SizedBox(height: 24),
          ThreadSlots(total: total, filled: total, onDark: true, height: 22),
          const SizedBox(height: 10),
          Text('Kamu sudah berlatih $total kata.', style: AppText.bodyStrong.copyWith(color: Thread.onThread)),
        ],
      ),
    );
    final list = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (words.isNotEmpty) ...[
          Text('Kata yang kamu baca', style: AppText.heading),
          const SizedBox(height: 4),
          Text('Sentuh untuk mendengar lagi.', style: AppText.caption.copyWith(color: p.subInk)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final w in words)
                ActionChip(
                  label: Text(w.text, style: AppText.bodyStrong),
                  avatar: const Icon(Icons.volume_up_rounded, size: 20),
                  onPressed: () => onHear(w.text),
                  backgroundColor: p.surface,
                  side: BorderSide(color: p.line),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
            ],
          ),
        ],
      ],
    );
    final actions = Column(
      children: [
        PrimaryAction(label: 'Kembali ke Beranda', onPressed: () => context.go('/home')),
        const SizedBox(height: 10),
        QuietAction(label: 'Baca lagi', icon: Icons.replay_rounded, onPressed: onAgain),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: PaneList(
          maxWidth: wide ? 1000 : 640,
          children: [
            const SizedBox(height: 12),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cloth),
                  const SizedBox(width: 24),
                  Expanded(child: Column(children: [list, const SizedBox(height: 24), actions])),
                ],
              )
            else ...[
              cloth,
              const SizedBox(height: 24),
              list,
              const SizedBox(height: 28),
              actions,
            ],
          ],
        ),
      ),
    );
  }
}
