import 'package:hive_flutter/hive_flutter.dart';

import '../models/settings_dto.dart';

/// Abstract contract for local persistent storage of application settings.
abstract interface class SettingsLocalDataSource {
  /// Reads settings DTO from local storage.
  Future<SettingsDto> getSettings();

  /// Persists settings DTO to local storage.
  Future<void> saveSettings(SettingsDto settings);
}

/// Hive implementation of [SettingsLocalDataSource].
class SettingsHiveLocalDataSource implements SettingsLocalDataSource {
  const SettingsHiveLocalDataSource(this._box);

  final Box<dynamic> _box;

  static const String boxName = 'settings_box';
  static const String keyVolume = 'volume';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';

  /// Helper to open the settings Hive box if not already opened.
  static Future<Box<dynamic>> openBox({HiveInterface? hive}) async {
    final hiveInstance = hive ?? Hive;
    if (hiveInstance.isBoxOpen(boxName)) {
      return hiveInstance.box<dynamic>(boxName);
    }
    return await hiveInstance.openBox<dynamic>(boxName);
  }

  @override
  Future<SettingsDto> getSettings() async {
    try {
      final dynamic rawVolume = _box.get(keyVolume);
      final dynamic rawLanguage = _box.get(keyLanguage);
      final dynamic rawThemeMode = _box.get(keyThemeMode);

      final double? volume = switch (rawVolume) {
        num n => n.toDouble(),
        String s => double.tryParse(s),
        _ => null,
      };

      final String? language = rawLanguage is String ? rawLanguage : null;
      final String? themeMode = rawThemeMode is String ? rawThemeMode : null;

      return SettingsDto(
        volume: volume,
        language: language,
        themeMode: themeMode,
      );
    } catch (_) {
      // In case of read/box corruption, return empty DTO falling back to defaults.
      return const SettingsDto();
    }
  }

  @override
  Future<void> saveSettings(SettingsDto settings) async {
    await _box.put(keyVolume, settings.volume);
    await _box.put(keyLanguage, settings.language);
    await _box.put(keyThemeMode, settings.themeMode);
  }
}
