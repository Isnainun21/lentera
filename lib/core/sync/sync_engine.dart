import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../db/repository.dart';

class SyncRejected implements Exception {
  const SyncRejected(this.reason);
  final String reason;
}

/// Port ke server. Implementasi nyata ada di supabase_gateway.dart.
abstract interface class SyncGateway {
  bool get signedIn;

  Future<void> push(String table, List<Map<String, dynamic>> rows);

  /// Baris dengan waktu server >= cursor, urut naik. Pengulangan aman karena penerapannya idempoten.
  Future<List<Map<String, dynamic>>> pull(String table, String? cursor);
}

enum SyncStatus { notConfigured, signedOut, idle, syncing, failed }

class SyncReport {
  const SyncReport(this.status, {this.pending = 0, this.lastSuccess, this.message});

  final SyncStatus status;
  final int pending;
  final DateTime? lastSuccess;
  final String? message;
}

class SyncEngine {
  SyncEngine({required this.repo, required this.gateway, DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  final Repository repo;
  final SyncGateway gateway;
  final DateTime Function() _now;
  bool _running = false;

  static const pullTables = [
    'children',
    'consents',
    'practice_sessions',
    'attempts',
    'level_events',
    'story_progress',
    'reward_events',
  ];

  AppDatabase get _db => repo.db;

  /// Melempar pengecualian saat jaringan gagal. Data tetap aman di outbox.
  Future<void> syncNow({bool force = false}) async {
    if (_running || !gateway.signedIn) return;
    _running = true;
    try {
      await _push(force: force);
      await _pull();
      await repo.writeKey('lastSync', _now().toUtc().toIso8601String());
      await repo.writeKey('lastSyncError', '');
    } catch (e) {
      await repo.writeKey('lastSyncError', e.toString());
      rethrow;
    } finally {
      _running = false;
    }
  }

  Future<void> _push({required bool force}) async {
    while (true) {
      final now = _now();
      final q = _db.select(_db.outbox)
        ..where((t) => t.rejectedReason.isNull())
        ..orderBy([(t) => OrderingTerm.asc(t.id)])
        ..limit(200);
      final pending = await q.get();
      if (pending.isEmpty) return;
      final first = pending.first;
      if (!force && first.nextRetryAt != null && first.nextRetryAt!.isAfter(now)) return;

      // Urutan dijaga dengan mengirim per kelompok tabel yang berurutan, agar relasi anak dan sesi selalu ada lebih dulu.
      final batch = pending.takeWhile((e) => e.targetTable == first.targetTable).toList();
      try {
        await gateway.push(first.targetTable, [for (final e in batch) jsonDecode(e.payload) as Map<String, dynamic>]);
      } on SyncRejected catch (e) {
        await (_db.update(_db.outbox)..where((t) => t.id.isIn(batch.map((b) => b.id))))
            .write(OutboxCompanion(rejectedReason: Value(e.reason)));
        continue;
      } catch (_) {
        final tries = first.tries + 1;
        final wait = Duration(seconds: (1 << tries.clamp(1, 10)) * 5);
        await (_db.update(_db.outbox)..where((t) => t.id.isIn(batch.map((b) => b.id))))
            .write(OutboxCompanion(tries: Value(tries), nextRetryAt: Value(now.add(wait))));
        rethrow;
      }
      await (_db.delete(_db.outbox)..where((t) => t.id.isIn(batch.map((b) => b.id)))).go();
    }
  }

  Future<void> _pull() async {
    for (final table in pullTables) {
      final key = 'cursor:$table';
      final rows = await gateway.pull(table, await repo.readKey(key));
      if (rows.isEmpty) continue;
      await _db.transaction(() async {
        for (final row in rows) {
          await _apply(table, row);
        }
        await repo.writeKey(key, rows.last['server_updated_at'] as String);
      });
    }
  }

  DateTime _date(Object? v) => DateTime.parse(v as String).toLocal();
  DateTime? _dateOrNull(Object? v) => v == null ? null : _date(v);

  Future<void> _apply(String table, Map<String, dynamic> r) async {
    // Anak yang sudah dihapus tidak boleh muncul lagi lewat baris lamanya.
    if (table != 'children') {
      final child = await (_db.select(_db.children)..where((t) => t.id.equals(r['child_id'] as String))).getSingleOrNull();
      if (child == null) return;
    }
    switch (table) {
      case 'children':
        if (r['deleted_at'] != null) {
          await repo.purgeChildLocally(r['id'] as String);
          return;
        }
        final updatedAt = _date(r['updated_at']);
        final local = await (_db.select(_db.children)..where((t) => t.id.equals(r['id'] as String))).getSingleOrNull();
        if (local != null && local.updatedAt.isAfter(updatedAt)) return;
        await _db.into(_db.children).insertOnConflictUpdate(ChildrenCompanion.insert(
              id: r['id'] as String,
              nickname: r['nickname'] as String,
              avatarId: r['avatar_id'] as int,
              settings: r['settings'] as String,
              updatedAt: updatedAt,
            ));
      case 'consents':
        await _db.into(_db.consents).insertOnConflictUpdate(ConsentsCompanion.insert(
              id: r['id'] as String,
              childId: r['child_id'] as String,
              version: r['version'] as String,
              grantedAt: _date(r['granted_at']),
              revokedAt: Value(_dateOrNull(r['revoked_at'])),
            ));
      case 'practice_sessions':
        await _db.into(_db.practiceSessions).insertOnConflictUpdate(PracticeSessionsCompanion.insert(
              id: r['id'] as String,
              childId: r['child_id'] as String,
              kind: r['kind'] as String,
              startLevel: r['start_level'] as int,
              endLevel: Value(r['end_level'] as int?),
              plannedWords: r['planned_words'] as int,
              startedAt: _date(r['started_at']),
              endedAt: Value(_dateOrNull(r['ended_at'])),
            ));
      case 'attempts':
        await _db.into(_db.attempts).insertOnConflictUpdate(AttemptsCompanion.insert(
              id: r['id'] as String,
              sessionId: r['session_id'] as String,
              childId: r['child_id'] as String,
              wordId: r['word_id'] as String,
              contentVersion: r['content_version'] as int,
              tryNumber: r['try_number'] as int,
              status: r['status'] as String,
              matchedSyllables: jsonEncode(r['matched_syllables']),
              confidence: Value((r['confidence'] as num?)?.toDouble()),
              engine: r['engine'] as String,
              finished: r['finished'] as bool,
              assisted: r['assisted'] as bool,
              guardianOverride: r['guardian_override'] as bool,
              occurredAt: _date(r['occurred_at']),
            ));
      case 'level_events':
        await _db.into(_db.levelEvents).insertOnConflictUpdate(LevelEventsCompanion.insert(
              id: r['id'] as String,
              childId: r['child_id'] as String,
              fromLevel: Value(r['from_level'] as int?),
              toLevel: r['to_level'] as int,
              reason: r['reason'] as String,
              actor: r['actor'] as String,
              occurredAt: _date(r['occurred_at']),
            ));
      case 'story_progress':
        final childId = r['child_id'] as String;
        final storyId = r['story_id'] as String;
        final local = await (_db.select(_db.storyProgress)
              ..where((t) => t.childId.equals(childId) & t.storyId.equals(storyId)))
            .getSingleOrNull();
        final remotePage = r['page'] as int;
        await _db.into(_db.storyProgress).insertOnConflictUpdate(StoryProgressCompanion.insert(
              childId: childId,
              storyId: storyId,
              page: local != null && local.page > remotePage ? local.page : remotePage,
              completedAt: Value(local?.completedAt ?? _dateOrNull(r['completed_at'])),
              updatedAt: _date(r['updated_at']),
            ));
      case 'reward_events':
        await _db.into(_db.rewardEvents).insert(
              RewardEventsCompanion.insert(
                id: r['id'] as String,
                childId: r['child_id'] as String,
                kind: r['kind'] as String,
                sourceId: r['source_id'] as String,
                occurredAt: _date(r['occurred_at']),
              ),
              mode: InsertMode.insertOrIgnore,
            );
    }
  }
}
