import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side/app/app.dart';
import 'package:side/app/providers.dart';
import 'package:side/content/content.dart';
import 'package:side/core/db/database.dart';
import 'package:side/core/speech/speech_ports.dart';
import 'package:side/domain/practice/models.dart';

class FakeRecognizer implements SpeechRecognizer {
  FakeRecognizer(this.availability);

  final SpeechAvailability availability;
  List<String> script = [];

  @override
  String get engineName => 'fake';
  @override
  Future<SpeechAvailability> prepare() async => availability;
  @override
  Future<SpeechHearing> listen() async => SpeechHearing(script.isEmpty ? '' : script.removeAt(0));
  @override
  Future<void> stop() async {}
}

class FakeSpeaker implements Speaker {
  @override
  Future<void> speak(String text, {double rate = 0.4, void Function(int start, int end)? onWord}) async {}
  @override
  Future<void> stop() async {}
}

Future<AppDatabase> pumpApp(WidgetTester tester, FakeRecognizer rec, {Size size = const Size(390, 844)}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final database = AppDatabase(NativeDatabase.memory());
  final content = await tester.runAsync(() => Content.load(rootBundle));
  await tester.pumpWidget(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
      contentProvider.overrideWithValue(content!),
      recognizerProvider.overrideWithValue(rec),
      speakerProvider.overrideWithValue(FakeSpeaker()),
    ],
    child: const LenteraApp(),
  ));
  return database;
}

/// Drift memakai waktu nyata, jadi tes bergantian antara waktu nyata dan frame.
Future<void> settle(WidgetTester tester, [int ms = 300]) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration(milliseconds: ms ~/ 5)));
    await tester.pump(const Duration(milliseconds: 500));
  }
}

Future<void> tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder.first);
  await tester.pump();
  await tester.tap(finder.first);
  await settle(tester);
}

Future<void> enterPin(WidgetTester tester, String pin) async {
  for (final d in pin.split('')) {
    final key = find.byKey(ValueKey('pin-$d'));
    await tester.ensureVisible(key);
    await tester.pump();
    await tester.tap(key);
    await tester.pump();
  }
  await settle(tester);
}

Future<void> completeSetup(WidgetTester tester) async {
  await settle(tester, 1500);
  expect(find.text('Untuk orang tua atau wali'), findsOneWidget);
  await tester.scrollUntilVisible(find.byType(Checkbox), 200, scrollable: find.byType(Scrollable).first);
  await tester.pump();
  await tester.tap(find.byType(Checkbox));
  await tester.pump();
  await tapText(tester, 'Setuju dan lanjut');
  expect(find.text('Buat PIN pendamping'), findsOneWidget);
  await enterPin(tester, '1234');
  expect(find.text('Ulangi PIN'), findsOneWidget);
  await enterPin(tester, '1234');
  await tester.enterText(find.byType(TextField), 'Bima');
  await tester.pump();
  await tapText(tester, 'Buat profil');
  await tapText(tester, 'Izinkan mikrofon');
  await settle(tester, 500);
}

