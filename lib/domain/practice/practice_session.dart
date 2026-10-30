import 'adaptive_engine.dart';
import 'models.dart';
import 'speech_matcher.dart';

enum SessionPhase { ready, listening, processing, result, assisted, finished }

sealed class SessionEvent {
  const SessionEvent();
}

class MicPressed extends SessionEvent {
  const MicPressed();
}

class SpeechStopped extends SessionEvent {
  const SpeechStopped();
}

class SpeechHeard extends SessionEvent {
  const SpeechHeard(this.hearing);
  final SpeechHearing hearing;
}

/// Mode dengar dan pilih, saat mikrofon atau pengenal ucapan tidak tersedia.
class ChoiceAnswered extends SessionEvent {
  const ChoiceAnswered(this.correct);
  final bool correct;
}

class NextPressed extends SessionEvent {
  const NextPressed();
}

class GuardianConfirmed extends SessionEvent {
  const GuardianConfirmed();
}

sealed class SessionEffect {
  const SessionEffect();
}

class PlayWord extends SessionEffect {
  const PlayWord(this.word);
  final Word word;
}

class StartListening extends SessionEffect {
  const StartListening();
}

class SaveAttempt extends SessionEffect {
  const SaveAttempt({
    required this.word,
    required this.tryNumber,
    required this.status,
    required this.matched,
    required this.finished,
    this.assisted = false,
    this.guardianOverride = false,
    this.confidence,
  });

  final Word word;
  final int tryNumber;
  final AttemptStatus status;
  final List<int> matched;
  final bool finished;
  final bool assisted;
  final bool guardianOverride;
  final double? confidence;
}

class SaveLevelChange extends SessionEffect {
  const SaveLevelChange(this.from, this.to);
  final int from;
  final int to;
}

class CloseSession extends SessionEffect {
  const CloseSession(this.endLevel);
  final int endLevel;
}

typedef WordPicker = Word Function(int level, Set<String> used);

class SessionState {
  const SessionState({
    required this.phase,
    required this.word,
    required this.position,
    required this.total,
    required this.adaptive,
    this.tries = 0,
    this.unclearTries = 0,
    this.lastStatus,
    this.matched = const [],
    this.correctWords = 0,
    this.used = const {},
  });

  final SessionPhase phase;
  final Word word;

  /// Nomor kata sekarang, mulai dari 1.
  final int position;
  final int total;
  final AdaptiveState adaptive;
  final int tries;
  final int unclearTries;
  final AttemptStatus? lastStatus;
  final List<int> matched;
  final int correctWords;
  final Set<String> used;

  int get level => adaptive.level;

  SessionState copyWith({
    SessionPhase? phase,
    AdaptiveState? adaptive,
    int? tries,
    int? unclearTries,
    AttemptStatus? lastStatus,
    List<int>? matched,
    int? correctWords,
  }) =>
      SessionState(
        phase: phase ?? this.phase,
        word: word,
        position: position,
        total: total,
        adaptive: adaptive ?? this.adaptive,
        tries: tries ?? this.tries,
        unclearTries: unclearTries ?? this.unclearTries,
        lastStatus: lastStatus ?? this.lastStatus,
        matched: matched ?? this.matched,
        correctWords: correctWords ?? this.correctWords,
        used: used,
      );
}

class Transition {
  const Transition(this.state, [this.effects = const []]);
  final SessionState state;
  final List<SessionEffect> effects;
}

/// Alur satu sesi tanpa Flutter dan tanpa database. Lihat DOCSS/04-ARSITEKTUR-DAN-BACKEND.md.
class PracticeSession {
  PracticeSession({
    required this.picker,
    this.engine = const AdaptiveEngine(),
    this.matcher = const SpeechMatcher(),
    this.maxTries = 2,
    this.maxUnclear = 3,
  });

  final WordPicker picker;
  final AdaptiveEngine engine;
  final SpeechMatcher matcher;
  final int maxTries;
  final int maxUnclear;

  Transition start({required int level, required int total, int alreadyDone = 0, Set<String> used = const {}}) {
    final word = picker(level, used);
    final state = SessionState(
      phase: SessionPhase.ready,
      word: word,
      position: alreadyDone + 1,
      total: total,
      adaptive: AdaptiveState(level: level),
      used: {...used, word.id},
    );
    return Transition(state, [PlayWord(word)]);
  }

  Transition reduce(SessionState s, SessionEvent event) {
    switch (event) {
      case MicPressed():
        if (s.phase != SessionPhase.ready) return Transition(s);
        return Transition(s.copyWith(phase: SessionPhase.listening), const [StartListening()]);
      case SpeechStopped():
        if (s.phase != SessionPhase.listening) return Transition(s);
        return Transition(s.copyWith(phase: SessionPhase.processing));
      case SpeechHeard(:final hearing):
        if (s.phase != SessionPhase.listening && s.phase != SessionPhase.processing) return Transition(s);
        return _applyResult(s, matcher.match(s.word, hearing), hearing.confidence);
      case ChoiceAnswered(:final correct):
        if (s.phase != SessionPhase.ready) return Transition(s);
        final result = correct
            ? MatchResult(AttemptStatus.correct, List.generate(s.word.syllables.length, (i) => i))
            : const MatchResult(AttemptStatus.wrong, []);
        return _applyResult(s, result, null);
      case NextPressed():
        return _next(s);
      case GuardianConfirmed():
        return _confirm(s);
    }
  }

