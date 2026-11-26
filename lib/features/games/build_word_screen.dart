import 'dart:async';
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
import 'game_frame.dart';

/// Susun Kata: suku kata diacak, anak menyentuhnya sesuai urutan.
/// Sentuhan yang belum tepat tidak dihukum. Setelah dua kali, suku kata berikutnya diberi tanda kesumba.
class BuildWordScreen extends ConsumerStatefulWidget {
  const BuildWordScreen({super.key, this.random});

  final Random? random;

  @override
  ConsumerState<BuildWordScreen> createState() => _BuildWordScreenState();
}

class _BuildWordScreenState extends ConsumerState<BuildWordScreen> {
  static const rounds = 6;
  late final Random _random = widget.random ?? Random();
  List<Word> _words = const [];
  int _index = 0;
  List<int> _order = const [];
  final List<int> _placed = [];
  int _mistakes = 0;
  int? _wrongTile;
  String? _sessionId;
  bool _saved = false;
  Timer? _flash;
  late final Speaker _speaker = ref.read(speakerProvider);

  @override
  void initState() {
    super.initState();
    _speaker;
    _start();
  }

  @override
  void dispose() {
    _flash?.cancel();
    _speaker.stop();
    super.dispose();
  }

  Future<void> _start() async {
    final child = ref.read(activeChildProvider)!;
    final repo = ref.read(repositoryProvider);
    final content = ref.read(contentProvider);
    final level = await repo.currentLevel(child.id);
    final top = max(2, level);
    var pool = content.words.where((w) => w.syllables.length > 1 && w.level <= top).toList();
    if (pool.length < rounds) pool = content.words.where((w) => w.syllables.length > 1).toList();
    pool.shuffle(_random);
    final id = await repo.startSession(childId: child.id, kind: 'build', level: level, planned: rounds);
    if (!mounted) return;
    setState(() {
      _sessionId = id;
      _words = pool.take(rounds).toList();
      _index = 0;
    });
    _prepare();
  }

  void _prepare() {
    final word = _words[_index];
    final order = List.generate(word.syllables.length, (i) => i);
    // Diacak sampai tidak sama dengan urutan aslinya.
    for (var i = 0; i < 6; i++) {
      order.shuffle(_random);
      if (!_inOrder(order, word)) break;
    }
    setState(() {
      _order = order;
      _placed.clear();
      _mistakes = 0;
      _wrongTile = null;
      _saved = false;
    });
    _speak(word.text);
  }

  bool _inOrder(List<int> order, Word w) {
    for (var i = 0; i < order.length; i++) {
      if (w.syllables[order[i]] != w.syllables[i]) return false;
    }
    return true;
  }

  void _speak(String text) => _speaker.speak(text.toLowerCase(), rate: ref.read(activeChildProvider)?.settings.speechRate ?? 0.4);

  Word get _word => _words[_index];
  bool get _complete => _placed.length == _word.syllables.length;

  /// Indeks ubin yang tepat untuk posisi berikutnya. Suku kata kembar dianggap sama.
  int? get _nextTile {
    if (_complete) return null;
    final wanted = _word.syllables[_placed.length];
    for (final t in _order) {
      if (!_placed.contains(t) && _word.syllables[t] == wanted) return t;
    }
    return null;
  }

