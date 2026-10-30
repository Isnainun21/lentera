import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/child.dart';
import '../../domain/practice/models.dart';
import '../../domain/progress/stats.dart';
import 'database.dart';

const consentVersion = '2026-10-v1';

/// Pintu tunggal ke database lokal. Setiap perubahan yang perlu sinkron ditulis
/// ke tabelnya dan ke outbox dalam satu transaksi.
class Repository {
  Repository(this.db, {DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final DateTime Function() _now;
  static const _uuid = Uuid();

  Future<void> _enqueue(String table, Map<String, Object?> row) =>
      db.into(db.outbox).insert(OutboxCompanion.insert(targetTable: table, payload: jsonEncode(row)));

  String _ts(DateTime t) => t.toUtc().toIso8601String();

  // Kunci dan nilai

  Future<String?> readKey(String key) async =>
      (await (db.select(db.keyValues)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> writeKey(String key, String value) =>
      db.into(db.keyValues).insertOnConflictUpdate(KeyValuesCompanion.insert(key: key, value: value));

  Stream<String?> watchKey(String key) =>
      (db.select(db.keyValues)..where((t) => t.key.equals(key))).watchSingleOrNull().map((r) => r?.value);

  // PIN pendamping

  String _hashPin(String pin, String salt) => sha256.convert(utf8.encode('$salt:$pin')).toString();

  Future<void> setPin(String pin) async {
    final salt = _uuid.v4();
    await writeKey('pinSalt', salt);
    await writeKey('pinHash', _hashPin(pin, salt));
  }

  Future<bool> hasPin() async => await readKey('pinHash') != null;

  Future<bool> checkPin(String pin) async {
    final salt = await readKey('pinSalt');
    final hash = await readKey('pinHash');
    return salt != null && hash != null && _hashPin(pin, salt) == hash;
  }

  // Anak

  Future<String> createChild({required String nickname, required int avatarId, required int startLevel}) async {
    final id = _uuid.v4();
    final now = _now();
    const settings = ChildSettings();
    await db.transaction(() async {
      await db.into(db.children).insert(ChildrenCompanion.insert(
            id: id,
            nickname: nickname,
            avatarId: avatarId,
            settings: settings.encode(),
            updatedAt: now,
          ));
      await _enqueue('children', {
        'id': id,
        'nickname': nickname,
        'avatar_id': avatarId,
        'settings': settings.encode(),
        'updated_at': _ts(now),
      });
      await _grantConsent(id, now);
      await _addLevelEvent(id, null, startLevel, 'start', 'guardian', now);
    });
    await writeKey('activeChild', id);
    return id;
  }

  /// Masuk dengan nama panggilan, tanpa membedakan huruf besar. Null berarti nama belum terdaftar.
  Future<String?> signInByName(String name) async {
    final wanted = name.trim().toLowerCase();
    final rows = await (db.select(db.children)..where((t) => t.deletedAt.isNull())).get();
    for (final r in rows) {
      if (r.nickname.trim().toLowerCase() == wanted) {
        await writeKey('activeChild', r.id);
        return r.id;
      }
    }
    return null;
  }

  Future<void> signOutChild() => (db.delete(db.keyValues)..where((t) => t.key.equals('activeChild'))).go();

  Future<bool> nameTaken(String name) async {
    final wanted = name.trim().toLowerCase();
    final rows = await (db.select(db.children)..where((t) => t.deletedAt.isNull())).get();
    return rows.any((r) => r.nickname.trim().toLowerCase() == wanted);
  }

  Future<void> _grantConsent(String childId, DateTime now) async {
    final id = _uuid.v4();
    await db.into(db.consents).insert(
        ConsentsCompanion.insert(id: id, childId: childId, version: consentVersion, grantedAt: now));
    await _enqueue('consents', {'id': id, 'child_id': childId, 'version': consentVersion, 'granted_at': _ts(now)});
  }

  Future<void> _addLevelEvent(String childId, int? from, int to, String reason, String actor, DateTime at) async {
    final id = _uuid.v4();
    await db.into(db.levelEvents).insert(LevelEventsCompanion.insert(
          id: id,
          childId: childId,
          fromLevel: Value(from),
          toLevel: to,
          reason: reason,
          actor: actor,
          occurredAt: at,
        ));
    await _enqueue('level_events', {
      'id': id,
      'child_id': childId,
      'from_level': from,
      'to_level': to,
      'reason': reason,
      'actor': actor,
      'occurred_at': _ts(at),
    });
  }

  Future<int> currentLevel(String childId) async {
    final events = await (db.select(db.levelEvents)..where((t) => t.childId.equals(childId))).get();
    if (events.isEmpty) return 1;
    // Dibandingkan sebagai waktu, karena baris sinkron bisa berasal dari zona waktu lain.
    events.sort((x, y) => x.occurredAt.compareTo(y.occurredAt));
    return events.last.toLevel;
  }

  Stream<List<ChildProfile>> watchChildren() => db
      .customSelect('SELECT 1', readsFrom: {db.children, db.levelEvents})
      .watch()
      .asyncMap((_) async {
        final rows = await (db.select(db.children)..where((t) => t.deletedAt.isNull())).get();
        return [
          for (final r in rows)
            ChildProfile(
              id: r.id,
              nickname: r.nickname,
              avatarId: r.avatarId,
              settings: ChildSettings.decode(r.settings),
              level: await currentLevel(r.id),
            ),
        ];
      });

  Stream<int> watchPendingSync() =>
      (db.select(db.outbox)..where((t) => t.rejectedReason.isNull())).watch().map((r) => r.length);

  Future<void> updateSettings(String childId, ChildSettings settings) async {
    final now = _now();
    await db.transaction(() async {
      await (db.update(db.children)..where((t) => t.id.equals(childId)))
          .write(ChildrenCompanion(settings: Value(settings.encode()), updatedAt: Value(now)));
      final row = await (db.select(db.children)..where((t) => t.id.equals(childId))).getSingle();
      await _enqueue('children', {
        'id': childId,
        'nickname': row.nickname,
        'avatar_id': row.avatarId,
        'settings': settings.encode(),
        'updated_at': _ts(now),
      });
    });
  }

  Future<void> setLevelByGuardian(String childId, int level) async {
    final from = await currentLevel(childId);
    if (from == level) return;
    await db.transaction(() => _addLevelEvent(childId, from, level, 'manual', 'guardian', _now()));
  }

  /// Penghapusan tercatat ke server dulu, lalu semua data anak di perangkat dihapus.
  Future<void> deleteChild(String childId) async {
    final now = _now();
    await db.transaction(() async {
      final row = await (db.select(db.children)..where((t) => t.id.equals(childId))).getSingle();
      await _enqueue('children', {
        'id': childId,
        'nickname': row.nickname,
        'avatar_id': row.avatarId,
        'settings': row.settings,
        'updated_at': _ts(now),
        'deleted_at': _ts(now),
      });
      await purgeChildLocally(childId);
    });
    if (await readKey('activeChild') == childId) {
      await (db.delete(db.keyValues)..where((t) => t.key.equals('activeChild'))).go();
    }
  }

  Future<void> purgeChildLocally(String childId) async {
    await (db.delete(db.attempts)..where((t) => t.childId.equals(childId))).go();
    await (db.delete(db.practiceSessions)..where((t) => t.childId.equals(childId))).go();
    await (db.delete(db.levelEvents)..where((t) => t.childId.equals(childId))).go();
    await (db.delete(db.storyProgress)..where((t) => t.childId.equals(childId))).go();
    await (db.delete(db.rewardEvents)..where((t) => t.childId.equals(childId))).go();
    await (db.delete(db.consents)..where((t) => t.childId.equals(childId))).go();
    await (db.delete(db.children)..where((t) => t.id.equals(childId))).go();
  }

  Future<void> resetDevice() async {
    await db.transaction(() async {
      for (final table in db.allTables) {
        await db.delete(table).go();
      }
    });
  }

  // Sesi

  Future<ResumableSession?> openSession(String childId, String kind) async {
    final q = db.select(db.practiceSessions)
      ..where((t) => t.childId.equals(childId) & t.kind.equals(kind) & t.endedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      ..limit(1);
    final row = await q.getSingleOrNull();
    if (row == null) return null;
    final attempts = await (db.select(db.attempts)..where((t) => t.sessionId.equals(row.id))).get();
    final done = attempts.where((a) => a.finished).map((a) => a.wordId).toSet();
    final correct = attempts.where((a) => a.finished && a.status == AttemptStatus.correct.name).length;
    if (done.isEmpty) return null;
    return ResumableSession(id: row.id, planned: row.plannedWords, doneWords: done, correctWords: correct);
  }

  Stream<bool> watchHasOpenSession(String childId) {
    final q = db.select(db.practiceSessions)
      ..where((t) => t.childId.equals(childId) & t.kind.equals('reading') & t.endedAt.isNull());
    return q.watch().asyncMap((_) async => await openSession(childId, 'reading') != null);
  }

  Future<void> discardSession(String id) async {
    final now = _now();
    await _closeSession(id, null, now);
  }

  Future<String> startSession({required String childId, required String kind, required int level, required int planned}) async {
    final id = _uuid.v4();
    final now = _now();
    await db.transaction(() async {
      await db.into(db.practiceSessions).insert(PracticeSessionsCompanion.insert(
            id: id,
            childId: childId,
            kind: kind,
            startLevel: level,
            plannedWords: planned,
            startedAt: now,
          ));
      await _enqueue('practice_sessions', {
        'id': id,
        'child_id': childId,
        'kind': kind,
        'start_level': level,
        'planned_words': planned,
        'started_at': _ts(now),
      });
    });
    return id;
  }

  Future<void> saveAttempt({
    required String sessionId,
    required String childId,
    required String wordId,
    required int contentVersion,
    required int tryNumber,
    required AttemptStatus status,
    required List<int> matched,
    required bool finished,
    required bool assisted,
    required bool guardianOverride,
    required String engine,
    double? confidence,
  }) async {
    final id = _uuid.v4();
    final now = _now();
    await db.transaction(() async {
      await db.into(db.attempts).insert(AttemptsCompanion.insert(
            id: id,
            sessionId: sessionId,
            childId: childId,
            wordId: wordId,
            contentVersion: contentVersion,
            tryNumber: tryNumber,
            status: status.name,
            matchedSyllables: jsonEncode(matched),
            confidence: Value(confidence),
            engine: engine,
            finished: finished,
            assisted: assisted,
            guardianOverride: guardianOverride,
            occurredAt: now,
          ));
      await _enqueue('attempts', {
        'id': id,
        'session_id': sessionId,
        'child_id': childId,
        'word_id': wordId,
        'content_version': contentVersion,
        'try_number': tryNumber,
        'status': status.name,
        'matched_syllables': matched,
        'confidence': confidence,
        'engine': engine,
        'finished': finished,
        'assisted': assisted,
        'guardian_override': guardianOverride,
        'occurred_at': _ts(now),
      });
    });
  }

  Future<void> saveLevelChange(String childId, int from, int to) =>
      db.transaction(() => _addLevelEvent(childId, from, to, 'adaptive', 'system', _now()));

  Future<void> _closeSession(String id, int? endLevel, DateTime now) async {
    await (db.update(db.practiceSessions)..where((t) => t.id.equals(id)))
        .write(PracticeSessionsCompanion(endedAt: Value(now), endLevel: Value(endLevel)));
    final row = await (db.select(db.practiceSessions)..where((t) => t.id.equals(id))).getSingle();
    await _enqueue('practice_sessions', {
      'id': id,
      'child_id': row.childId,
      'kind': row.kind,
      'start_level': row.startLevel,
      'end_level': endLevel,
      'planned_words': row.plannedWords,
      'started_at': _ts(row.startedAt),
      'ended_at': _ts(now),
    });
  }

  Future<void> finishSession({required String id, required String childId, required int endLevel}) async {
    final now = _now();
    await db.transaction(() async {
      await _closeSession(id, endLevel, now);
      await _grantReward(childId, 'session', id, now);
      await _grantMilestones(childId, now);
    });
  }

  // Hadiah

  Future<void> _grantReward(String childId, String kind, String sourceId, DateTime now) async {
    final exists = await (db.select(db.rewardEvents)
          ..where((t) => t.childId.equals(childId) & t.kind.equals(kind) & t.sourceId.equals(sourceId)))
        .getSingleOrNull();
    if (exists != null) return;
    final id = _uuid.v4();
    await db.into(db.rewardEvents).insert(
        RewardEventsCompanion.insert(id: id, childId: childId, kind: kind, sourceId: sourceId, occurredAt: now));
    await _enqueue('reward_events', {
      'id': id,
      'child_id': childId,
      'kind': kind,
      'source_id': sourceId,
      'occurred_at': _ts(now),
    });
  }

  Future<void> _grantMilestones(String childId, DateTime now) async {
    final results = ProgressStats.wordResults(await attemptRecords(childId));
    final learned = results.where((r) => r.counted && r.wordId.startsWith('l')).map((r) => r.wordId).toSet().length;
    for (final goal in const [10, 25, 50]) {
      if (learned >= goal) await _grantReward(childId, 'words', '$goal', now);
    }
    final ended = await (db.select(db.practiceSessions)
          ..where((t) => t.childId.equals(childId) & t.endedAt.isNotNull()))
        .get();
    final days = ended.map((s) {
      final e = s.endedAt!;
      return DateTime(e.year, e.month, e.day);
    }).toSet();
    for (final goal in const [3, 7, 30]) {
      if (days.length >= goal) await _grantReward(childId, 'days', '$goal', now);
    }
  }

  Stream<List<RewardEvent>> watchRewards(String childId) =>
      (db.select(db.rewardEvents)..where((t) => t.childId.equals(childId))).watch();

  // Cerita

  Stream<List<StoryProgressData>> watchStoryProgress(String childId) =>
      (db.select(db.storyProgress)..where((t) => t.childId.equals(childId))).watch();

  Future<void> saveStoryPage(String childId, String storyId, int page, {bool completed = false}) async {
    final now = _now();
    await db.transaction(() async {
      final current = await (db.select(db.storyProgress)
            ..where((t) => t.childId.equals(childId) & t.storyId.equals(storyId)))
          .getSingleOrNull();
      final farthest = current == null || page > current.page ? page : current.page;
      final completedAt = completed ? (current?.completedAt ?? now) : current?.completedAt;
      await db.into(db.storyProgress).insertOnConflictUpdate(StoryProgressCompanion.insert(
            childId: childId,
            storyId: storyId,
            page: farthest,
            completedAt: Value(completedAt),
            updatedAt: now,
          ));
      await _enqueue('story_progress', {
        'child_id': childId,
        'story_id': storyId,
        'page': farthest,
        'completed_at': completedAt == null ? null : _ts(completedAt),
        'updated_at': _ts(now),
      });
      if (completed) await _grantReward(childId, 'story', storyId, now);
    });
  }

  // Bacaan statistik

  Future<List<AttemptRecord>> attemptRecords(String childId) async {
    final rows = await (db.select(db.attempts)..where((t) => t.childId.equals(childId))).get();
    return rows.map(_record).toList();
  }

  AttemptRecord _record(Attempt a) => AttemptRecord(
        sessionId: a.sessionId,
        wordId: a.wordId,
        tryNumber: a.tryNumber,
        status: AttemptStatus.values.byName(a.status),
        finished: a.finished,
        assisted: a.assisted,
        occurredAt: a.occurredAt,
      );

  Stream<List<AttemptRecord>> watchAttempts(String childId) =>
      (db.select(db.attempts)..where((t) => t.childId.equals(childId))).watch().map((r) => r.map(_record).toList());

  Stream<List<PracticeSession>> watchSessions(String childId) => (db.select(db.practiceSessions)
        ..where((t) => t.childId.equals(childId))
        ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
      .watch();

  Stream<List<Attempt>> watchSessionAttempts(String sessionId) => (db.select(db.attempts)
        ..where((t) => t.sessionId.equals(sessionId))
        ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
      .watch();
}

/// Sesi lama yang belum selesai dan bisa dilanjutkan.
class ResumableSession {
  const ResumableSession({required this.id, required this.planned, required this.doneWords, required this.correctWords});

  final String id;
  final int planned;
  final Set<String> doneWords;
  final int correctWords;
}
