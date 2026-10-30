enum AttemptStatus { correct, partial, wrong, unclear }

class Word {
  const Word({required this.id, required this.text, required this.level, required this.syllables});

  final String id;
  final String text;
  final int level;
  final List<String> syllables;

  factory Word.fromJson(Map<String, dynamic> j) => Word(
        id: j['id'] as String,
        text: j['text'] as String,
        level: j['level'] as int,
        syllables: (j['syllables'] as List).cast<String>(),
      );
}

class SpeechHearing {
  const SpeechHearing(this.transcript, {this.confidence});

  final String transcript;
  final double? confidence;
}

class MatchResult {
  const MatchResult(this.status, this.matched);

  final AttemptStatus status;
  final List<int> matched;
}
