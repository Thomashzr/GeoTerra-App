import 'package:drift/drift.dart';

class Countries extends Table {
  @override
  String get tableName => 'countries';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get isoCode =>
      text().named('iso_code').withLength(min: 2, max: 2)();

  TextColumn get nameEs => text().named('name_es')();

  TextColumn get capitalEs => text().named('capital_es')();

  TextColumn get continent => text()();

  IntColumn get difficulty => integer()();

  TextColumn get flagAssetPath => text().named('flag_asset_path')();
}
