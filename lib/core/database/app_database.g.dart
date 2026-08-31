// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CountriesTable extends Countries
    with TableInfo<$CountriesTable, Country> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _isoCodeMeta = const VerificationMeta(
    'isoCode',
  );
  @override
  late final GeneratedColumn<String> isoCode = GeneratedColumn<String>(
    'iso_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEsMeta = const VerificationMeta('nameEs');
  @override
  late final GeneratedColumn<String> nameEs = GeneratedColumn<String>(
    'name_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capitalEsMeta = const VerificationMeta(
    'capitalEs',
  );
  @override
  late final GeneratedColumn<String> capitalEs = GeneratedColumn<String>(
    'capital_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _continentMeta = const VerificationMeta(
    'continent',
  );
  @override
  late final GeneratedColumn<String> continent = GeneratedColumn<String>(
    'continent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagAssetPathMeta = const VerificationMeta(
    'flagAssetPath',
  );
  @override
  late final GeneratedColumn<String> flagAssetPath = GeneratedColumn<String>(
    'flag_asset_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isoCode,
    nameEs,
    capitalEs,
    continent,
    difficulty,
    flagAssetPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'countries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Country> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('iso_code')) {
      context.handle(
        _isoCodeMeta,
        isoCode.isAcceptableOrUnknown(data['iso_code']!, _isoCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_isoCodeMeta);
    }
    if (data.containsKey('name_es')) {
      context.handle(
        _nameEsMeta,
        nameEs.isAcceptableOrUnknown(data['name_es']!, _nameEsMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEsMeta);
    }
    if (data.containsKey('capital_es')) {
      context.handle(
        _capitalEsMeta,
        capitalEs.isAcceptableOrUnknown(data['capital_es']!, _capitalEsMeta),
      );
    } else if (isInserting) {
      context.missing(_capitalEsMeta);
    }
    if (data.containsKey('continent')) {
      context.handle(
        _continentMeta,
        continent.isAcceptableOrUnknown(data['continent']!, _continentMeta),
      );
    } else if (isInserting) {
      context.missing(_continentMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('flag_asset_path')) {
      context.handle(
        _flagAssetPathMeta,
        flagAssetPath.isAcceptableOrUnknown(
          data['flag_asset_path']!,
          _flagAssetPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_flagAssetPathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Country map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Country(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isoCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iso_code'],
      )!,
      nameEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_es'],
      )!,
      capitalEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capital_es'],
      )!,
      continent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}continent'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      flagAssetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_asset_path'],
      )!,
    );
  }

  @override
  $CountriesTable createAlias(String alias) {
    return $CountriesTable(attachedDatabase, alias);
  }
}

