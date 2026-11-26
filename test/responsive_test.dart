import 'dart:io';

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
import 'package:side/core/speech/speech_ports.dart';
import 'package:side/domain/practice/models.dart';

import 'app_flow_test.dart' show FakeRecognizer, FakeSpeaker, settle;

/// Setiap layar dirender di ukuran ponsel sampai tablet, terang dan gelap, tanpa overflow.
/// Jalankan dengan `--dart-define=CAPTURE=true` untuk menyimpan tangkapan layar ke build/screens/.
const capture = bool.fromEnvironment('CAPTURE');

const sizes = {
  'phone-small': (Size(320, 568), 1.6),
  'phone': (Size(390, 844), 1.0),
  'phone-landscape': (Size(844, 390), 1.0),
  'tablet': (Size(800, 1280), 1.0),
  'tablet-landscape': (Size(1280, 800), 1.0),
};

const routes = [
  '/home',
  '/practice',
  '/stories',
  '/collection',
  '/session',
  '/build',
  '/listen',
  '/letters',
  '/words',
  '/story/c1',
  '/profiles',
  '/guardian',
  '/guardian/history',
  '/guardian/words',
  '/guardian/learning',
  '/guardian/access',
  '/guardian/data',
];

Future<void> loadFonts() async {
  final lexend = FontLoader('Lexend')..addFont(rootBundle.load('assets/fonts/Lexend.ttf'));
  await lexend.load();
  var dir = File(Platform.resolvedExecutable).parent;
  File icons = File('');
  for (var i = 0; i < 8; i++) {
    final f = File('${dir.path}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    final g = File('${dir.path}/material_fonts/MaterialIcons-Regular.otf');
    if (f.existsSync()) icons = f;
    if (g.existsSync()) icons = g;
    if (icons.path.isNotEmpty) break;
    dir = dir.parent;
  }
  if (icons.path.isNotEmpty) {
    final loader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
    await loader.load();
  }
}

/// Data contoh: satu anak dengan beberapa sesi, supaya layar berisi angka nyata.
Future<void> seed(AppDatabase db, Content content) async {
  final scope = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
  final repo = scope.read(repositoryProvider);
  await repo.setPin('1234');
  final id = await repo.createChild(nickname: 'Bima', avatarId: 2, startLevel: 2);
  final s = await repo.startSession(childId: id, kind: 'reading', level: 2, planned: 6);
  final words = content.words.where((w) => w.level == 2).take(6).toList();
  for (final (i, w) in words.indexed) {
    await repo.saveAttempt(
      sessionId: s,
      childId: id,
      wordId: w.id,
      contentVersion: content.version,
      tryNumber: 1,
      status: i == 2 ? AttemptStatus.partial : AttemptStatus.correct,
      matched: const [0],
      finished: true,
      assisted: i == 2,
      guardianOverride: false,
      engine: 'fake',
    );
  }
  await repo.finishSession(id: s, childId: id, endLevel: 2);
  await repo.saveStoryPage(id, 'c2', 1);
  scope.dispose();
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  setUpAll(loadFonts);

  for (final dark in [false, true]) {
    for (final entry in sizes.entries) {
      testWidgets('semua layar ${entry.key} ${dark ? 'gelap' : 'terang'}', (tester) async {
        final (size, font) = entry.value;
        tester.view.physicalSize = size * 2;
        tester.view.devicePixelRatio = 2;
        tester.platformDispatcher.platformBrightnessTestValue = dark ? Brightness.dark : Brightness.light;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

        final db = AppDatabase(NativeDatabase.memory());
        final content = (await tester.runAsync(() => Content.load(rootBundle)))!;
        await tester.runAsync(() => seed(db, content));
        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            contentProvider.overrideWithValue(content),
            recognizerProvider.overrideWithValue(FakeRecognizer(SpeechAvailability.ready)),
            speakerProvider.overrideWithValue(FakeSpeaker()),
          ],
        );
        addTearDown(container.dispose);
        final problems = <String>[];
        final previous = FlutterError.onError;
        String? current = 'awal';
        FlutterError.onError = (d) {
          final where = d.informationCollector?.call().map((e) => e.toString()).where((s) => s.contains('←')).firstOrNull ?? '';
          problems.add('$current: ${d.exceptionAsString().split('\n').first} ${where.length > 300 ? where.substring(0, 300) : where}');
        };
        await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const LenteraApp()));
        try {
          await settle(tester, 800);
          if (font != 1.0) {
            final repo = container.read(repositoryProvider);
            final child = (await tester.runAsync(() => repo.watchChildren().first))!.single;
            await tester.runAsync(() => repo.updateSettings(child.id, child.settings.copyWith(fontScale: font)));
            await settle(tester);
          }

          for (final route in routes) {
            current = route;
            container.read(routerProvider).go(route);
            await settle(tester, 900);
            await tester.pump(const Duration(seconds: 1));
            if (capture) {
              final name = '${entry.key}${dark ? '-dark' : ''}${route.replaceAll('/', '_')}';
              await expectLater(find.byType(MaterialApp), matchesGoldenFile('../build/screens/$name.png'));
            }
          }
        } finally {
          FlutterError.onError = previous;
        }
        await tester.pumpWidget(const SizedBox());
        await settle(tester);
        expect(problems, isEmpty, reason: problems.join('\n'));
      });
    }
  }
}
