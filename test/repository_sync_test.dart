import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side/content/content.dart';
import 'package:side/core/db/database.dart';
import 'package:side/core/db/repository.dart';
import 'package:side/core/sync/sync_engine.dart';
import 'package:side/domain/child.dart';
import 'package:side/domain/practice/models.dart';
import 'package:side/features/guardian/guardian_screens.dart';
import 'package:side/features/guardian/report.dart';

class FakeGateway implements SyncGateway {
  final tables = <String, List<Map<String, dynamic>>>{};
  bool failing = false;
  String? rejectTable;
  int clock = 0;

  String _key(String table, Map<String, dynamic> r) =>
      table == 'story_progress' ? '${r['child_id']}${r['story_id']}' : r['id'] as String;

  @override
  bool get signedIn => true;

  @override
  Future<void> push(String table, List<Map<String, dynamic>> rows) async {
    if (failing) throw Exception('offline');
    if (table == rejectTable) throw const SyncRejected('rls');
    final list = tables.putIfAbsent(table, () => []);
    for (final r in rows) {
      final old = list.where((e) => _key(table, e) == _key(table, r)).firstOrNull;
      list.removeWhere((e) => _key(table, e) == _key(table, r));
      clock++;
      final merged = {...r, 'server_updated_at': DateTime.utc(2026, 1, 1, 0, 0, clock).toIso8601String()};
      // Sama dengan pemicu resolve_story_conflict di server.
      if (table == 'story_progress' && old != null && (old['page'] as int) > (r['page'] as int)) {
        merged['page'] = old['page'];
      }
      list.add(merged);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> pull(String table, String? cursor) async => (tables[table] ?? [])
      .where((r) => cursor == null || (r['server_updated_at'] as String).compareTo(cursor) >= 0)
      .toList()
    ..sort((a, b) => (a['server_updated_at'] as String).compareTo(b['server_updated_at'] as String));
}

Repository newRepo() => Repository(AppDatabase(NativeDatabase.memory()));

Future<void> attempt(Repository r, String session, String child, String word, AttemptStatus status) => r.saveAttempt(
      sessionId: session,
      childId: child,
      wordId: word,
      contentVersion: 1,
      tryNumber: 1,
      status: status,
      matched: const [0],
      finished: true,
      assisted: status != AttemptStatus.correct,
      guardianOverride: false,
      engine: 'fake',
    );

Future<void> playSession(Repository r, String child) async {
  final s = await r.startSession(childId: child, kind: 'reading', level: 1, planned: 1);
  await attempt(r, s, child, 'l1-1', AttemptStatus.correct);
  await r.saveLevelChange(child, 1, 2);
  await r.finishSession(id: s, childId: child, endLevel: 2);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('PIN disimpan sebagai hash dan bisa diperiksa', () async {
    final r = newRepo();
    await r.setPin('1234');
    expect(await r.readKey('pinHash'), isNot('1234'));
    expect(await r.checkPin('1234'), isTrue);
    expect(await r.checkPin('9999'), isFalse);
  });

  test('profil, level dari event, sesi bisa dilanjutkan, dan hadiah tidak ganda', () async {
    final r = newRepo();
    final c = await r.createChild(nickname: 'Bima', avatarId: 0, startLevel: 2);
    expect(await r.currentLevel(c), 2);
    expect((await r.watchChildren().first).single.level, 2);

    final s = await r.startSession(childId: c, kind: 'reading', level: 2, planned: 3);
    expect(await r.openSession(c, 'reading'), isNull);
    await attempt(r, s, c, 'l2-1', AttemptStatus.correct);
    expect((await r.openSession(c, 'reading'))!.doneWords, {'l2-1'});

    await r.finishSession(id: s, childId: c, endLevel: 2);
    await r.finishSession(id: s, childId: c, endLevel: 2);
    expect((await r.watchRewards(c).first).where((e) => e.kind == 'session').length, 1);
    expect(await r.openSession(c, 'reading'), isNull);
  });

  test('pengaturan tersimpan dan penghapusan membersihkan semua data anak', () async {
    final r = newRepo();
    final c = await r.createChild(nickname: 'Dina', avatarId: 1, startLevel: 1);
    await r.updateSettings(c, const ChildSettings(fontScale: 1.4));
    expect((await r.watchChildren().first).single.settings.fontScale, 1.4);
    await playSession(r, c);
    await r.deleteChild(c);
    expect(await r.attemptRecords(c), isEmpty);
    expect(await r.watchChildren().first, isEmpty);
    expect(await r.readKey('activeChild'), isNull);
    final last = (await r.db.select(r.db.outbox).get()).last;
    expect(last.targetTable, 'children');
    expect(last.payload, contains('deleted_at'));
  });

  group('SyncEngine', () {
    test('luring lalu daring: outbox terkirim sekali, tanpa duplikat', () async {
      final r = newRepo();
      final g = FakeGateway()..failing = true;
      final e = SyncEngine(repo: r, gateway: g);
      final c = await r.createChild(nickname: 'Bima', avatarId: 0, startLevel: 1);
      await playSession(r, c);

      await expectLater(e.syncNow(), throwsException);
      expect(await r.watchPendingSync().first, greaterThan(0));
      expect(await r.readKey('lastSyncError'), contains('offline'));

      g.failing = false;
      await e.syncNow(force: true);
      expect(await r.watchPendingSync().first, 0);
      expect(g.tables['attempts']!.length, 1);
      expect(g.tables['children']!.length, 1);

      await e.syncNow(force: true);
      expect(g.tables['attempts']!.length, 1);
      expect((await r.attemptRecords(c)).length, 1);
    });

    test('dua perangkat bergabung tanpa duplikat, dan level terbaru dipakai', () async {
      final g = FakeGateway();
      final a = newRepo();
      final b = newRepo();
      final ea = SyncEngine(repo: a, gateway: g);
      final eb = SyncEngine(repo: b, gateway: g);
      final c = await a.createChild(nickname: 'Bima', avatarId: 0, startLevel: 1);
      await ea.syncNow(force: true);
      await eb.syncNow(force: true);
      expect((await b.watchChildren().first).single.nickname, 'Bima');

      await playSession(a, c);
      final s = await b.startSession(childId: c, kind: 'reading', level: 1, planned: 1);
      await attempt(b, s, c, 'l1-2', AttemptStatus.wrong);

      await ea.syncNow(force: true);
      await eb.syncNow(force: true);
      await ea.syncNow(force: true);
      expect((await a.attemptRecords(c)).length, 2);
      expect((await b.attemptRecords(c)).length, 2);
      expect(await b.currentLevel(c), 2);
    });

    test('penghapusan dari perangkat lain menghapus data lokal', () async {
      final g = FakeGateway();
      final a = newRepo();
      final b = newRepo();
      final ea = SyncEngine(repo: a, gateway: g);
      final eb = SyncEngine(repo: b, gateway: g);
      final c = await a.createChild(nickname: 'Bima', avatarId: 0, startLevel: 1);
      await playSession(a, c);
      await ea.syncNow(force: true);
      await eb.syncNow(force: true);
      await a.deleteChild(c);
      await ea.syncNow(force: true);
      await eb.syncNow(force: true);
      expect(await b.watchChildren().first, isEmpty);
      expect(await b.attemptRecords(c), isEmpty);
    });

    test('halaman cerita terjauh menang', () async {
      final g = FakeGateway();
      final a = newRepo();
      final b = newRepo();
      final ea = SyncEngine(repo: a, gateway: g);
      final eb = SyncEngine(repo: b, gateway: g);
      final c = await a.createChild(nickname: 'Bima', avatarId: 0, startLevel: 1);
      await ea.syncNow(force: true);
      await eb.syncNow(force: true);
      await a.saveStoryPage(c, 'c1', 2);
      await ea.syncNow(force: true);
      await b.saveStoryPage(c, 'c1', 0);
      await eb.syncNow(force: true);
      expect((await b.watchStoryProgress(c).first).single.page, 2);
    });

    test('baris yang ditolak server tidak memblokir antrean', () async {
      final r = newRepo();
      final g = FakeGateway()..rejectTable = 'consents';
      final e = SyncEngine(repo: r, gateway: g);
      await r.createChild(nickname: 'Bima', avatarId: 0, startLevel: 1);
      await e.syncNow(force: true);
      expect(g.tables['level_events']!.length, 1);
      expect(await r.watchPendingSync().first, 0);
    });
  });

  test('laporan PDF terbentuk dari data yang sama dengan layar', () async {
    final r = newRepo();
    final c = await r.createChild(nickname: 'Bima', avatarId: 0, startLevel: 1);
    await playSession(r, c);
    const content = Content(
      version: 1,
      words: [Word(id: 'l1-1', text: 'BA', level: 1, syllables: ['BA'])],
      stories: [],
      letters: [],
    );
    final now = DateTime.now();
    final summary = ChildSummary(await r.attemptRecords(c), await r.watchSessions(c).first, content, now);
    expect(summary.wordsThisWeek, 1);
    expect(summary.accuracy, isNull);
    final profile = (await r.watchChildren().first).single;
    final bytes = await buildReport(profile, summary, now);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
