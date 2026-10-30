import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../domain/practice/models.dart';

class StoryPage {
  const StoryPage({required this.text, required this.syllables});
  final String text;
  final String syllables;
}

class Story {
  const Story({required this.id, required this.title, required this.level, required this.color, required this.pages});

  final String id;
  final String title;
  final int level;
  final String color;
  final List<StoryPage> pages;
}

class LetterQuestion {
  const LetterQuestion({required this.id, required this.target, required this.options, required this.answers, required this.hint});

  final String id;
  final String target;
  final List<String> options;
  final List<int> answers;
  final String hint;
}

class Content {
  const Content({required this.version, required this.words, required this.stories, required this.letters});

  final int version;
  final List<Word> words;
  final List<Story> stories;
  final List<LetterQuestion> letters;

  static Future<Content> load(AssetBundle bundle) async {
    final w = jsonDecode(await bundle.loadString('assets/content/words.json')) as Map<String, dynamic>;
    final s = jsonDecode(await bundle.loadString('assets/content/stories.json')) as Map<String, dynamic>;
    final l = jsonDecode(await bundle.loadString('assets/content/letters.json')) as Map<String, dynamic>;
    return Content(
      version: w['version'] as int,
      words: [for (final j in w['words'] as List) Word.fromJson(j as Map<String, dynamic>)],
      stories: [
        for (final j in (s['stories'] as List).cast<Map<String, dynamic>>())
          Story(
            id: j['id'] as String,
            title: j['title'] as String,
            level: j['level'] as int,
            color: j['color'] as String,
            pages: [
              for (final p in (j['pages'] as List).cast<Map<String, dynamic>>())
                StoryPage(text: p['text'] as String, syllables: p['syllables'] as String),
            ],
          ),
      ],
      letters: [
        for (final j in (l['questions'] as List).cast<Map<String, dynamic>>())
          LetterQuestion(
            id: j['id'] as String,
            target: j['target'] as String,
            options: (j['options'] as List).cast<String>(),
            answers: (j['answers'] as List).cast<int>(),
            hint: j['hint'] as String,
          ),
      ],
    );
  }

  Word? wordById(String id) {
    for (final w in words) {
      if (w.id == id) return w;
    }
    return null;
  }

  /// Kata acak dari level itu yang belum dipakai. Jika habis, boleh mengulang.
  Word pickWord(int level, Set<String> used, {Random? random, List<String> priority = const []}) {
    for (final id in priority) {
      final w = wordById(id);
      if (w != null && !used.contains(id)) return w;
    }
    final pool = words.where((w) => w.level == level).toList();
    final fresh = pool.where((w) => !used.contains(w.id)).toList();
    final from = fresh.isNotEmpty ? fresh : pool;
    return from[(random ?? Random()).nextInt(from.length)];
  }

  /// Pilihan untuk mode dengar dan pilih: jawaban benar dan dua pengecoh dari level sama.
  List<Word> choicesFor(Word word, {Random? random}) {
    final r = random ?? Random();
    final others = words.where((w) => w.level == word.level && w.id != word.id).toList()..shuffle(r);
    return [word, ...others.take(2)]..shuffle(r);
  }
}