class Country extends DataClass implements Insertable<Country> {
  final int id;
  final String isoCode;
  final String nameEs;
  final String capitalEs;
  final String continent;
  final int difficulty;
  final String flagAssetPath;
  const Country({
    required this.id,
    required this.isoCode,
    required this.nameEs,
    required this.capitalEs,
    required this.continent,
    required this.difficulty,
    required this.flagAssetPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['iso_code'] = Variable<String>(isoCode);
    map['name_es'] = Variable<String>(nameEs);
    map['capital_es'] = Variable<String>(capitalEs);
    map['continent'] = Variable<String>(continent);
    map['difficulty'] = Variable<int>(difficulty);
    map['flag_asset_path'] = Variable<String>(flagAssetPath);
    return map;
  }

  CountriesCompanion toCompanion(bool nullToAbsent) {
    return CountriesCompanion(
      id: Value(id),
      isoCode: Value(isoCode),
      nameEs: Value(nameEs),
      capitalEs: Value(capitalEs),
      continent: Value(continent),
      difficulty: Value(difficulty),
      flagAssetPath: Value(flagAssetPath),
    );
  }

  factory Country.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Country(
      id: serializer.fromJson<int>(json['id']),
      isoCode: serializer.fromJson<String>(json['isoCode']),
      nameEs: serializer.fromJson<String>(json['nameEs']),
      capitalEs: serializer.fromJson<String>(json['capitalEs']),
      continent: serializer.fromJson<String>(json['continent']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      flagAssetPath: serializer.fromJson<String>(json['flagAssetPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isoCode': serializer.toJson<String>(isoCode),
      'nameEs': serializer.toJson<String>(nameEs),
      'capitalEs': serializer.toJson<String>(capitalEs),
      'continent': serializer.toJson<String>(continent),
      'difficulty': serializer.toJson<int>(difficulty),
      'flagAssetPath': serializer.toJson<String>(flagAssetPath),
    };
  }

  Country copyWith({
    int? id,
    String? isoCode,
    String? nameEs,
    String? capitalEs,
    String? continent,
    int? difficulty,
    String? flagAssetPath,
  }) => Country(
    id: id ?? this.id,
    isoCode: isoCode ?? this.isoCode,
    nameEs: nameEs ?? this.nameEs,
    capitalEs: capitalEs ?? this.capitalEs,
    continent: continent ?? this.continent,
    difficulty: difficulty ?? this.difficulty,
    flagAssetPath: flagAssetPath ?? this.flagAssetPath,
  );
  Country copyWithCompanion(CountriesCompanion data) {
    return Country(
      id: data.id.present ? data.id.value : this.id,
      isoCode: data.isoCode.present ? data.isoCode.value : this.isoCode,
      nameEs: data.nameEs.present ? data.nameEs.value : this.nameEs,
      capitalEs: data.capitalEs.present ? data.capitalEs.value : this.capitalEs,
      continent: data.continent.present ? data.continent.value : this.continent,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      flagAssetPath: data.flagAssetPath.present
          ? data.flagAssetPath.value
          : this.flagAssetPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Country(')
          ..write('id: $id, ')
          ..write('isoCode: $isoCode, ')
          ..write('nameEs: $nameEs, ')
          ..write('capitalEs: $capitalEs, ')
          ..write('continent: $continent, ')
          ..write('difficulty: $difficulty, ')
          ..write('flagAssetPath: $flagAssetPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isoCode,
    nameEs,
    capitalEs,
    continent,
    difficulty,
    flagAssetPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Country &&
          other.id == this.id &&
          other.isoCode == this.isoCode &&
          other.nameEs == this.nameEs &&
          other.capitalEs == this.capitalEs &&
          other.continent == this.continent &&
          other.difficulty == this.difficulty &&
          other.flagAssetPath == this.flagAssetPath);
}

class CountriesCompanion extends UpdateCompanion<Country> {
  final Value<int> id;
  final Value<String> isoCode;
  final Value<String> nameEs;
  final Value<String> capitalEs;
  final Value<String> continent;
  final Value<int> difficulty;
  final Value<String> flagAssetPath;
  const CountriesCompanion({
    this.id = const Value.absent(),
    this.isoCode = const Value.absent(),
    this.nameEs = const Value.absent(),
    this.capitalEs = const Value.absent(),
    this.continent = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.flagAssetPath = const Value.absent(),
  });
  CountriesCompanion.insert({
    this.id = const Value.absent(),
    required String isoCode,
    required String nameEs,
    required String capitalEs,
    required String continent,
    required int difficulty,
    required String flagAssetPath,
  }) : isoCode = Value(isoCode),
       nameEs = Value(nameEs),
       capitalEs = Value(capitalEs),
       continent = Value(continent),
       difficulty = Value(difficulty),
       flagAssetPath = Value(flagAssetPath);
  static Insertable<Country> custom({
    Expression<int>? id,
    Expression<String>? isoCode,
    Expression<String>? nameEs,
    Expression<String>? capitalEs,
    Expression<String>? continent,
    Expression<int>? difficulty,
    Expression<String>? flagAssetPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isoCode != null) 'iso_code': isoCode,
      if (nameEs != null) 'name_es': nameEs,
      if (capitalEs != null) 'capital_es': capitalEs,
      if (continent != null) 'continent': continent,
      if (difficulty != null) 'difficulty': difficulty,
      if (flagAssetPath != null) 'flag_asset_path': flagAssetPath,
    });
  }

  CountriesCompanion copyWith({
    Value<int>? id,
    Value<String>? isoCode,
    Value<String>? nameEs,
    Value<String>? capitalEs,
    Value<String>? continent,
    Value<int>? difficulty,
    Value<String>? flagAssetPath,
  }) {
    return CountriesCompanion(
      id: id ?? this.id,
      isoCode: isoCode ?? this.isoCode,
      nameEs: nameEs ?? this.nameEs,
      capitalEs: capitalEs ?? this.capitalEs,
      continent: continent ?? this.continent,
      difficulty: difficulty ?? this.difficulty,
      flagAssetPath: flagAssetPath ?? this.flagAssetPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isoCode.present) {
      map['iso_code'] = Variable<String>(isoCode.value);
    }
    if (nameEs.present) {
      map['name_es'] = Variable<String>(nameEs.value);
    }
    if (capitalEs.present) {
      map['capital_es'] = Variable<String>(capitalEs.value);
    }
    if (continent.present) {
      map['continent'] = Variable<String>(continent.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (flagAssetPath.present) {
      map['flag_asset_path'] = Variable<String>(flagAssetPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountriesCompanion(')
          ..write('id: $id, ')
          ..write('isoCode: $isoCode, ')
          ..write('nameEs: $nameEs, ')
          ..write('capitalEs: $capitalEs, ')
          ..write('continent: $continent, ')
          ..write('difficulty: $difficulty, ')
          ..write('flagAssetPath: $flagAssetPath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CountriesTable countries = $CountriesTable(this);
  late final CountryDao countryDao = CountryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [countries];
}

typedef $$CountriesTableCreateCompanionBuilder = CountriesCompanion Function({
  Value<int> id,
  required String isoCode,
  required String nameEs,
  required String capitalEs,
  required String continent,
  required int difficulty,
  required String flagAssetPath,
});
typedef $$CountriesTableUpdateCompanionBuilder = CountriesCompanion Function({
  Value<int> id,
  Value<String> isoCode,
  Value<String> nameEs,
  Value<String> capitalEs,
  Value<String> continent,
  Value<int> difficulty,
  Value<String> flagAssetPath,
});

class $$CountriesTableFilterComposer
    extends Composer<_$AppDatabase, $CountriesTable> {
  $$CountriesTableFilterComposer({
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

  ColumnFilters<String> get isoCode => $composableBuilder(
    column: $table.isoCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEs => $composableBuilder(
    column: $table.nameEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capitalEs => $composableBuilder(
    column: $table.capitalEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get continent => $composableBuilder(
    column: $table.continent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flagAssetPath => $composableBuilder(
    column: $table.flagAssetPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CountriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CountriesTable> {
  $$CountriesTableOrderingComposer({
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

  ColumnOrderings<String> get isoCode => $composableBuilder(
    column: $table.isoCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEs => $composableBuilder(
    column: $table.nameEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capitalEs => $composableBuilder(
    column: $table.capitalEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get continent => $composableBuilder(
    column: $table.continent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagAssetPath => $composableBuilder(
    column: $table.flagAssetPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CountriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CountriesTable> {
  $$CountriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get isoCode =>
      $composableBuilder(column: $table.isoCode, builder: (column) => column);

  GeneratedColumn<String> get nameEs =>
      $composableBuilder(column: $table.nameEs, builder: (column) => column);

  GeneratedColumn<String> get capitalEs =>
      $composableBuilder(column: $table.capitalEs, builder: (column) => column);

  GeneratedColumn<String> get continent =>
      $composableBuilder(column: $table.continent, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flagAssetPath => $composableBuilder(
    column: $table.flagAssetPath,
    builder: (column) => column,
  );
}

class $$CountriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CountriesTable,
          Country,
          $$CountriesTableFilterComposer,
          $$CountriesTableOrderingComposer,
          $$CountriesTableAnnotationComposer,
          $$CountriesTableCreateCompanionBuilder,
          $$CountriesTableUpdateCompanionBuilder,
          (Country, BaseReferences<_$AppDatabase, $CountriesTable, Country>),
          Country,
          PrefetchHooks Function()
        > {
  $$CountriesTableTableManager(_$AppDatabase db, $CountriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CountriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CountriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CountriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> isoCode = const Value.absent(),
                Value<String> nameEs = const Value.absent(),
                Value<String> capitalEs = const Value.absent(),
                Value<String> continent = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> flagAssetPath = const Value.absent(),
              }) => CountriesCompanion(
                id: id,
                isoCode: isoCode,
                nameEs: nameEs,
                capitalEs: capitalEs,
                continent: continent,
                difficulty: difficulty,
                flagAssetPath: flagAssetPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String isoCode,
                required String nameEs,
                required String capitalEs,
                required String continent,
                required int difficulty,
                required String flagAssetPath,
              }) => CountriesCompanion.insert(
                id: id,
                isoCode: isoCode,
                nameEs: nameEs,
                capitalEs: capitalEs,
                continent: continent,
                difficulty: difficulty,
                flagAssetPath: flagAssetPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CountriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CountriesTable,
      Country,
      $$CountriesTableFilterComposer,
      $$CountriesTableOrderingComposer,
      $$CountriesTableAnnotationComposer,
      $$CountriesTableCreateCompanionBuilder,
      $$CountriesTableUpdateCompanionBuilder,
      (Country, BaseReferences<_$AppDatabase, $CountriesTable, Country>),
      Country,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CountriesTableTableManager get countries =>
      $$CountriesTableTableManager(_db, _db.countries);
}
