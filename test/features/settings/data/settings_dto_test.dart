import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/features/settings/data/models/settings_dto.dart';
import 'package:geoquiz_app/features/settings/domain/models/app_settings.dart';

void main() {
  group('SettingsDto', () {
    test('converts from AppSettings domain accurately', () {
      const domain = AppSettings(
        volume: 0.5,
        themeMode: AppThemeMode.dark,
        language: AppLanguage.spanish,
      );

      final dto = SettingsDto.fromDomain(domain);

      expect(dto.volume, 0.5);
      expect(dto.themeMode, 'dark');
      expect(dto.language, 'spanish');
    });

    test('toDomain applies defaults on empty/null values', () {
      const dto = SettingsDto();
      final domain = dto.toDomain();

      expect(domain.volume, 0.8);
      expect(domain.themeMode, AppThemeMode.system);
      expect(domain.language, AppLanguage.spanish);
    });

    test(
      'toDomain normalizes out-of-range volume and unrecognized enum values',
      () {
        const dto = SettingsDto(
          volume: 3.5,
          themeMode: 'invalid_mode',
          language: 'unsupported_lang',
        );

        final domain = dto.toDomain();

        expect(domain.volume, 1.0);
        expect(domain.themeMode, AppThemeMode.system);
        expect(domain.language, AppLanguage.spanish);
      },
    );

    test('handles negative volume by clamping to 0.0', () {
      const dto = SettingsDto(volume: -0.5);
      final domain = dto.toDomain();

      expect(domain.volume, 0.0);
    });

    test('fromMap and toMap serialize and deserialize properly', () {
      final map = {
        'volume': 0.65,
        'language': 'spanish',
        'theme_mode': 'light',
      };

      final dto = SettingsDto.fromMap(map);
      expect(dto.volume, 0.65);
      expect(dto.language, 'spanish');
      expect(dto.themeMode, 'light');

      final serialized = dto.toMap();
      expect(serialized['volume'], 0.65);
      expect(serialized['language'], 'spanish');
      expect(serialized['theme_mode'], 'light');
    });

    test('fromMap gracefully tolerates corrupted data types', () {
      final corruptedMap = {
        'volume': 'not_a_number',
        'language': 12345,
        'theme_mode': true,
      };

      final dto = SettingsDto.fromMap(corruptedMap);
      final domain = dto.toDomain();

      expect(domain.volume, 0.8);
      expect(domain.themeMode, AppThemeMode.system);
      expect(domain.language, AppLanguage.spanish);
    });
  });
}
