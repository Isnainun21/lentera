import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Children extends Table {
  TextColumn get id => text()();
  TextColumn get nickname => text()();
  IntColumn get avatarId => integer()();
  TextColumn get settings => text()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Consents extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get version => text()();
  DateTimeColumn get grantedAt => dateTime()();
  DateTimeColumn get revokedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PracticeSessions extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get kind => text()();
  IntColumn get startLevel => integer()();
  IntColumn get endLevel => integer().nullable()();
  IntColumn get plannedWords => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Attempts extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get childId => text()();
  TextColumn get wordId => text()();
  IntColumn get contentVersion => integer()();
  IntColumn get tryNumber => integer()();
  TextColumn get status => text()();
  TextColumn get matchedSyllables => text()();
  RealColumn get confidence => real().nullable()();
  TextColumn get engine => text()();
  BoolColumn get finished => boolean()();
  BoolColumn get assisted => boolean()();
  BoolColumn get guardianOverride => boolean()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LevelEvents extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  IntColumn get fromLevel => integer().nullable()();
  IntColumn get toLevel => integer()();
  TextColumn get reason => text()();
  TextColumn get actor => text()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class StoryProgress extends Table {
  TextColumn get childId => text()();
  TextColumn get storyId => text()();
  IntColumn get page => integer()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {childId, storyId};
}

class RewardEvents extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get kind => text()();
  TextColumn get sourceId => text()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {childId, kind, sourceId},
      ];
}

class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTable => text()();
  TextColumn get payload => text()();
  IntColumn get tries => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  TextColumn get rejectedReason => text().nullable()();
}

class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  Children,
  Consents,
  PracticeSessions,
  Attempts,
  LevelEvents,
  StoryProgress,
  RewardEvents,
  Outbox,
  KeyValues,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'lentera'));

  @override
  int get schemaVersion => 1;
}
