import 'models.dart';

/// Aturan sementara sampai ada data uji suara (DOCSS/06-ROADMAP.md, Fase 1).
class SpeechMatcher {
  const SpeechMatcher({this.minConfidence = 0.2});

  final double minConfidence;

  // Pengenal ucapan menyukai kata utuh, jadi "ba" sering terbaca "bah" atau "bak".
  static const _soundAlikeEndings = {'h', 'k', 'q'};

  MatchResult match(Word word, SpeechHearing hearing) {
    final spoken = _normalize(hearing.transcript);
    // Sebagian engine melaporkan 0 saat keyakinan tidak tersedia.
    final confidence = hearing.confidence;
    final lowConfidence = confidence != null && confidence > 0 && confidence < minConfidence;
    if (spoken.isEmpty || lowConfidence) return const MatchResult(AttemptStatus.unclear, []);

    final target = _normalize(word.text).replaceAll(' ', '');
    final tokens = spoken.split(' ');
    final joined = tokens.join();
    final all = List<int>.generate(word.syllables.length, (i) => i);

    if (joined == target || tokens.contains(target) || _closeEnough(joined, target)) {
      return MatchResult(AttemptStatus.correct, all);
    }

    final matched = <int>[];
    var cursor = 0;
    for (var i = 0; i < word.syllables.length; i++) {
      final syllable = _normalize(word.syllables[i]);
      final tokenHit = tokens.any((t) => _sameSyllable(t, syllable));
      final at = joined.indexOf(syllable, cursor);
      if (tokenHit || at >= 0) {
        matched.add(i);
        if (at >= 0) cursor = at + syllable.length;
      }
    }

    if (matched.length == word.syllables.length) return MatchResult(AttemptStatus.correct, matched);
    if (matched.isEmpty) return const MatchResult(AttemptStatus.wrong, []);
    return MatchResult(AttemptStatus.partial, matched);
  }

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp('[^a-z ]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

  static bool _sameSyllable(String token, String syllable) {
    if (token == syllable) return true;
    return token.length == syllable.length + 1 &&
        token.startsWith(syllable) &&
        _soundAlikeEndings.contains(token[token.length - 1]);
  }

  // Satu huruf meleset hanya dimaafkan pada kata panjang, agar BUKU dan DUKU tetap berbeda.
  static bool _closeEnough(String a, String b) {
    if (b.length < 6) return false;
    return _editDistance(a, b) <= 1;
  }

  static int _editDistance(String a, String b) {
    var previous = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 1; i <= a.length; i++) {
      final current = [i];
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        current.add([previous[j] + 1, current[j - 1] + 1, previous[j - 1] + cost].reduce((x, y) => x < y ? x : y));
      }
      previous = current;
    }
    return previous[b.length];
  }
}