Future<void> finish(WidgetTester tester, AppDatabase db) async {
  // Database memori ikut hilang bersama proses tes. Menutupnya saat stream drift masih aktif membuat tes menggantung.
  await tester.pumpWidget(const SizedBox());
  await settle(tester);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('dari pengaturan awal sampai satu sesi selesai dan tersimpan', (tester) async {
    final rec = FakeRecognizer(SpeechAvailability.ready);
    final db = await pumpApp(tester, rec);
    await completeSetup(tester);
    expect(find.text('Halo, Bima'), findsOneWidget);

    await tapText(tester, 'Mulai Baca');
    await settle(tester, 500);
    expect(find.text('1 dari 6'), findsOneWidget);

    // Kata pertama: dua kali belum tepat, lalu dibantu dan tetap bisa lanjut.
    rec.script = ['zzz'];
    await tester.tap(find.byIcon(Icons.mic_rounded));
    await settle(tester);
    expect(find.text('Coba lagi'), findsOneWidget);
    await tapText(tester, 'Coba lagi');
    rec.script = ['zzz'];
    await tester.tap(find.byIcon(Icons.mic_rounded));
    await settle(tester);
    expect(find.text('Kita baca bersama. Dengarkan, lalu lanjut.'), findsOneWidget);
    await tapText(tester, 'Kata berikutnya');

    // Sisanya benar: ucapan mengikuti kata yang tampil.
    final words = (await tester.runAsync(() => Content.load(rootBundle)))!.words.toList()
      ..sort((a, b) => b.text.length.compareTo(a.text.length));
    for (var i = 2; i <= 6; i++) {
      expect(find.text('$i dari 6'), findsOneWidget);
      final shown = words.firstWhere((w) => find.text(w.text, findRichText: true).evaluate().isNotEmpty);
      rec.script = [shown.text];
      await tester.tap(find.byIcon(Icons.mic_rounded));
      await settle(tester);
      expect(find.text('Terbaca dengan baik.'), findsOneWidget);
      await tapText(tester, i == 6 ? 'Selesai' : 'Kata berikutnya');
    }
    await settle(tester, 600);
    expect(find.text('Sesi selesai'), findsOneWidget);

    final attempts = await tester.runAsync(() => db.select(db.attempts).get());
    expect(attempts!.where((a) => a.finished).length, 6);
    final sessions = await tester.runAsync(() => db.select(db.practiceSessions).get());
    expect(sessions!.single.endedAt, isNotNull);
    expect(sessions.single.endLevel, greaterThan(1));
    await finish(tester, db);
  });

  testWidgets('keluar, nama salah ditolak, lalu masuk lagi dengan nama', (tester) async {
    final db = await pumpApp(tester, FakeRecognizer(SpeechAvailability.ready));
    await completeSetup(tester);
    await tester.tap(find.bySemanticsLabel('Akun Bima'));
    await settle(tester);
    await tapText(tester, 'Keluar');
    await settle(tester, 500);
    expect(find.text('Siapa namamu?'), findsOneWidget);
    expect(find.text('Halo, Bima'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Rani');
    await tester.pump();
    await tapText(tester, 'Masuk');
    expect(find.text('Nama ini belum terdaftar. Minta pendamping membuatkan profil.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bima');
    await tester.pump();
    await tapText(tester, 'Masuk');
    await settle(tester, 500);
    expect(find.text('Halo, Bima'), findsOneWidget);
    await finish(tester, db);
  });

  testWidgets('tanpa mikrofon, latihan memakai dengar dan pilih', (tester) async {
    final db = await pumpApp(tester, FakeRecognizer(SpeechAvailability.noPermission));
    await completeSetup(tester);
    await tapText(tester, 'Mulai Baca');
    await settle(tester, 500);
    expect(find.text('Mana kata yang kamu dengar?'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsNothing);
    await finish(tester, db);
  });

  testWidgets('area pendamping butuh PIN dan tidak mengarang angka', (tester) async {
    final db = await pumpApp(tester, FakeRecognizer(SpeechAvailability.ready));
    await completeSetup(tester);
    final short = await tester.startGesture(tester.getCenter(find.byIcon(Icons.lock_outline_rounded)));
    await tester.pump(const Duration(seconds: 1));
    await short.up();
    await settle(tester);
    expect(find.text('Masukkan PIN'), findsNothing);

    final hold = await tester.startGesture(tester.getCenter(find.byIcon(Icons.lock_outline_rounded)));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 3));
    await hold.up();
    await settle(tester);
    expect(find.text('Masukkan PIN'), findsOneWidget);
    await enterPin(tester, '9999');
    expect(find.text('PIN belum tepat.'), findsOneWidget);
    await enterPin(tester, '1234');
    await settle(tester, 500);
    expect(find.text('0 kata'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Dibanding minggu lalu'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pump();
    expect(find.text('Belum cukup data'), findsWidgets);
    await finish(tester, db);
  });

  testWidgets('layar tidak overflow pada layar kecil dan huruf terbesar', (tester) async {
    final db = await pumpApp(tester, FakeRecognizer(SpeechAvailability.ready), size: const Size(320, 568));
    await completeSetup(tester);
    final repo = ProviderScope.containerOf(tester.element(find.text('Halo, Bima'))).read(repositoryProvider);
    final child = (await tester.runAsync(() => repo.watchChildren().first))!.single;
    await tester.runAsync(() => repo.updateSettings(child.id, child.settings.copyWith(fontScale: 1.6)));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Mulai Baca'), 200, scrollable: find.byType(Scrollable).first);
    await tapText(tester, 'Mulai Baca');
    await settle(tester, 500);
    expect(tester.takeException(), isNull);
    await finish(tester, db);
  });
}
