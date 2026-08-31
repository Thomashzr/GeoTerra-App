import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'daos/country_dao.dart';
import 'tables/countries_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Countries], daos: [CountryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final databaseFile = File(path.join(supportDirectory.path, 'countries.db'));

    if (!await databaseFile.exists()) {
      await databaseFile.parent.create(recursive: true);
      final asset = await rootBundle.load('assets/data/countries.db');
      await databaseFile.writeAsBytes(
        asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes),
        flush: true,
      );
    }

    return NativeDatabase(databaseFile);
  });
}
