import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:geoquiz_app/features/settings/data/models/settings_dto.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FakeBox implements Box<dynamic> {
  final Map<dynamic, dynamic> _store = {};
  bool throwOnRead = false;

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    if (throwOnRead) throw StateError('Hive read error');
    return _store[key] ?? defaultValue;
  }

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _store[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SettingsHiveLocalDataSource', () {
    late FakeBox fakeBox;
    late SettingsHiveLocalDataSource dataSource;

    setUp(() {
      fakeBox = FakeBox();
      dataSource = SettingsHiveLocalDataSource(fakeBox);
    });

    test('getSettings returns empty DTO on uninitialized box', () async {
      final dto = await dataSource.getSettings();

      expect(dto.volume, isNull);
      expect(dto.language, isNull);
      expect(dto.themeMode, isNull);

      final domain = dto.toDomain();
      expect(domain.volume, 0.8);
    });

    test(
      'saveSettings persists values correctly and getSettings retrieves them',
      () async {
        const dto = SettingsDto(
          volume: 0.4,
          language: 'spanish',
          themeMode: 'dark',
        );

        await dataSource.saveSettings(dto);
        final retrieved = await dataSource.getSettings();

        expect(retrieved.volume, 0.4);
        expect(retrieved.language, 'spanish');
        expect(retrieved.themeMode, 'dark');
      },
    );

    test('getSettings gracefully tolerates read exceptions', () async {
      fakeBox.throwOnRead = true;
      final dto = await dataSource.getSettings();

      expect(dto.volume, isNull);
      expect(dto.language, isNull);
      expect(dto.themeMode, isNull);
    });
  });
}
