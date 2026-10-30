// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ChildrenTable extends Children
    with TableInfo<$ChildrenTable, ChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<int> avatarId = GeneratedColumn<int>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingsMeta = const VerificationMeta(
    'settings',
  );
  @override
  late final GeneratedColumn<String> settings = GeneratedColumn<String>(
    'settings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nickname,
    avatarId,
    settings,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildrenData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarIdMeta);
    }
    if (data.containsKey('settings')) {
      context.handle(
        _settingsMeta,
        settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta),
      );
    } else if (isInserting) {
      context.missing(_settingsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildrenData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avatar_id'],
      )!,
      settings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }
}

class ChildrenData extends DataClass implements Insertable<ChildrenData> {
  final String id;
  final String nickname;
  final int avatarId;
  final String settings;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ChildrenData({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.settings,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nickname'] = Variable<String>(nickname);
    map['avatar_id'] = Variable<int>(avatarId);
    map['settings'] = Variable<String>(settings);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      nickname: Value(nickname),
      avatarId: Value(avatarId),
      settings: Value(settings),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ChildrenData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildrenData(
      id: serializer.fromJson<String>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarId: serializer.fromJson<int>(json['avatarId']),
      settings: serializer.fromJson<String>(json['settings']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nickname': serializer.toJson<String>(nickname),
      'avatarId': serializer.toJson<int>(avatarId),
      'settings': serializer.toJson<String>(settings),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ChildrenData copyWith({
    String? id,
    String? nickname,
    int? avatarId,
    String? settings,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ChildrenData(
    id: id ?? this.id,
    nickname: nickname ?? this.nickname,
    avatarId: avatarId ?? this.avatarId,
    settings: settings ?? this.settings,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ChildrenData copyWithCompanion(ChildrenCompanion data) {
    return ChildrenData(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      settings: data.settings.present ? data.settings.value : this.settings,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenData(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('settings: $settings, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nickname, avatarId, settings, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildrenData &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.avatarId == this.avatarId &&
          other.settings == this.settings &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ChildrenCompanion extends UpdateCompanion<ChildrenData> {
  final Value<String> id;
  final Value<String> nickname;
  final Value<int> avatarId;
  final Value<String> settings;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.settings = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildrenCompanion.insert({
    required String id,
    required String nickname,
    required int avatarId,
    required String settings,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nickname = Value(nickname),
       avatarId = Value(avatarId),
       settings = Value(settings),
       updatedAt = Value(updatedAt);
  static Insertable<ChildrenData> custom({
    Expression<String>? id,
    Expression<String>? nickname,
    Expression<int>? avatarId,
    Expression<String>? settings,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (avatarId != null) 'avatar_id': avatarId,
      if (settings != null) 'settings': settings,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildrenCompanion copyWith({
    Value<String>? id,
    Value<String>? nickname,
    Value<int>? avatarId,
    Value<String>? settings,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ChildrenCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      settings: settings ?? this.settings,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<int>(avatarId.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('settings: $settings, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsentsTable extends Consents with TableInfo<$ConsentsTable, Consent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grantedAtMeta = const VerificationMeta(
    'grantedAt',
  );
  @override
  late final GeneratedColumn<DateTime> grantedAt = GeneratedColumn<DateTime>(
    'granted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revokedAt = GeneratedColumn<DateTime>(
    'revoked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    version,
    grantedAt,
    revokedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Consent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('granted_at')) {
      context.handle(
        _grantedAtMeta,
        grantedAt.isAcceptableOrUnknown(data['granted_at']!, _grantedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_grantedAtMeta);
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Consent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Consent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      grantedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}granted_at'],
      )!,
      revokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_at'],
      ),
    );
  }

  @override
  $ConsentsTable createAlias(String alias) {
    return $ConsentsTable(attachedDatabase, alias);
  }
}

class Consent extends DataClass implements Insertable<Consent> {
  final String id;
  final String childId;
  final String version;
  final DateTime grantedAt;
  final DateTime? revokedAt;
  const Consent({
    required this.id,
    required this.childId,
    required this.version,
    required this.grantedAt,
    this.revokedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['version'] = Variable<String>(version);
    map['granted_at'] = Variable<DateTime>(grantedAt);
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<DateTime>(revokedAt);
    }
    return map;
  }

  ConsentsCompanion toCompanion(bool nullToAbsent) {
    return ConsentsCompanion(
      id: Value(id),
      childId: Value(childId),
      version: Value(version),
      grantedAt: Value(grantedAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
    );
  }

  factory Consent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Consent(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      version: serializer.fromJson<String>(json['version']),
      grantedAt: serializer.fromJson<DateTime>(json['grantedAt']),
      revokedAt: serializer.fromJson<DateTime?>(json['revokedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'version': serializer.toJson<String>(version),
      'grantedAt': serializer.toJson<DateTime>(grantedAt),
      'revokedAt': serializer.toJson<DateTime?>(revokedAt),
    };
  }

  Consent copyWith({
    String? id,
    String? childId,
    String? version,
    DateTime? grantedAt,
    Value<DateTime?> revokedAt = const Value.absent(),
  }) => Consent(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    version: version ?? this.version,
    grantedAt: grantedAt ?? this.grantedAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
  );
  Consent copyWithCompanion(ConsentsCompanion data) {
    return Consent(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      version: data.version.present ? data.version.value : this.version,
      grantedAt: data.grantedAt.present ? data.grantedAt.value : this.grantedAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Consent(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('version: $version, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('revokedAt: $revokedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, childId, version, grantedAt, revokedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Consent &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.version == this.version &&
          other.grantedAt == this.grantedAt &&
          other.revokedAt == this.revokedAt);
}

class ConsentsCompanion extends UpdateCompanion<Consent> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> version;
  final Value<DateTime> grantedAt;
  final Value<DateTime?> revokedAt;
  final Value<int> rowid;
  const ConsentsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.version = const Value.absent(),
    this.grantedAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsentsCompanion.insert({
    required String id,
    required String childId,
    required String version,
    required DateTime grantedAt,
    this.revokedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       version = Value(version),
       grantedAt = Value(grantedAt);
  static Insertable<Consent> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? version,
    Expression<DateTime>? grantedAt,
    Expression<DateTime>? revokedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (version != null) 'version': version,
      if (grantedAt != null) 'granted_at': grantedAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsentsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? version,
    Value<DateTime>? grantedAt,
    Value<DateTime?>? revokedAt,
    Value<int>? rowid,
  }) {
    return ConsentsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      version: version ?? this.version,
      grantedAt: grantedAt ?? this.grantedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (grantedAt.present) {
      map['granted_at'] = Variable<DateTime>(grantedAt.value);
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<DateTime>(revokedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('version: $version, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeSessionsTable extends PracticeSessions
    with TableInfo<$PracticeSessionsTable, PracticeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLevelMeta = const VerificationMeta(
    'startLevel',
  );
  @override
  late final GeneratedColumn<int> startLevel = GeneratedColumn<int>(
    'start_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endLevelMeta = const VerificationMeta(
    'endLevel',
  );
  @override
  late final GeneratedColumn<int> endLevel = GeneratedColumn<int>(
    'end_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedWordsMeta = const VerificationMeta(
    'plannedWords',
  );
  @override
  late final GeneratedColumn<int> plannedWords = GeneratedColumn<int>(
    'planned_words',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    kind,
    startLevel,
    endLevel,
    plannedWords,
    startedAt,
    endedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('start_level')) {
      context.handle(
        _startLevelMeta,
        startLevel.isAcceptableOrUnknown(data['start_level']!, _startLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_startLevelMeta);
    }
    if (data.containsKey('end_level')) {
      context.handle(
        _endLevelMeta,
        endLevel.isAcceptableOrUnknown(data['end_level']!, _endLevelMeta),
      );
    }
    if (data.containsKey('planned_words')) {
      context.handle(
        _plannedWordsMeta,
        plannedWords.isAcceptableOrUnknown(
          data['planned_words']!,
          _plannedWordsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedWordsMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      startLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_level'],
      )!,
      endLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_level'],
      ),
      plannedWords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_words'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $PracticeSessionsTable createAlias(String alias) {
    return $PracticeSessionsTable(attachedDatabase, alias);
  }
}

class PracticeSession extends DataClass implements Insertable<PracticeSession> {
  final String id;
  final String childId;
  final String kind;
  final int startLevel;
  final int? endLevel;
  final int plannedWords;
  final DateTime startedAt;
  final DateTime? endedAt;
  const PracticeSession({
    required this.id,
    required this.childId,
    required this.kind,
    required this.startLevel,
    this.endLevel,
    required this.plannedWords,
    required this.startedAt,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['kind'] = Variable<String>(kind);
    map['start_level'] = Variable<int>(startLevel);
    if (!nullToAbsent || endLevel != null) {
      map['end_level'] = Variable<int>(endLevel);
    }
    map['planned_words'] = Variable<int>(plannedWords);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  PracticeSessionsCompanion toCompanion(bool nullToAbsent) {
    return PracticeSessionsCompanion(
      id: Value(id),
      childId: Value(childId),
      kind: Value(kind),
      startLevel: Value(startLevel),
      endLevel: endLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(endLevel),
      plannedWords: Value(plannedWords),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory PracticeSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeSession(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      kind: serializer.fromJson<String>(json['kind']),
      startLevel: serializer.fromJson<int>(json['startLevel']),
      endLevel: serializer.fromJson<int?>(json['endLevel']),
      plannedWords: serializer.fromJson<int>(json['plannedWords']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'kind': serializer.toJson<String>(kind),
      'startLevel': serializer.toJson<int>(startLevel),
      'endLevel': serializer.toJson<int?>(endLevel),
      'plannedWords': serializer.toJson<int>(plannedWords),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  PracticeSession copyWith({
    String? id,
    String? childId,
    String? kind,
    int? startLevel,
    Value<int?> endLevel = const Value.absent(),
    int? plannedWords,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
  }) => PracticeSession(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    kind: kind ?? this.kind,
    startLevel: startLevel ?? this.startLevel,
    endLevel: endLevel.present ? endLevel.value : this.endLevel,
    plannedWords: plannedWords ?? this.plannedWords,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  PracticeSession copyWithCompanion(PracticeSessionsCompanion data) {
    return PracticeSession(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      kind: data.kind.present ? data.kind.value : this.kind,
      startLevel: data.startLevel.present
          ? data.startLevel.value
          : this.startLevel,
      endLevel: data.endLevel.present ? data.endLevel.value : this.endLevel,
      plannedWords: data.plannedWords.present
          ? data.plannedWords.value
          : this.plannedWords,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSession(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kind: $kind, ')
          ..write('startLevel: $startLevel, ')
          ..write('endLevel: $endLevel, ')
          ..write('plannedWords: $plannedWords, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    childId,
    kind,
    startLevel,
    endLevel,
    plannedWords,
    startedAt,
    endedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeSession &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.kind == this.kind &&
          other.startLevel == this.startLevel &&
          other.endLevel == this.endLevel &&
          other.plannedWords == this.plannedWords &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class PracticeSessionsCompanion extends UpdateCompanion<PracticeSession> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> kind;
  final Value<int> startLevel;
  final Value<int?> endLevel;
  final Value<int> plannedWords;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const PracticeSessionsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.kind = const Value.absent(),
    this.startLevel = const Value.absent(),
    this.endLevel = const Value.absent(),
    this.plannedWords = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeSessionsCompanion.insert({
    required String id,
    required String childId,
    required String kind,
    required int startLevel,
    this.endLevel = const Value.absent(),
    required int plannedWords,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       kind = Value(kind),
       startLevel = Value(startLevel),
       plannedWords = Value(plannedWords),
       startedAt = Value(startedAt);
  static Insertable<PracticeSession> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? kind,
    Expression<int>? startLevel,
    Expression<int>? endLevel,
    Expression<int>? plannedWords,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (kind != null) 'kind': kind,
      if (startLevel != null) 'start_level': startLevel,
      if (endLevel != null) 'end_level': endLevel,
      if (plannedWords != null) 'planned_words': plannedWords,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? kind,
    Value<int>? startLevel,
    Value<int?>? endLevel,
    Value<int>? plannedWords,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? rowid,
  }) {
    return PracticeSessionsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      kind: kind ?? this.kind,
      startLevel: startLevel ?? this.startLevel,
      endLevel: endLevel ?? this.endLevel,
      plannedWords: plannedWords ?? this.plannedWords,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (startLevel.present) {
      map['start_level'] = Variable<int>(startLevel.value);
    }
    if (endLevel.present) {
      map['end_level'] = Variable<int>(endLevel.value);
    }
    if (plannedWords.present) {
      map['planned_words'] = Variable<int>(plannedWords.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kind: $kind, ')
          ..write('startLevel: $startLevel, ')
          ..write('endLevel: $endLevel, ')
          ..write('plannedWords: $plannedWords, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTable extends Attempts with TableInfo<$AttemptsTable, Attempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tryNumberMeta = const VerificationMeta(
    'tryNumber',
  );
  @override
  late final GeneratedColumn<int> tryNumber = GeneratedColumn<int>(
    'try_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _matchedSyllablesMeta = const VerificationMeta(
    'matchedSyllables',
  );
  @override
  late final GeneratedColumn<String> matchedSyllables = GeneratedColumn<String>(
    'matched_syllables',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineMeta = const VerificationMeta('engine');
  @override
  late final GeneratedColumn<String> engine = GeneratedColumn<String>(
    'engine',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedMeta = const VerificationMeta(
    'finished',
  );
  @override
  late final GeneratedColumn<bool> finished = GeneratedColumn<bool>(
    'finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("finished" IN (0, 1))',
    ),
  );
  static const VerificationMeta _assistedMeta = const VerificationMeta(
    'assisted',
  );
  @override
  late final GeneratedColumn<bool> assisted = GeneratedColumn<bool>(
    'assisted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("assisted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _guardianOverrideMeta = const VerificationMeta(
    'guardianOverride',
  );
  @override
  late final GeneratedColumn<bool> guardianOverride = GeneratedColumn<bool>(
    'guardian_override',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("guardian_override" IN (0, 1))',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    childId,
    wordId,
    contentVersion,
    tryNumber,
    status,
    matchedSyllables,
    confidence,
    engine,
    finished,
    assisted,
    guardianOverride,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentVersionMeta);
    }
    if (data.containsKey('try_number')) {
      context.handle(
        _tryNumberMeta,
        tryNumber.isAcceptableOrUnknown(data['try_number']!, _tryNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_tryNumberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('matched_syllables')) {
      context.handle(
        _matchedSyllablesMeta,
        matchedSyllables.isAcceptableOrUnknown(
          data['matched_syllables']!,
          _matchedSyllablesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchedSyllablesMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('engine')) {
      context.handle(
        _engineMeta,
        engine.isAcceptableOrUnknown(data['engine']!, _engineMeta),
      );
    } else if (isInserting) {
      context.missing(_engineMeta);
    }
    if (data.containsKey('finished')) {
      context.handle(
        _finishedMeta,
        finished.isAcceptableOrUnknown(data['finished']!, _finishedMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedMeta);
    }
    if (data.containsKey('assisted')) {
      context.handle(
        _assistedMeta,
        assisted.isAcceptableOrUnknown(data['assisted']!, _assistedMeta),
      );
    } else if (isInserting) {
      context.missing(_assistedMeta);
    }
    if (data.containsKey('guardian_override')) {
      context.handle(
        _guardianOverrideMeta,
        guardianOverride.isAcceptableOrUnknown(
          data['guardian_override']!,
          _guardianOverrideMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_guardianOverrideMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
      tryNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}try_number'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      matchedSyllables: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matched_syllables'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      engine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine'],
      )!,
      finished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}finished'],
      )!,
      assisted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}assisted'],
      )!,
      guardianOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}guardian_override'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $AttemptsTable createAlias(String alias) {
    return $AttemptsTable(attachedDatabase, alias);
  }
}

class Attempt extends DataClass implements Insertable<Attempt> {
  final String id;
  final String sessionId;
  final String childId;
  final String wordId;
  final int contentVersion;
  final int tryNumber;
  final String status;
  final String matchedSyllables;
  final double? confidence;
  final String engine;
  final bool finished;
  final bool assisted;
  final bool guardianOverride;
  final DateTime occurredAt;
  const Attempt({
    required this.id,
    required this.sessionId,
    required this.childId,
    required this.wordId,
    required this.contentVersion,
    required this.tryNumber,
    required this.status,
    required this.matchedSyllables,
    this.confidence,
    required this.engine,
    required this.finished,
    required this.assisted,
    required this.guardianOverride,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['child_id'] = Variable<String>(childId);
    map['word_id'] = Variable<String>(wordId);
    map['content_version'] = Variable<int>(contentVersion);
    map['try_number'] = Variable<int>(tryNumber);
    map['status'] = Variable<String>(status);
    map['matched_syllables'] = Variable<String>(matchedSyllables);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['engine'] = Variable<String>(engine);
    map['finished'] = Variable<bool>(finished);
    map['assisted'] = Variable<bool>(assisted);
    map['guardian_override'] = Variable<bool>(guardianOverride);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  AttemptsCompanion toCompanion(bool nullToAbsent) {
    return AttemptsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      childId: Value(childId),
      wordId: Value(wordId),
      contentVersion: Value(contentVersion),
      tryNumber: Value(tryNumber),
      status: Value(status),
      matchedSyllables: Value(matchedSyllables),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      engine: Value(engine),
      finished: Value(finished),
      assisted: Value(assisted),
      guardianOverride: Value(guardianOverride),
      occurredAt: Value(occurredAt),
    );
  }

  factory Attempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attempt(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      childId: serializer.fromJson<String>(json['childId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
      tryNumber: serializer.fromJson<int>(json['tryNumber']),
      status: serializer.fromJson<String>(json['status']),
      matchedSyllables: serializer.fromJson<String>(json['matchedSyllables']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      engine: serializer.fromJson<String>(json['engine']),
      finished: serializer.fromJson<bool>(json['finished']),
      assisted: serializer.fromJson<bool>(json['assisted']),
      guardianOverride: serializer.fromJson<bool>(json['guardianOverride']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'childId': serializer.toJson<String>(childId),
      'wordId': serializer.toJson<String>(wordId),
      'contentVersion': serializer.toJson<int>(contentVersion),
      'tryNumber': serializer.toJson<int>(tryNumber),
      'status': serializer.toJson<String>(status),
      'matchedSyllables': serializer.toJson<String>(matchedSyllables),
      'confidence': serializer.toJson<double?>(confidence),
      'engine': serializer.toJson<String>(engine),
      'finished': serializer.toJson<bool>(finished),
      'assisted': serializer.toJson<bool>(assisted),
      'guardianOverride': serializer.toJson<bool>(guardianOverride),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  Attempt copyWith({
    String? id,
    String? sessionId,
    String? childId,
    String? wordId,
    int? contentVersion,
    int? tryNumber,
    String? status,
    String? matchedSyllables,
    Value<double?> confidence = const Value.absent(),
    String? engine,
    bool? finished,
    bool? assisted,
    bool? guardianOverride,
    DateTime? occurredAt,
  }) => Attempt(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    childId: childId ?? this.childId,
    wordId: wordId ?? this.wordId,
    contentVersion: contentVersion ?? this.contentVersion,
    tryNumber: tryNumber ?? this.tryNumber,
    status: status ?? this.status,
    matchedSyllables: matchedSyllables ?? this.matchedSyllables,
    confidence: confidence.present ? confidence.value : this.confidence,
    engine: engine ?? this.engine,
    finished: finished ?? this.finished,
    assisted: assisted ?? this.assisted,
    guardianOverride: guardianOverride ?? this.guardianOverride,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  Attempt copyWithCompanion(AttemptsCompanion data) {
    return Attempt(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      childId: data.childId.present ? data.childId.value : this.childId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
      tryNumber: data.tryNumber.present ? data.tryNumber.value : this.tryNumber,
      status: data.status.present ? data.status.value : this.status,
      matchedSyllables: data.matchedSyllables.present
          ? data.matchedSyllables.value
          : this.matchedSyllables,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      engine: data.engine.present ? data.engine.value : this.engine,
      finished: data.finished.present ? data.finished.value : this.finished,
      assisted: data.assisted.present ? data.assisted.value : this.assisted,
      guardianOverride: data.guardianOverride.present
          ? data.guardianOverride.value
          : this.guardianOverride,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attempt(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('childId: $childId, ')
          ..write('wordId: $wordId, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('tryNumber: $tryNumber, ')
          ..write('status: $status, ')
          ..write('matchedSyllables: $matchedSyllables, ')
          ..write('confidence: $confidence, ')
          ..write('engine: $engine, ')
          ..write('finished: $finished, ')
          ..write('assisted: $assisted, ')
          ..write('guardianOverride: $guardianOverride, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    childId,
    wordId,
    contentVersion,
    tryNumber,
    status,
    matchedSyllables,
    confidence,
    engine,
    finished,
    assisted,
    guardianOverride,
    occurredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attempt &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.childId == this.childId &&
          other.wordId == this.wordId &&
          other.contentVersion == this.contentVersion &&
          other.tryNumber == this.tryNumber &&
          other.status == this.status &&
          other.matchedSyllables == this.matchedSyllables &&
          other.confidence == this.confidence &&
          other.engine == this.engine &&
          other.finished == this.finished &&
          other.assisted == this.assisted &&
          other.guardianOverride == this.guardianOverride &&
          other.occurredAt == this.occurredAt);
}

class AttemptsCompanion extends UpdateCompanion<Attempt> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> childId;
  final Value<String> wordId;
  final Value<int> contentVersion;
  final Value<int> tryNumber;
  final Value<String> status;
  final Value<String> matchedSyllables;
  final Value<double?> confidence;
  final Value<String> engine;
  final Value<bool> finished;
  final Value<bool> assisted;
  final Value<bool> guardianOverride;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const AttemptsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.childId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.tryNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.matchedSyllables = const Value.absent(),
    this.confidence = const Value.absent(),
    this.engine = const Value.absent(),
    this.finished = const Value.absent(),
    this.assisted = const Value.absent(),
    this.guardianOverride = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttemptsCompanion.insert({
    required String id,
    required String sessionId,
    required String childId,
    required String wordId,
    required int contentVersion,
    required int tryNumber,
    required String status,
    required String matchedSyllables,
    this.confidence = const Value.absent(),
    required String engine,
    required bool finished,
    required bool assisted,
    required bool guardianOverride,
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       childId = Value(childId),
       wordId = Value(wordId),
       contentVersion = Value(contentVersion),
       tryNumber = Value(tryNumber),
       status = Value(status),
       matchedSyllables = Value(matchedSyllables),
       engine = Value(engine),
       finished = Value(finished),
       assisted = Value(assisted),
       guardianOverride = Value(guardianOverride),
       occurredAt = Value(occurredAt);
  static Insertable<Attempt> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? childId,
    Expression<String>? wordId,
    Expression<int>? contentVersion,
    Expression<int>? tryNumber,
    Expression<String>? status,
    Expression<String>? matchedSyllables,
    Expression<double>? confidence,
    Expression<String>? engine,
    Expression<bool>? finished,
    Expression<bool>? assisted,
    Expression<bool>? guardianOverride,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (childId != null) 'child_id': childId,
      if (wordId != null) 'word_id': wordId,
      if (contentVersion != null) 'content_version': contentVersion,
      if (tryNumber != null) 'try_number': tryNumber,
      if (status != null) 'status': status,
      if (matchedSyllables != null) 'matched_syllables': matchedSyllables,
      if (confidence != null) 'confidence': confidence,
      if (engine != null) 'engine': engine,
      if (finished != null) 'finished': finished,
      if (assisted != null) 'assisted': assisted,
      if (guardianOverride != null) 'guardian_override': guardianOverride,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? childId,
    Value<String>? wordId,
    Value<int>? contentVersion,
    Value<int>? tryNumber,
    Value<String>? status,
    Value<String>? matchedSyllables,
    Value<double?>? confidence,
    Value<String>? engine,
    Value<bool>? finished,
    Value<bool>? assisted,
    Value<bool>? guardianOverride,
    Value<DateTime>? occurredAt,
    Value<int>? rowid,
  }) {
    return AttemptsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      childId: childId ?? this.childId,
      wordId: wordId ?? this.wordId,
      contentVersion: contentVersion ?? this.contentVersion,
      tryNumber: tryNumber ?? this.tryNumber,
      status: status ?? this.status,
      matchedSyllables: matchedSyllables ?? this.matchedSyllables,
      confidence: confidence ?? this.confidence,
      engine: engine ?? this.engine,
      finished: finished ?? this.finished,
      assisted: assisted ?? this.assisted,
      guardianOverride: guardianOverride ?? this.guardianOverride,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (tryNumber.present) {
      map['try_number'] = Variable<int>(tryNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (matchedSyllables.present) {
      map['matched_syllables'] = Variable<String>(matchedSyllables.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (engine.present) {
      map['engine'] = Variable<String>(engine.value);
    }
    if (finished.present) {
      map['finished'] = Variable<bool>(finished.value);
    }
    if (assisted.present) {
      map['assisted'] = Variable<bool>(assisted.value);
    }
    if (guardianOverride.present) {
      map['guardian_override'] = Variable<bool>(guardianOverride.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('childId: $childId, ')
          ..write('wordId: $wordId, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('tryNumber: $tryNumber, ')
          ..write('status: $status, ')
          ..write('matchedSyllables: $matchedSyllables, ')
          ..write('confidence: $confidence, ')
          ..write('engine: $engine, ')
          ..write('finished: $finished, ')
          ..write('assisted: $assisted, ')
          ..write('guardianOverride: $guardianOverride, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelEventsTable extends LevelEvents
    with TableInfo<$LevelEventsTable, LevelEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLevelMeta = const VerificationMeta(
    'fromLevel',
  );
  @override
  late final GeneratedColumn<int> fromLevel = GeneratedColumn<int>(
    'from_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toLevelMeta = const VerificationMeta(
    'toLevel',
  );
  @override
  late final GeneratedColumn<int> toLevel = GeneratedColumn<int>(
    'to_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    fromLevel,
    toLevel,
    reason,
    actor,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('from_level')) {
      context.handle(
        _fromLevelMeta,
        fromLevel.isAcceptableOrUnknown(data['from_level']!, _fromLevelMeta),
      );
    }
    if (data.containsKey('to_level')) {
      context.handle(
        _toLevelMeta,
        toLevel.isAcceptableOrUnknown(data['to_level']!, _toLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_toLevelMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LevelEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      fromLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_level'],
      ),
      toLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_level'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $LevelEventsTable createAlias(String alias) {
    return $LevelEventsTable(attachedDatabase, alias);
  }
}

class LevelEvent extends DataClass implements Insertable<LevelEvent> {
  final String id;
  final String childId;
  final int? fromLevel;
  final int toLevel;
  final String reason;
  final String actor;
  final DateTime occurredAt;
  const LevelEvent({
    required this.id,
    required this.childId,
    this.fromLevel,
    required this.toLevel,
    required this.reason,
    required this.actor,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    if (!nullToAbsent || fromLevel != null) {
      map['from_level'] = Variable<int>(fromLevel);
    }
    map['to_level'] = Variable<int>(toLevel);
    map['reason'] = Variable<String>(reason);
    map['actor'] = Variable<String>(actor);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  LevelEventsCompanion toCompanion(bool nullToAbsent) {
    return LevelEventsCompanion(
      id: Value(id),
      childId: Value(childId),
      fromLevel: fromLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(fromLevel),
      toLevel: Value(toLevel),
      reason: Value(reason),
      actor: Value(actor),
      occurredAt: Value(occurredAt),
    );
  }

  factory LevelEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelEvent(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      fromLevel: serializer.fromJson<int?>(json['fromLevel']),
      toLevel: serializer.fromJson<int>(json['toLevel']),
      reason: serializer.fromJson<String>(json['reason']),
      actor: serializer.fromJson<String>(json['actor']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'fromLevel': serializer.toJson<int?>(fromLevel),
      'toLevel': serializer.toJson<int>(toLevel),
      'reason': serializer.toJson<String>(reason),
      'actor': serializer.toJson<String>(actor),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  LevelEvent copyWith({
    String? id,
    String? childId,
    Value<int?> fromLevel = const Value.absent(),
    int? toLevel,
    String? reason,
    String? actor,
    DateTime? occurredAt,
  }) => LevelEvent(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    fromLevel: fromLevel.present ? fromLevel.value : this.fromLevel,
    toLevel: toLevel ?? this.toLevel,
    reason: reason ?? this.reason,
    actor: actor ?? this.actor,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  LevelEvent copyWithCompanion(LevelEventsCompanion data) {
    return LevelEvent(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      fromLevel: data.fromLevel.present ? data.fromLevel.value : this.fromLevel,
      toLevel: data.toLevel.present ? data.toLevel.value : this.toLevel,
      reason: data.reason.present ? data.reason.value : this.reason,
      actor: data.actor.present ? data.actor.value : this.actor,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelEvent(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('fromLevel: $fromLevel, ')
          ..write('toLevel: $toLevel, ')
          ..write('reason: $reason, ')
          ..write('actor: $actor, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, fromLevel, toLevel, reason, actor, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelEvent &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.fromLevel == this.fromLevel &&
          other.toLevel == this.toLevel &&
          other.reason == this.reason &&
          other.actor == this.actor &&
          other.occurredAt == this.occurredAt);
}

class LevelEventsCompanion extends UpdateCompanion<LevelEvent> {
  final Value<String> id;
  final Value<String> childId;
  final Value<int?> fromLevel;
  final Value<int> toLevel;
  final Value<String> reason;
  final Value<String> actor;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const LevelEventsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.fromLevel = const Value.absent(),
    this.toLevel = const Value.absent(),
    this.reason = const Value.absent(),
    this.actor = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelEventsCompanion.insert({
    required String id,
    required String childId,
    this.fromLevel = const Value.absent(),
    required int toLevel,
    required String reason,
    required String actor,
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       toLevel = Value(toLevel),
       reason = Value(reason),
       actor = Value(actor),
       occurredAt = Value(occurredAt);
  static Insertable<LevelEvent> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<int>? fromLevel,
    Expression<int>? toLevel,
    Expression<String>? reason,
    Expression<String>? actor,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (fromLevel != null) 'from_level': fromLevel,
      if (toLevel != null) 'to_level': toLevel,
      if (reason != null) 'reason': reason,
      if (actor != null) 'actor': actor,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<int?>? fromLevel,
    Value<int>? toLevel,
    Value<String>? reason,
    Value<String>? actor,
    Value<DateTime>? occurredAt,
    Value<int>? rowid,
  }) {
    return LevelEventsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      fromLevel: fromLevel ?? this.fromLevel,
      toLevel: toLevel ?? this.toLevel,
      reason: reason ?? this.reason,
      actor: actor ?? this.actor,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (fromLevel.present) {
      map['from_level'] = Variable<int>(fromLevel.value);
    }
    if (toLevel.present) {
      map['to_level'] = Variable<int>(toLevel.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelEventsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('fromLevel: $fromLevel, ')
          ..write('toLevel: $toLevel, ')
          ..write('reason: $reason, ')
          ..write('actor: $actor, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryProgressTable extends StoryProgress
    with TableInfo<$StoryProgressTable, StoryProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
    'story_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    childId,
    storyId,
    page,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {childId, storyId};
  @override
  StoryProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryProgressData(
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      storyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_id'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StoryProgressTable createAlias(String alias) {
    return $StoryProgressTable(attachedDatabase, alias);
  }
}

class StoryProgressData extends DataClass
    implements Insertable<StoryProgressData> {
  final String childId;
  final String storyId;
  final int page;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const StoryProgressData({
    required this.childId,
    required this.storyId,
    required this.page,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['child_id'] = Variable<String>(childId);
    map['story_id'] = Variable<String>(storyId);
    map['page'] = Variable<int>(page);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StoryProgressCompanion toCompanion(bool nullToAbsent) {
    return StoryProgressCompanion(
      childId: Value(childId),
      storyId: Value(storyId),
      page: Value(page),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StoryProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryProgressData(
      childId: serializer.fromJson<String>(json['childId']),
      storyId: serializer.fromJson<String>(json['storyId']),
      page: serializer.fromJson<int>(json['page']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'childId': serializer.toJson<String>(childId),
      'storyId': serializer.toJson<String>(storyId),
      'page': serializer.toJson<int>(page),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StoryProgressData copyWith({
    String? childId,
    String? storyId,
    int? page,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => StoryProgressData(
    childId: childId ?? this.childId,
    storyId: storyId ?? this.storyId,
    page: page ?? this.page,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StoryProgressData copyWithCompanion(StoryProgressCompanion data) {
    return StoryProgressData(
      childId: data.childId.present ? data.childId.value : this.childId,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      page: data.page.present ? data.page.value : this.page,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryProgressData(')
          ..write('childId: $childId, ')
          ..write('storyId: $storyId, ')
          ..write('page: $page, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(childId, storyId, page, completedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryProgressData &&
          other.childId == this.childId &&
          other.storyId == this.storyId &&
          other.page == this.page &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class StoryProgressCompanion extends UpdateCompanion<StoryProgressData> {
  final Value<String> childId;
  final Value<String> storyId;
  final Value<int> page;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StoryProgressCompanion({
    this.childId = const Value.absent(),
    this.storyId = const Value.absent(),
    this.page = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryProgressCompanion.insert({
    required String childId,
    required String storyId,
    required int page,
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : childId = Value(childId),
       storyId = Value(storyId),
       page = Value(page),
       updatedAt = Value(updatedAt);
  static Insertable<StoryProgressData> custom({
    Expression<String>? childId,
    Expression<String>? storyId,
    Expression<int>? page,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (childId != null) 'child_id': childId,
      if (storyId != null) 'story_id': storyId,
      if (page != null) 'page': page,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryProgressCompanion copyWith({
    Value<String>? childId,
    Value<String>? storyId,
    Value<int>? page,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StoryProgressCompanion(
      childId: childId ?? this.childId,
      storyId: storyId ?? this.storyId,
      page: page ?? this.page,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryProgressCompanion(')
          ..write('childId: $childId, ')
          ..write('storyId: $storyId, ')
          ..write('page: $page, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardEventsTable extends RewardEvents
    with TableInfo<$RewardEventsTable, RewardEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    kind,
    sourceId,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {childId, kind, sourceId},
  ];
  @override
  RewardEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $RewardEventsTable createAlias(String alias) {
    return $RewardEventsTable(attachedDatabase, alias);
  }
}

class RewardEvent extends DataClass implements Insertable<RewardEvent> {
  final String id;
  final String childId;
  final String kind;
  final String sourceId;
  final DateTime occurredAt;
  const RewardEvent({
    required this.id,
    required this.childId,
    required this.kind,
    required this.sourceId,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['kind'] = Variable<String>(kind);
    map['source_id'] = Variable<String>(sourceId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  RewardEventsCompanion toCompanion(bool nullToAbsent) {
    return RewardEventsCompanion(
      id: Value(id),
      childId: Value(childId),
      kind: Value(kind),
      sourceId: Value(sourceId),
      occurredAt: Value(occurredAt),
    );
  }

  factory RewardEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardEvent(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      kind: serializer.fromJson<String>(json['kind']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'kind': serializer.toJson<String>(kind),
      'sourceId': serializer.toJson<String>(sourceId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  RewardEvent copyWith({
    String? id,
    String? childId,
    String? kind,
    String? sourceId,
    DateTime? occurredAt,
  }) => RewardEvent(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    kind: kind ?? this.kind,
    sourceId: sourceId ?? this.sourceId,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  RewardEvent copyWithCompanion(RewardEventsCompanion data) {
    return RewardEvent(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      kind: data.kind.present ? data.kind.value : this.kind,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardEvent(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kind: $kind, ')
          ..write('sourceId: $sourceId, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, childId, kind, sourceId, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardEvent &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.kind == this.kind &&
          other.sourceId == this.sourceId &&
          other.occurredAt == this.occurredAt);
}

class RewardEventsCompanion extends UpdateCompanion<RewardEvent> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> kind;
  final Value<String> sourceId;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const RewardEventsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.kind = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardEventsCompanion.insert({
    required String id,
    required String childId,
    required String kind,
    required String sourceId,
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       kind = Value(kind),
       sourceId = Value(sourceId),
       occurredAt = Value(occurredAt);
  static Insertable<RewardEvent> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? kind,
    Expression<String>? sourceId,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (kind != null) 'kind': kind,
      if (sourceId != null) 'source_id': sourceId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? kind,
    Value<String>? sourceId,
    Value<DateTime>? occurredAt,
    Value<int>? rowid,
  }) {
    return RewardEventsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      kind: kind ?? this.kind,
      sourceId: sourceId ?? this.sourceId,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardEventsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kind: $kind, ')
          ..write('sourceId: $sourceId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triesMeta = const VerificationMeta('tries');
  @override
  late final GeneratedColumn<int> tries = GeneratedColumn<int>(
    'tries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rejectedReasonMeta = const VerificationMeta(
    'rejectedReason',
  );
  @override
  late final GeneratedColumn<String> rejectedReason = GeneratedColumn<String>(
    'rejected_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    payload,
    tries,
    nextRetryAt,
    rejectedReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('tries')) {
      context.handle(
        _triesMeta,
        tries.isAcceptableOrUnknown(data['tries']!, _triesMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('rejected_reason')) {
      context.handle(
        _rejectedReasonMeta,
        rejectedReason.isAcceptableOrUnknown(
          data['rejected_reason']!,
          _rejectedReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      tries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tries'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
      rejectedReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejected_reason'],
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int id;
  final String targetTable;
  final String payload;
  final int tries;
  final DateTime? nextRetryAt;
  final String? rejectedReason;
  const OutboxData({
    required this.id,
    required this.targetTable,
    required this.payload,
    required this.tries,
    this.nextRetryAt,
    this.rejectedReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['payload'] = Variable<String>(payload);
    map['tries'] = Variable<int>(tries);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    if (!nullToAbsent || rejectedReason != null) {
      map['rejected_reason'] = Variable<String>(rejectedReason);
    }
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      payload: Value(payload),
      tries: Value(tries),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      rejectedReason: rejectedReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectedReason),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      payload: serializer.fromJson<String>(json['payload']),
      tries: serializer.fromJson<int>(json['tries']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      rejectedReason: serializer.fromJson<String?>(json['rejectedReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'payload': serializer.toJson<String>(payload),
      'tries': serializer.toJson<int>(tries),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'rejectedReason': serializer.toJson<String?>(rejectedReason),
    };
  }

  OutboxData copyWith({
    int? id,
    String? targetTable,
    String? payload,
    int? tries,
    Value<DateTime?> nextRetryAt = const Value.absent(),
    Value<String?> rejectedReason = const Value.absent(),
  }) => OutboxData(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    payload: payload ?? this.payload,
    tries: tries ?? this.tries,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    rejectedReason: rejectedReason.present
        ? rejectedReason.value
        : this.rejectedReason,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      payload: data.payload.present ? data.payload.value : this.payload,
      tries: data.tries.present ? data.tries.value : this.tries,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      rejectedReason: data.rejectedReason.present
          ? data.rejectedReason.value
          : this.rejectedReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('payload: $payload, ')
          ..write('tries: $tries, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rejectedReason: $rejectedReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetTable, payload, tries, nextRetryAt, rejectedReason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.payload == this.payload &&
          other.tries == this.tries &&
          other.nextRetryAt == this.nextRetryAt &&
          other.rejectedReason == this.rejectedReason);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> payload;
  final Value<int> tries;
  final Value<DateTime?> nextRetryAt;
  final Value<String?> rejectedReason;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.payload = const Value.absent(),
    this.tries = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rejectedReason = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String payload,
    this.tries = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rejectedReason = const Value.absent(),
  }) : targetTable = Value(targetTable),
       payload = Value(payload);
  static Insertable<OutboxData> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? payload,
    Expression<int>? tries,
    Expression<DateTime>? nextRetryAt,
    Expression<String>? rejectedReason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (payload != null) 'payload': payload,
      if (tries != null) 'tries': tries,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (rejectedReason != null) 'rejected_reason': rejectedReason,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? payload,
    Value<int>? tries,
    Value<DateTime?>? nextRetryAt,
    Value<String?>? rejectedReason,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      payload: payload ?? this.payload,
      tries: tries ?? this.tries,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      rejectedReason: rejectedReason ?? this.rejectedReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (tries.present) {
      map['tries'] = Variable<int>(tries.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (rejectedReason.present) {
      map['rejected_reason'] = Variable<String>(rejectedReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('payload: $payload, ')
          ..write('tries: $tries, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rejectedReason: $rejectedReason')
          ..write(')'))
        .toString();
  }
}

class $KeyValuesTable extends KeyValues
    with TableInfo<$KeyValuesTable, KeyValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeyValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValue(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $KeyValuesTable createAlias(String alias) {
    return $KeyValuesTable(attachedDatabase, alias);
  }
}

class KeyValue extends DataClass implements Insertable<KeyValue> {
  final String key;
  final String value;
  const KeyValue({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValuesCompanion toCompanion(bool nullToAbsent) {
    return KeyValuesCompanion(key: Value(key), value: Value(value));
  }

  factory KeyValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValue(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KeyValue copyWith({String? key, String? value}) =>
      KeyValue(key: key ?? this.key, value: value ?? this.value);
  KeyValue copyWithCompanion(KeyValuesCompanion data) {
    return KeyValue(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValue(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyValue && other.key == this.key && other.value == this.value);
}

class KeyValuesCompanion extends UpdateCompanion<KeyValue> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValuesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValuesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<KeyValue> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValuesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return KeyValuesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValuesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $ConsentsTable consents = $ConsentsTable(this);
  late final $PracticeSessionsTable practiceSessions = $PracticeSessionsTable(
    this,
  );
  late final $AttemptsTable attempts = $AttemptsTable(this);
  late final $LevelEventsTable levelEvents = $LevelEventsTable(this);
  late final $StoryProgressTable storyProgress = $StoryProgressTable(this);
  late final $RewardEventsTable rewardEvents = $RewardEventsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    children,
    consents,
    practiceSessions,
    attempts,
    levelEvents,
    storyProgress,
    rewardEvents,
    outbox,
    keyValues,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ChildrenTableCreateCompanionBuilder = ChildrenCompanion Function({
  required String id,
  required String nickname,
  required int avatarId,
  required String settings,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ChildrenTableUpdateCompanionBuilder = ChildrenCompanion Function({
  Value<String> id,
  Value<String> nickname,
  Value<int> avatarId,
  Value<String> settings,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$ChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<int> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ChildrenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildrenTable,
          ChildrenData,
          $$ChildrenTableFilterComposer,
          $$ChildrenTableOrderingComposer,
          $$ChildrenTableAnnotationComposer,
          $$ChildrenTableCreateCompanionBuilder,
          $$ChildrenTableUpdateCompanionBuilder,
          (
            ChildrenData,
            BaseReferences<_$AppDatabase, $ChildrenTable, ChildrenData>,
          ),
          ChildrenData,
          PrefetchHooks Function()
        > {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<int> avatarId = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildrenCompanion(
                id: id,
                nickname: nickname,
                avatarId: avatarId,
                settings: settings,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nickname,
                required int avatarId,
                required String settings,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildrenCompanion.insert(
                id: id,
                nickname: nickname,
                avatarId: avatarId,
                settings: settings,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChildrenTable, ChildrenData>(table),
                  BaseReferences<_$AppDatabase, $ChildrenTable, ChildrenData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildrenTable,
      ChildrenData,
      $$ChildrenTableFilterComposer,
      $$ChildrenTableOrderingComposer,
      $$ChildrenTableAnnotationComposer,
      $$ChildrenTableCreateCompanionBuilder,
      $$ChildrenTableUpdateCompanionBuilder,
      (
        ChildrenData,
        BaseReferences<_$AppDatabase, $ChildrenTable, ChildrenData>,
      ),
      ChildrenData,
      PrefetchHooks Function()
    >;
typedef $$ConsentsTableCreateCompanionBuilder = ConsentsCompanion Function({
  required String id,
  required String childId,
  required String version,
  required DateTime grantedAt,
  Value<DateTime?> revokedAt,
  Value<int> rowid,
});
typedef $$ConsentsTableUpdateCompanionBuilder = ConsentsCompanion Function({
  Value<String> id,
  Value<String> childId,
  Value<String> version,
  Value<DateTime> grantedAt,
  Value<DateTime?> revokedAt,
  Value<int> rowid,
});

class $$ConsentsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConsentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConsentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get grantedAt =>
      $composableBuilder(column: $table.grantedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);
}

class $$ConsentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsentsTable,
          Consent,
          $$ConsentsTableFilterComposer,
          $$ConsentsTableOrderingComposer,
          $$ConsentsTableAnnotationComposer,
          $$ConsentsTableCreateCompanionBuilder,
          $$ConsentsTableUpdateCompanionBuilder,
          (Consent, BaseReferences<_$AppDatabase, $ConsentsTable, Consent>),
          Consent,
          PrefetchHooks Function()
        > {
  $$ConsentsTableTableManager(_$AppDatabase db, $ConsentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<DateTime> grantedAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentsCompanion(
                id: id,
                childId: childId,
                version: version,
                grantedAt: grantedAt,
                revokedAt: revokedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String version,
                required DateTime grantedAt,
                Value<DateTime?> revokedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentsCompanion.insert(
                id: id,
                childId: childId,
                version: version,
                grantedAt: grantedAt,
                revokedAt: revokedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConsentsTable, Consent>(table),
                  BaseReferences<_$AppDatabase, $ConsentsTable, Consent>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsentsTable,
      Consent,
      $$ConsentsTableFilterComposer,
      $$ConsentsTableOrderingComposer,
      $$ConsentsTableAnnotationComposer,
      $$ConsentsTableCreateCompanionBuilder,
      $$ConsentsTableUpdateCompanionBuilder,
      (Consent, BaseReferences<_$AppDatabase, $ConsentsTable, Consent>),
      Consent,
      PrefetchHooks Function()
    >;
typedef $$PracticeSessionsTableCreateCompanionBuilder =
    PracticeSessionsCompanion Function({
      required String id,
      required String childId,
      required String kind,
      required int startLevel,
      Value<int?> endLevel,
      required int plannedWords,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> rowid,
    });
typedef $$PracticeSessionsTableUpdateCompanionBuilder =
    PracticeSessionsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> kind,
      Value<int> startLevel,
      Value<int?> endLevel,
      Value<int> plannedWords,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> rowid,
    });

class $$PracticeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startLevel => $composableBuilder(
    column: $table.startLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endLevel => $composableBuilder(
    column: $table.endLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedWords => $composableBuilder(
    column: $table.plannedWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PracticeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startLevel => $composableBuilder(
    column: $table.startLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endLevel => $composableBuilder(
    column: $table.endLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedWords => $composableBuilder(
    column: $table.plannedWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PracticeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get startLevel => $composableBuilder(
    column: $table.startLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endLevel =>
      $composableBuilder(column: $table.endLevel, builder: (column) => column);

  GeneratedColumn<int> get plannedWords => $composableBuilder(
    column: $table.plannedWords,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$PracticeSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeSessionsTable,
          PracticeSession,
          $$PracticeSessionsTableFilterComposer,
          $$PracticeSessionsTableOrderingComposer,
          $$PracticeSessionsTableAnnotationComposer,
          $$PracticeSessionsTableCreateCompanionBuilder,
          $$PracticeSessionsTableUpdateCompanionBuilder,
          (
            PracticeSession,
            BaseReferences<
              _$AppDatabase,
              $PracticeSessionsTable,
              PracticeSession
            >,
          ),
          PracticeSession,
          PrefetchHooks Function()
        > {
  $$PracticeSessionsTableTableManager(
    _$AppDatabase db,
    $PracticeSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> startLevel = const Value.absent(),
                Value<int?> endLevel = const Value.absent(),
                Value<int> plannedWords = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeSessionsCompanion(
                id: id,
                childId: childId,
                kind: kind,
                startLevel: startLevel,
                endLevel: endLevel,
                plannedWords: plannedWords,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String kind,
                required int startLevel,
                Value<int?> endLevel = const Value.absent(),
                required int plannedWords,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeSessionsCompanion.insert(
                id: id,
                childId: childId,
                kind: kind,
                startLevel: startLevel,
                endLevel: endLevel,
                plannedWords: plannedWords,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PracticeSessionsTable, PracticeSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PracticeSessionsTable,
                    PracticeSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PracticeSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeSessionsTable,
      PracticeSession,
      $$PracticeSessionsTableFilterComposer,
      $$PracticeSessionsTableOrderingComposer,
      $$PracticeSessionsTableAnnotationComposer,
      $$PracticeSessionsTableCreateCompanionBuilder,
      $$PracticeSessionsTableUpdateCompanionBuilder,
      (
        PracticeSession,
        BaseReferences<_$AppDatabase, $PracticeSessionsTable, PracticeSession>,
      ),
      PracticeSession,
      PrefetchHooks Function()
    >;
typedef $$AttemptsTableCreateCompanionBuilder = AttemptsCompanion Function({
  required String id,
  required String sessionId,
  required String childId,
  required String wordId,
  required int contentVersion,
  required int tryNumber,
  required String status,
  required String matchedSyllables,
  Value<double?> confidence,
  required String engine,
  required bool finished,
  required bool assisted,
  required bool guardianOverride,
  required DateTime occurredAt,
  Value<int> rowid,
});
typedef $$AttemptsTableUpdateCompanionBuilder = AttemptsCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> childId,
  Value<String> wordId,
  Value<int> contentVersion,
  Value<int> tryNumber,
  Value<String> status,
  Value<String> matchedSyllables,
  Value<double?> confidence,
  Value<String> engine,
  Value<bool> finished,
  Value<bool> assisted,
  Value<bool> guardianOverride,
  Value<DateTime> occurredAt,
  Value<int> rowid,
});

class $$AttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tryNumber => $composableBuilder(
    column: $table.tryNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchedSyllables => $composableBuilder(
    column: $table.matchedSyllables,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engine => $composableBuilder(
    column: $table.engine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get finished => $composableBuilder(
    column: $table.finished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get assisted => $composableBuilder(
    column: $table.assisted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get guardianOverride => $composableBuilder(
    column: $table.guardianOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tryNumber => $composableBuilder(
    column: $table.tryNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchedSyllables => $composableBuilder(
    column: $table.matchedSyllables,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engine => $composableBuilder(
    column: $table.engine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get finished => $composableBuilder(
    column: $table.finished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get assisted => $composableBuilder(
    column: $table.assisted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get guardianOverride => $composableBuilder(
    column: $table.guardianOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tryNumber =>
      $composableBuilder(column: $table.tryNumber, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get matchedSyllables => $composableBuilder(
    column: $table.matchedSyllables,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get engine =>
      $composableBuilder(column: $table.engine, builder: (column) => column);

  GeneratedColumn<bool> get finished =>
      $composableBuilder(column: $table.finished, builder: (column) => column);

  GeneratedColumn<bool> get assisted =>
      $composableBuilder(column: $table.assisted, builder: (column) => column);

  GeneratedColumn<bool> get guardianOverride => $composableBuilder(
    column: $table.guardianOverride,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$AttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptsTable,
          Attempt,
          $$AttemptsTableFilterComposer,
          $$AttemptsTableOrderingComposer,
          $$AttemptsTableAnnotationComposer,
          $$AttemptsTableCreateCompanionBuilder,
          $$AttemptsTableUpdateCompanionBuilder,
          (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
          Attempt,
          PrefetchHooks Function()
        > {
  $$AttemptsTableTableManager(_$AppDatabase db, $AttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<int> tryNumber = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> matchedSyllables = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> engine = const Value.absent(),
                Value<bool> finished = const Value.absent(),
                Value<bool> assisted = const Value.absent(),
                Value<bool> guardianOverride = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptsCompanion(
                id: id,
                sessionId: sessionId,
                childId: childId,
                wordId: wordId,
                contentVersion: contentVersion,
                tryNumber: tryNumber,
                status: status,
                matchedSyllables: matchedSyllables,
                confidence: confidence,
                engine: engine,
                finished: finished,
                assisted: assisted,
                guardianOverride: guardianOverride,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String childId,
                required String wordId,
                required int contentVersion,
                required int tryNumber,
                required String status,
                required String matchedSyllables,
                Value<double?> confidence = const Value.absent(),
                required String engine,
                required bool finished,
                required bool assisted,
                required bool guardianOverride,
                required DateTime occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => AttemptsCompanion.insert(
                id: id,
                sessionId: sessionId,
                childId: childId,
                wordId: wordId,
                contentVersion: contentVersion,
                tryNumber: tryNumber,
                status: status,
                matchedSyllables: matchedSyllables,
                confidence: confidence,
                engine: engine,
                finished: finished,
                assisted: assisted,
                guardianOverride: guardianOverride,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttemptsTable, Attempt>(table),
                  BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptsTable,
      Attempt,
      $$AttemptsTableFilterComposer,
      $$AttemptsTableOrderingComposer,
      $$AttemptsTableAnnotationComposer,
      $$AttemptsTableCreateCompanionBuilder,
      $$AttemptsTableUpdateCompanionBuilder,
      (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
      Attempt,
      PrefetchHooks Function()
    >;
typedef $$LevelEventsTableCreateCompanionBuilder =
    LevelEventsCompanion Function({
      required String id,
      required String childId,
      Value<int?> fromLevel,
      required int toLevel,
      required String reason,
      required String actor,
      required DateTime occurredAt,
      Value<int> rowid,
    });
typedef $$LevelEventsTableUpdateCompanionBuilder =
    LevelEventsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<int?> fromLevel,
      Value<int> toLevel,
      Value<String> reason,
      Value<String> actor,
      Value<DateTime> occurredAt,
      Value<int> rowid,
    });

class $$LevelEventsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelEventsTable> {
  $$LevelEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromLevel => $composableBuilder(
    column: $table.fromLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toLevel => $composableBuilder(
    column: $table.toLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelEventsTable> {
  $$LevelEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromLevel => $composableBuilder(
    column: $table.fromLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toLevel => $composableBuilder(
    column: $table.toLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelEventsTable> {
  $$LevelEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<int> get fromLevel =>
      $composableBuilder(column: $table.fromLevel, builder: (column) => column);

  GeneratedColumn<int> get toLevel =>
      $composableBuilder(column: $table.toLevel, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$LevelEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelEventsTable,
          LevelEvent,
          $$LevelEventsTableFilterComposer,
          $$LevelEventsTableOrderingComposer,
          $$LevelEventsTableAnnotationComposer,
          $$LevelEventsTableCreateCompanionBuilder,
          $$LevelEventsTableUpdateCompanionBuilder,
          (
            LevelEvent,
            BaseReferences<_$AppDatabase, $LevelEventsTable, LevelEvent>,
          ),
          LevelEvent,
          PrefetchHooks Function()
        > {
  $$LevelEventsTableTableManager(_$AppDatabase db, $LevelEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<int?> fromLevel = const Value.absent(),
                Value<int> toLevel = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelEventsCompanion(
                id: id,
                childId: childId,
                fromLevel: fromLevel,
                toLevel: toLevel,
                reason: reason,
                actor: actor,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                Value<int?> fromLevel = const Value.absent(),
                required int toLevel,
                required String reason,
                required String actor,
                required DateTime occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => LevelEventsCompanion.insert(
                id: id,
                childId: childId,
                fromLevel: fromLevel,
                toLevel: toLevel,
                reason: reason,
                actor: actor,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelEventsTable, LevelEvent>(table),
                  BaseReferences<_$AppDatabase, $LevelEventsTable, LevelEvent>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelEventsTable,
      LevelEvent,
      $$LevelEventsTableFilterComposer,
      $$LevelEventsTableOrderingComposer,
      $$LevelEventsTableAnnotationComposer,
      $$LevelEventsTableCreateCompanionBuilder,
      $$LevelEventsTableUpdateCompanionBuilder,
      (
        LevelEvent,
        BaseReferences<_$AppDatabase, $LevelEventsTable, LevelEvent>,
      ),
      LevelEvent,
      PrefetchHooks Function()
    >;
typedef $$StoryProgressTableCreateCompanionBuilder =
    StoryProgressCompanion Function({
      required String childId,
      required String storyId,
      required int page,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StoryProgressTableUpdateCompanionBuilder =
    StoryProgressCompanion Function({
      Value<String> childId,
      Value<String> storyId,
      Value<int> page,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$StoryProgressTableFilterComposer
    extends Composer<_$AppDatabase, $StoryProgressTable> {
  $$StoryProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyId => $composableBuilder(
    column: $table.storyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoryProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryProgressTable> {
  $$StoryProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyId => $composableBuilder(
    column: $table.storyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoryProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryProgressTable> {
  $$StoryProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get storyId =>
      $composableBuilder(column: $table.storyId, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StoryProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryProgressTable,
          StoryProgressData,
          $$StoryProgressTableFilterComposer,
          $$StoryProgressTableOrderingComposer,
          $$StoryProgressTableAnnotationComposer,
          $$StoryProgressTableCreateCompanionBuilder,
          $$StoryProgressTableUpdateCompanionBuilder,
          (
            StoryProgressData,
            BaseReferences<
              _$AppDatabase,
              $StoryProgressTable,
              StoryProgressData
            >,
          ),
          StoryProgressData,
          PrefetchHooks Function()
        > {
  $$StoryProgressTableTableManager(_$AppDatabase db, $StoryProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> childId = const Value.absent(),
                Value<String> storyId = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryProgressCompanion(
                childId: childId,
                storyId: storyId,
                page: page,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String childId,
                required String storyId,
                required int page,
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryProgressCompanion.insert(
                childId: childId,
                storyId: storyId,
                page: page,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoryProgressTable, StoryProgressData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StoryProgressTable,
                    StoryProgressData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoryProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryProgressTable,
      StoryProgressData,
      $$StoryProgressTableFilterComposer,
      $$StoryProgressTableOrderingComposer,
      $$StoryProgressTableAnnotationComposer,
      $$StoryProgressTableCreateCompanionBuilder,
      $$StoryProgressTableUpdateCompanionBuilder,
      (
        StoryProgressData,
        BaseReferences<_$AppDatabase, $StoryProgressTable, StoryProgressData>,
      ),
      StoryProgressData,
      PrefetchHooks Function()
    >;
typedef $$RewardEventsTableCreateCompanionBuilder =
    RewardEventsCompanion Function({
      required String id,
      required String childId,
      required String kind,
      required String sourceId,
      required DateTime occurredAt,
      Value<int> rowid,
    });
typedef $$RewardEventsTableUpdateCompanionBuilder =
    RewardEventsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> kind,
      Value<String> sourceId,
      Value<DateTime> occurredAt,
      Value<int> rowid,
    });

class $$RewardEventsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardEventsTable> {
  $$RewardEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardEventsTable> {
  $$RewardEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardEventsTable> {
  $$RewardEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$RewardEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardEventsTable,
          RewardEvent,
          $$RewardEventsTableFilterComposer,
          $$RewardEventsTableOrderingComposer,
          $$RewardEventsTableAnnotationComposer,
          $$RewardEventsTableCreateCompanionBuilder,
          $$RewardEventsTableUpdateCompanionBuilder,
          (
            RewardEvent,
            BaseReferences<_$AppDatabase, $RewardEventsTable, RewardEvent>,
          ),
          RewardEvent,
          PrefetchHooks Function()
        > {
  $$RewardEventsTableTableManager(_$AppDatabase db, $RewardEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardEventsCompanion(
                id: id,
                childId: childId,
                kind: kind,
                sourceId: sourceId,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String kind,
                required String sourceId,
                required DateTime occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardEventsCompanion.insert(
                id: id,
                childId: childId,
                kind: kind,
                sourceId: sourceId,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardEventsTable, RewardEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RewardEventsTable,
                    RewardEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardEventsTable,
      RewardEvent,
      $$RewardEventsTableFilterComposer,
      $$RewardEventsTableOrderingComposer,
      $$RewardEventsTableAnnotationComposer,
      $$RewardEventsTableCreateCompanionBuilder,
      $$RewardEventsTableUpdateCompanionBuilder,
      (
        RewardEvent,
        BaseReferences<_$AppDatabase, $RewardEventsTable, RewardEvent>,
      ),
      RewardEvent,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  required String targetTable,
  required String payload,
  Value<int> tries,
  Value<DateTime?> nextRetryAt,
  Value<String?> rejectedReason,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  Value<String> targetTable,
  Value<String> payload,
  Value<int> tries,
  Value<DateTime?> nextRetryAt,
  Value<String?> rejectedReason,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tries => $composableBuilder(
    column: $table.tries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectedReason => $composableBuilder(
    column: $table.rejectedReason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tries => $composableBuilder(
    column: $table.tries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectedReason => $composableBuilder(
    column: $table.rejectedReason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get tries =>
      $composableBuilder(column: $table.tries, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectedReason => $composableBuilder(
    column: $table.rejectedReason,
    builder: (column) => column,
  );
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> tries = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> rejectedReason = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                targetTable: targetTable,
                payload: payload,
                tries: tries,
                nextRetryAt: nextRetryAt,
                rejectedReason: rejectedReason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String payload,
                Value<int> tries = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> rejectedReason = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                targetTable: targetTable,
                payload: payload,
                tries: tries,
                nextRetryAt: nextRetryAt,
                rejectedReason: rejectedReason,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxData>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;
typedef $$KeyValuesTableCreateCompanionBuilder = KeyValuesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValuesTableUpdateCompanionBuilder = KeyValuesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValuesTableFilterComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeyValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeyValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeyValuesTable,
          KeyValue,
          $$KeyValuesTableFilterComposer,
          $$KeyValuesTableOrderingComposer,
          $$KeyValuesTableAnnotationComposer,
          $$KeyValuesTableCreateCompanionBuilder,
          $$KeyValuesTableUpdateCompanionBuilder,
          (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
          KeyValue,
          PrefetchHooks Function()
        > {
  $$KeyValuesTableTableManager(_$AppDatabase db, $KeyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KeyValuesTable, KeyValue>(table),
                  BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeyValuesTable,
      KeyValue,
      $$KeyValuesTableFilterComposer,
      $$KeyValuesTableOrderingComposer,
      $$KeyValuesTableAnnotationComposer,
      $$KeyValuesTableCreateCompanionBuilder,
      $$KeyValuesTableUpdateCompanionBuilder,
      (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
      KeyValue,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$ConsentsTableTableManager get consents =>
      $$ConsentsTableTableManager(_db, _db.consents);
  $$PracticeSessionsTableTableManager get practiceSessions =>
      $$PracticeSessionsTableTableManager(_db, _db.practiceSessions);
  $$AttemptsTableTableManager get attempts =>
      $$AttemptsTableTableManager(_db, _db.attempts);
  $$LevelEventsTableTableManager get levelEvents =>
      $$LevelEventsTableTableManager(_db, _db.levelEvents);
  $$StoryProgressTableTableManager get storyProgress =>
      $$StoryProgressTableTableManager(_db, _db.storyProgress);
  $$RewardEventsTableTableManager get rewardEvents =>
      $$RewardEventsTableTableManager(_db, _db.rewardEvents);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$KeyValuesTableTableManager get keyValues =>
      $$KeyValuesTableTableManager(_db, _db.keyValues);
}