  Transition _applyResult(SessionState s, MatchResult r, double? confidence) {
    if (r.status == AttemptStatus.unclear) {
      final unclear = s.unclearTries + 1;
      final giveUp = unclear >= maxUnclear;
      return Transition(
        s.copyWith(
          phase: giveUp ? SessionPhase.assisted : SessionPhase.result,
          unclearTries: unclear,
          lastStatus: AttemptStatus.unclear,
          matched: const [],
        ),
        [
          SaveAttempt(
            word: s.word,
            tryNumber: s.tries + unclear,
            status: AttemptStatus.unclear,
            matched: const [],
            finished: giveUp,
            assisted: giveUp,
            confidence: confidence,
          ),
          if (giveUp) PlayWord(s.word),
        ],
      );
    }

    final tries = s.tries + 1;
    final tryNumber = tries + s.unclearTries;
    if (r.status == AttemptStatus.correct) {
      final next = _finishWord(s, WordOutcome.correct);
      return Transition(
        next.state.copyWith(
          phase: SessionPhase.result,
          tries: tries,
          lastStatus: AttemptStatus.correct,
          matched: r.matched,
          correctWords: s.correctWords + 1,
        ),
        [
          SaveAttempt(
            word: s.word,
            tryNumber: tryNumber,
            status: AttemptStatus.correct,
            matched: r.matched,
            finished: true,
            confidence: confidence,
          ),
          ...next.effects,
        ],
      );
    }

    final outOfTries = tries >= maxTries;
    final adapted = outOfTries ? _finishWord(s, WordOutcome.missed) : Transition(s);
    return Transition(
      adapted.state.copyWith(
        phase: outOfTries ? SessionPhase.assisted : SessionPhase.result,
        tries: tries,
        lastStatus: r.status,
        matched: r.matched,
      ),
      [
        SaveAttempt(
          word: s.word,
          tryNumber: tryNumber,
          status: r.status,
          matched: r.matched,
          finished: outOfTries,
          assisted: outOfTries,
          confidence: confidence,
        ),
        ...adapted.effects,
        if (outOfTries) PlayWord(s.word),
      ],
    );
  }

  Transition _finishWord(SessionState s, WordOutcome outcome) {
    final adaptive = engine.evaluate(s.adaptive, outcome);
    return Transition(s.copyWith(adaptive: adaptive), [
      if (adaptive.level != s.level) SaveLevelChange(s.level, adaptive.level),
    ]);
  }

  bool _wordDone(SessionState s) =>
      s.phase == SessionPhase.assisted ||
      (s.phase == SessionPhase.result && s.lastStatus == AttemptStatus.correct);

  Transition _next(SessionState s) {
    if (s.phase == SessionPhase.result && !_wordDone(s)) {
      return Transition(s.copyWith(phase: SessionPhase.ready), [PlayWord(s.word)]);
    }
    if (!_wordDone(s)) return Transition(s);
    if (s.position >= s.total) {
      return Transition(s.copyWith(phase: SessionPhase.finished), [CloseSession(s.level)]);
    }
    final word = picker(s.level, s.used);
    return Transition(
      SessionState(
        phase: SessionPhase.ready,
        word: word,
        position: s.position + 1,
        total: s.total,
        adaptive: s.adaptive,
        correctWords: s.correctWords,
        used: {...s.used, word.id},
      ),
      [PlayWord(word)],
    );
  }

  /// Koreksi pendamping: hasil dibenarkan, dan kata lanjut seperti jawaban benar.
  Transition _confirm(SessionState s) {
    if (s.phase != SessionPhase.result && s.phase != SessionPhase.assisted) return Transition(s);
    if (s.lastStatus == AttemptStatus.correct) return Transition(s);
    final wasCounted = s.phase == SessionPhase.assisted && s.lastStatus != AttemptStatus.unclear;
    final all = List<int>.generate(s.word.syllables.length, (i) => i);
    // Kegagalan yang sudah dihitung tidak dibatalkan, supaya level tidak naik turun karena koreksi.
    final adapted = wasCounted ? Transition(s) : _finishWord(s, WordOutcome.correct);
    return Transition(
      adapted.state.copyWith(
        phase: SessionPhase.result,
        lastStatus: AttemptStatus.correct,
        matched: all,
        correctWords: s.correctWords + 1,
      ),
      [
        SaveAttempt(
          word: s.word,
          tryNumber: s.tries + s.unclearTries + 1,
          status: AttemptStatus.correct,
          matched: all,
          finished: true,
          guardianOverride: true,
        ),
        ...adapted.effects,
      ],
    );
  }
}