  void _tap(int tile) {
    if (_complete || _placed.contains(tile)) return;
    if (_word.syllables[tile] == _word.syllables[_placed.length]) {
      HapticFeedback.selectionClick();
      setState(() => _placed.add(tile));
      _speak(_word.syllables[tile]);
      if (_complete) _finishWord();
    } else {
      HapticFeedback.lightImpact();
      _flash?.cancel();
      setState(() {
        _mistakes++;
        _wrongTile = tile;
      });
      _flash = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _wrongTile = null);
      });
    }
  }

  Future<void> _finishWord() async {
    final child = ref.read(activeChildProvider)!;
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _speak(_word.text);
    });
    await ref.read(repositoryProvider).saveAttempt(
          sessionId: _sessionId!,
          childId: child.id,
          wordId: _word.id,
          contentVersion: ref.read(contentProvider).version,
          tryNumber: 1,
          status: _mistakes == 0 ? AttemptStatus.correct : AttemptStatus.partial,
          matched: List.generate(_word.syllables.length, (i) => i),
          finished: true,
          assisted: _mistakes >= 2,
          guardianOverride: false,
          engine: 'tap',
        );
    if (mounted) setState(() => _saved = true);
  }

  Future<void> _next() async {
    if (_index + 1 >= _words.length) {
      final child = ref.read(activeChildProvider)!;
      final repo = ref.read(repositoryProvider);
      await repo.finishSession(id: _sessionId!, childId: child.id, endLevel: await repo.currentLevel(child.id));
      if (mounted) setState(() => _index = _words.length);
      return;
    }
    setState(() => _index++);
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionId == null || _words.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_index >= _words.length) {
      return GameDone(
        color: Thread.jingga,
        total: _words.length,
        title: 'Semua kata tersusun',
        line: 'Kamu menyusun ${_words.length} kata dari suku katanya.',
        onAgain: () => context.pushReplacement('/build'),
      );
    }
    final p = Pal.of(context);
    final word = _word;
    final hint = _mistakes >= 2 ? _nextTile : null;
    final letterColors = ref.watch(activeChildProvider)?.settings.letterColors ?? false;

    final stage = Column(
      children: [
        GameField(
          color: _complete ? Thread.daun : Thread.jingga,
          child: Column(
            children: [
              Semantics(
                button: true,
                label: 'Dengarkan kata',
                excludeSemantics: true,
                child: IconButton.filled(
                  onPressed: () => _speak(word.text),
                  icon: const Icon(Icons.volume_up_rounded, size: 32),
                  style: IconButton.styleFrom(backgroundColor: Thread.tarum, foregroundColor: Colors.white, minimumSize: const Size(64, 64)),
                ),
              ),
              const SizedBox(height: 18),
              Semantics(
                label: 'Tersusun ${_placed.length} dari ${word.syllables.length} suku kata',
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var i = 0; i < word.syllables.length; i++)
                      _Slot(
                        text: i < _placed.length ? word.syllables[_placed[i]] : null,
                        width: 40.0 + word.syllables[i].length * 22,
                        letterColors: letterColors,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_complete) ...[
          Text(
            _mistakes >= 2 ? 'Coba suku kata yang bertanda.' : 'Sentuh suku kata sesuai urutan.',
            style: AppText.bodyStrong,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final t in _order)
                AnimatedOpacity(
                  duration: AppMotion.quick,
                  opacity: _placed.contains(t) ? 0.25 : 1,
                  child: SyllableTile(
                    text: word.syllables[t],
                    letterColors: letterColors,
                    state: t == _wrongTile ? TileState.retry : (t == hint ? TileState.active : TileState.idle),
                    onTap: _placed.contains(t) ? null : () => _tap(t),
                  ),
                ),
            ],
          ),
        ] else ...[
          StatusLine(icon: Icons.check_circle_rounded, color: p.ok, text: 'Tersusun: ${word.text}'),
          const SizedBox(height: 14),
          PrimaryAction(label: _index + 1 >= _words.length ? 'Selesai' : 'Kata berikutnya', onPressed: _saved ? _next : null),
        ],
      ],
    );

    return GameFrame(
      color: Thread.jingga,
      total: _words.length,
      done: _index + (_complete ? 1 : 0),
      position: _index + 1,
      stage: stage,
      controls: controls,
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.text, required this.width, required this.letterColors});

  final String? text;
  final double width;
  final bool letterColors;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: motionReduced(context) ? Duration.zero : AppMotion.quick,
        width: width,
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: text == null ? Colors.white.withValues(alpha: 0.4) : Colors.white,
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          border: Border.all(color: Thread.onThread.withValues(alpha: text == null ? 0.35 : 0), width: 2),
        ),
        child: text == null
            ? const SizedBox.shrink()
            : Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LetterMarkedText(text!, style: AppText.syllable.copyWith(color: Thread.onThread), markLetters: letterColors, onThread: true),
                ),
              ),
      );
}
