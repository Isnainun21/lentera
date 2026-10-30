import 'package:flutter_test/flutter_test.dart';
import 'package:side/domain/practice/adaptive_engine.dart';
import 'package:side/domain/practice/models.dart';
import 'package:side/domain/practice/practice_session.dart';
import 'package:side/domain/practice/speech_matcher.dart';
import 'package:side/domain/progress/stats.dart';

const buku = Word(id: 'b', text: 'BUKU', level: 2, syllables: ['BU', 'KU']);
const ba = Word(id: 'ba', text: 'BA', level: 1, syllables: ['BA']);
const sekolah = Word(id: 's', text: 'SEKOLAH', level: 4, syllables: ['SE', 'KO', 'LAH']);

void main() {
  group('SpeechMatcher', () {
    const m = SpeechMatcher();
    AttemptStatus st(Word w, String t, [double? c]) => m.match(w, SpeechHearing(t, confidence: c)).status;

    test('kata utuh, huruf besar, dan tanda baca', () {
      expect(st(buku, 'BUKU!'), AttemptStatus.correct);
      expect(st(buku, 'bu ku'), AttemptStatus.correct);
    });
    test('suku kata tunggal memaafkan akhiran mirip', () {
      expect(st(ba, 'bah'), AttemptStatus.correct);
      expect(st(ba, 'bak'), AttemptStatus.correct);
      expect(st(ba, 'bi'), AttemptStatus.wrong);
    });
    test('BUKU dan DUKU tetap berbeda', () {
      final r = m.match(buku, const SpeechHearing('duku'));
      expect(r.status, AttemptStatus.partial);
      expect(r.matched, [1]);
    });
    test('kata panjang memaafkan satu huruf', () {
      expect(st(sekolah, 'sekola'), AttemptStatus.correct);
    });
    test('kosong atau keyakinan rendah berarti tidak jelas', () {
      expect(st(buku, '  '), AttemptStatus.unclear);
      expect(st(buku, 'buku', 0.1), AttemptStatus.unclear);
      expect(st(buku, 'buku', 0), AttemptStatus.correct);
    });
    test('ucapan lain salah', () => expect(st(buku, 'meja'), AttemptStatus.wrong));
  });

  group('AdaptiveEngine', () {
    const e = AdaptiveEngine();
    test('naik setelah 3 benar, turun setelah 2 gagal, tetap di rentang', () {
      var s = const AdaptiveState(level: 5);
      for (var i = 0; i < 3; i++) {
        s = e.evaluate(s, WordOutcome.correct);
      }
      expect(s.level, 5);
      s = const AdaptiveState(level: 1);
      s = e.evaluate(e.evaluate(s, WordOutcome.missed), WordOutcome.missed);
      expect(s.level, 1);
      s = const AdaptiveState(level: 3);
      s = e.evaluate(e.evaluate(s, WordOutcome.missed), WordOutcome.missed);
      expect(s.level, 2);
    });
    test('kata dilewati tidak mengubah hitungan', () {
      final s = e.evaluate(const AdaptiveState(level: 2, missStreak: 1), WordOutcome.skipped);
      expect(s.missStreak, 1);
    });
  });

  group('PracticeSession', () {
    late PracticeSession session;
    setUp(() => session = PracticeSession(
        picker: (level, used) => Word(id: 'w${used.length}', text: 'BUKU', level: level, syllables: const ['BU', 'KU'])));

    SessionState speak(SessionState s, String text, List<SessionEffect> out) {
      var t = session.reduce(s, const MicPressed());
      out.addAll(t.effects);
      t = session.reduce(t.state, SpeechHeard(SpeechHearing(text)));
      out.addAll(t.effects);
      return t.state;
    }

    test('sesi penuh naik level dan kata berikutnya dari level baru', () {
      final fx = <SessionEffect>[];
      var s = session.start(level: 2, total: 4).state;
      for (var i = 0; i < 3; i++) {
        s = speak(s, 'buku', fx);
        s = session.reduce(s, const NextPressed()).state;
      }
      expect(s.level, 3);
      expect(s.word.level, 3);
      expect(s.position, 4);
      expect(fx.whereType<SaveLevelChange>().single.to, 3);
      s = speak(s, 'buku', fx);
      final end = session.reduce(s, const NextPressed());
      expect(end.state.phase, SessionPhase.finished);
      expect(end.effects.single, isA<CloseSession>());
    });

    test('dua percobaan gagal menjadi bantuan dan anak tetap bisa lanjut', () {
      final fx = <SessionEffect>[];
      var s = session.start(level: 2, total: 2).state;
      s = speak(s, 'meja', fx);
      expect(s.phase, SessionPhase.result);
      s = session.reduce(s, const NextPressed()).state;
      expect(s.phase, SessionPhase.ready);
      s = speak(s, 'meja', fx);
      expect(s.phase, SessionPhase.assisted);
      expect(fx.whereType<SaveAttempt>().last.finished, isTrue);
      s = session.reduce(s, const NextPressed()).state;
      expect(s.position, 2);
    });

    test('ucapan tidak jelas tidak menurunkan level dan tidak membuat buntu', () {
      final fx = <SessionEffect>[];
      var s = session.start(level: 3, total: 2).state;
      for (var i = 0; i < 3; i++) {
        s = speak(s, '', fx);
        if (i < 2) s = session.reduce(s, const NextPressed()).state;
      }
      expect(s.phase, SessionPhase.assisted);
      expect(s.level, 3);
      expect(fx.whereType<SaveLevelChange>(), isEmpty);
    });

    test('koreksi pendamping mencatat override', () {
      final fx = <SessionEffect>[];
      var s = session.start(level: 2, total: 1).state;
      s = speak(s, 'meja', fx);
      final t = session.reduce(s, const GuardianConfirmed());
      expect((t.effects.first as SaveAttempt).guardianOverride, isTrue);
      expect(t.state.lastStatus, AttemptStatus.correct);
    });

    test('dengar dan pilih memakai alur yang sama', () {
      var s = session.start(level: 2, total: 1).state;
      s = session.reduce(s, const ChoiceAnswered(true)).state;
      expect(s.lastStatus, AttemptStatus.correct);
    });
  });

  group('ProgressStats', () {
    AttemptRecord a(String w, int t, AttemptStatus st, {bool f = true, bool assisted = false}) => AttemptRecord(
        sessionId: 's', wordId: w, tryNumber: t, status: st, finished: f, assisted: assisted, occurredAt: DateTime(2026, 10, 28));

    test('akurasi kosong sampai 10 kata, lalu hanya benar tanpa bantuan', () {
      expect(ProgressStats.accuracy(ProgressStats.wordResults([a('x', 1, AttemptStatus.correct)])), isNull);
      final many = ProgressStats.wordResults([
        for (var i = 0; i < 8; i++) a('w$i', 1, AttemptStatus.correct),
        a('h', 1, AttemptStatus.wrong, assisted: true),
        a('k', 1, AttemptStatus.wrong, assisted: true),
        a('u', 1, AttemptStatus.unclear, assisted: true),
      ]);
      expect(ProgressStats.accuracy(many), 0.8);
    });
    test('kata belum selesai tidak dihitung', () {
      expect(ProgressStats.wordResults([a('x', 1, AttemptStatus.wrong, f: false)]), isEmpty);
    });
    test('lentera mingguan dan awal minggu Senin', () {
      final now = DateTime(2026, 10, 31); // Sabtu
      expect(ProgressStats.startOfWeek(now), DateTime(2026, 10, 26));
      expect(ProgressStats.weekLanterns([DateTime(2026, 10, 26, 20), DateTime(2026, 10, 19)], now),
          [true, false, false, false, false, false, false]);
    });
    test('kata sulit minimal 2 percobaan', () {
      expect(
          ProgressStats.difficultWords(
              [a('x', 1, AttemptStatus.wrong), a('x', 2, AttemptStatus.partial), a('y', 1, AttemptStatus.wrong)]),
          ['x']);
    });
  });
}
