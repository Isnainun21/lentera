import '../practice/models.dart';

class AttemptRecord {
  const AttemptRecord({
    required this.sessionId,
    required this.wordId,
    required this.tryNumber,
    required this.status,
    required this.finished,
    required this.assisted,
    required this.occurredAt,
  });

  final String sessionId;
  final String wordId;
  final int tryNumber;
  final AttemptStatus status;
  final bool finished;
  final bool assisted;
  final DateTime occurredAt;
}

class WordResult {
  const WordResult({
    required this.wordId,
    required this.correctAlone,
    required this.counted,
    required this.finishedAt,
  });

  final String wordId;

  /// Benar tanpa bantuan.
  final bool correctAlone;

  /// Kata yang dilewati karena ucapan tidak jelas tidak ikut dihitung.
  final bool counted;
  final DateTime finishedAt;
}

/// Satu definisi statistik untuk semua layar. Lihat DOCSS/05-MATRIKS-SINKRON.md.
class ProgressStats {
  const ProgressStats._();

  static const minWordsForAccuracy = 10;
  static const minTriesForDifficult = 2;

  static List<WordResult> wordResults(Iterable<AttemptRecord> attempts) {
    final groups = <String, List<AttemptRecord>>{};
    for (final a in attempts) {
      groups.putIfAbsent('${a.sessionId}|${a.wordId}', () => []).add(a);
    }
    final results = <WordResult>[];
    for (final group in groups.values) {
      if (!group.any((a) => a.finished)) continue;
      group.sort((a, b) => a.tryNumber.compareTo(b.tryNumber));
      final last = group.last;
      results.add(WordResult(
        wordId: last.wordId,
        correctAlone: last.status == AttemptStatus.correct && !group.any((a) => a.assisted),
        counted: !group.every((a) => a.status == AttemptStatus.unclear),
        finishedAt: last.occurredAt,
      ));
    }
    return results;
  }

  static DateTime startOfWeek(DateTime now) {
    final day = DateTime(now.year, now.month, now.day);
    return DateTime(day.year, day.month, day.day - (day.weekday - 1));
  }

  /// Null berarti data belum cukup, dan layar menampilkan "Belum cukup data".
  static double? accuracy(Iterable<WordResult> results) {
    final counted = results.where((r) => r.counted).toList();
    if (counted.length < minWordsForAccuracy) return null;
    return counted.where((r) => r.correctAlone).length / counted.length;
  }

  static List<WordResult> between(Iterable<WordResult> results, DateTime from, DateTime to) =>
      results.where((r) => !r.finishedAt.isBefore(from) && r.finishedAt.isBefore(to)).toList();

  static List<String> difficultWords(Iterable<AttemptRecord> attempts, {int limit = 5}) {
    final trouble = <String, int>{};
    for (final a in attempts) {
      if (a.status == AttemptStatus.partial || a.status == AttemptStatus.wrong) {
        trouble[a.wordId] = (trouble[a.wordId] ?? 0) + 1;
      }
    }
    final ids = trouble.keys.where((k) => trouble[k]! >= minTriesForDifficult).toList()
      ..sort((a, b) => trouble[b]!.compareTo(trouble[a]!));
    return ids.take(limit).toList();
  }

  /// Hari di minggu ini yang punya sesi selesai, indeks 0 adalah Senin.
  static List<bool> weekLanterns(Iterable<DateTime> sessionEnds, DateTime now) {
    final start = startOfWeek(now);
    final week = List<bool>.filled(7, false);
    for (final end in sessionEnds) {
      final index = DateTime(end.year, end.month, end.day).difference(start).inDays;
      if (index >= 0 && index < 7) week[index] = true;
    }
    return week;
  }
}
