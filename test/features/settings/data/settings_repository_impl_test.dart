import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:geoquiz_app/features/settings/data/models/settings_dto.dart';
import 'package:geoquiz_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:geoquiz_app/features/settings/domain/models/app_settings.dart';

class FakeLocalDataSource implements SettingsLocalDataSource {
  FakeLocalDataSource({this.storedDto = const SettingsDto()});

  SettingsDto storedDto;
  bool throwOnGet = false;
  bool throwOnSave = false;

  @override
  Future<SettingsDto> getSettings() async {
    if (throwOnGet) throw StateError('DataSource read failure');
    return storedDto;
  }

  @override
  Future<void> saveSettings(SettingsDto settings) async {
    if (throwOnSave) throw StateError('DataSource write failure');
    storedDto = settings;
  }
}

void main() {
  group('SettingsRepositoryImpl', () {
    late FakeLocalDataSource fakeDataSource;
    late SettingsRepositoryImpl repository;

    setUp(() {
      fakeDataSource = FakeLocalDataSource();
      repository = SettingsRepositoryImpl(fakeDataSource);
    });

    test('load returns defaults when datasource has empty DTO', () async {
      final settings = await repository.load();

      expect(settings.volume, 0.8);
      expect(settings.themeMode, AppThemeMode.system);
      expect(settings.language, AppLanguage.spanish);
    });

    test('load returns stored settings mapped to domain', () async {
      fakeDataSource.storedDto = const SettingsDto(
        volume: 0.3,
        language: 'spanish',
        themeMode: 'light',
      );

      final settings = await repository.load();

      expect(settings.volume, 0.3);
      expect(settings.themeMode, AppThemeMode.light);
      expect(settings.language, AppLanguage.spanish);
    });

    test('load returns AppSettings.defaults when datasource throws', () async {
      fakeDataSource.throwOnGet = true;

      final settings = await repository.load();

      expect(settings, AppSettings.defaults);
    });

    test('save normalizes settings and passes DTO to datasource', () async {
      const settings = AppSettings(
        volume: 1.5, // should be normalized / clamped to 1.0
        themeMode: AppThemeMode.dark,
        language: AppLanguage.spanish,
      );

      await repository.save(settings);

      expect(fakeDataSource.storedDto.volume, 1.0);
      expect(fakeDataSource.storedDto.themeMode, 'dark');
      expect(fakeDataSource.storedDto.language, 'spanish');
    });

    test('save propagates exceptions if datasource fails', () async {
      fakeDataSource.throwOnSave = true;

      expect(
        () => repository.save(AppSettings.defaults),
        throwsA(isA<StateError>()),
      );
    });
  });
}
