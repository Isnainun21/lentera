import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side/app/app.dart';
import 'package:side/app/providers.dart';
import 'package:side/app/router.dart';
import 'package:side/content/content.dart';
import 'package:side/core/db/database.dart';
import 'package:side/core/design/components.dart';
import 'package:side/core/speech/speech_ports.dart';
import 'package:side/features/guardian/guardian_screens.dart';
import 'package:side/features/practice/session_screen.dart' show ChoiceButton;

import 'app_flow_test.dart' show FakeRecognizer, settle;

class RecordingSpeaker implements Speaker {
  String last = '';
  @override
  Future<void> speak(String text, {double rate = 0.4, void Function(int start, int end)? onWord}) async => last = text;
  @override
  Future<void> stop() async {}
}

Future<(ProviderContainer, AppDatabase, Content, RecordingSpeaker)> start(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final db = AppDatabase(NativeDatabase.memory());
  final content = (await tester.runAsync(() => Content.load(rootBundle)))!;
  final speaker = RecordingSpeaker();
  final container = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(db),
    contentProvider.overrideWithValue(content),
    recognizerProvider.overrideWithValue(FakeRecognizer(SpeechAvailability.ready)),
    speakerProvider.overrideWithValue(speaker),
  ]);
  addTearDown(container.dispose);
  final repo = container.read(repositoryProvider);
  await tester.runAsync(() async {
    await repo.setPin('1234');
    await repo.createChild(nickname: 'Bima', avatarId: 0, startLevel: 2);
  });
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const LenteraApp()));
  await settle(tester, 800);
  return (container, db, content, speaker);
}

Future<void> tapAndSettle(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('Susun Kata: enam kata tersusun, tersimpan, dan tidak masuk ketepatan membaca', (tester) async {
    final (container, db, content, _) = await start(tester);
    container.read(routerProvider).go('/build');
    await settle(tester, 800);

    for (var round = 0; round < 6; round++) {
      expect(find.text('${round + 1} dari 6'), findsOneWidget);
      final tiles = tester.widgetList<SyllableTile>(find.byType(SyllableTile)).map((t) => t.text).toList();
      final sorted = [...tiles]..sort();
      final word = content.words.firstWhere((w) => w.syllables.length == tiles.length && ([...w.syllables]..sort()).join() == sorted.join());
      // Satu sentuhan salah dulu bila bisa, untuk memastikan anak tidak dihukum.
      if (word.syllables.toSet().length > 1) {
        await tapAndSettle(tester, find.widgetWithText(SyllableTile, word.syllables.last).first);
      }
      for (final syllable in word.syllables) {
        final candidates = find.byWidgetPredicate((w) => w is SyllableTile && w.text == syllable && w.onTap != null);
        await tapAndSettle(tester, candidates.first);
      }
      expect(find.text('Tersusun: ${word.text}'), findsOneWidget);
      await tapAndSettle(tester, find.text(round == 5 ? 'Selesai' : 'Kata berikutnya'));
    }
    await settle(tester, 600);
    expect(find.text('Semua kata tersusun'), findsOneWidget);

    final sessions = await tester.runAsync(() => db.select(db.practiceSessions).get());
    expect(sessions!.single.kind, 'build');
    expect(sessions.single.endedAt, isNotNull);
    final attempts = await tester.runAsync(() => db.select(db.attempts).get());
    expect(attempts!.where((a) => a.finished).length, 6);

    final child = container.read(activeChildProvider)!;
    final records = (await tester.runAsync(() => container.read(repositoryProvider).attemptRecords(child.id)))!;
    final summary = ChildSummary(records, sessions, content, DateTime.now());
    expect(summary.wordsThisWeek, 0);
    expect(summary.gameAttempts.length, 6);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });

  testWidgets('Dengar dan Pilih: pilihan salah boleh diulang, enam kata selesai', (tester) async {
    final (container, db, _, speaker) = await start(tester);
    container.read(routerProvider).go('/listen');
    await settle(tester, 800);

    for (var round = 0; round < 6; round++) {
      expect(find.text('Mana kata yang kamu dengar?'), findsOneWidget);
      final heard = speaker.last;
      final choices = tester.widgetList<ChoiceButton>(find.byType(ChoiceButton)).toList();
      if (round == 0) {
        final wrong = choices.firstWhere((c) => c.text.toLowerCase() != heard);
        await tapAndSettle(tester, find.widgetWithText(ChoiceButton, wrong.text));
        expect(find.text('Dengarkan lagi, lalu pilih yang lain.'), findsOneWidget);
      }
      final right = choices.firstWhere((c) => c.text.toLowerCase() == heard);
      await tapAndSettle(tester, find.widgetWithText(ChoiceButton, right.text));
      await tapAndSettle(tester, find.text(round == 5 ? 'Selesai' : 'Kata berikutnya'));
    }
    await settle(tester, 600);
    expect(find.text('Telingamu jeli'), findsOneWidget);
    final attempts = await tester.runAsync(() => db.select(db.attempts).get());
    expect(attempts!.where((a) => a.finished).length, 6);
    expect(attempts.length, 7);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
