import '../../domain/models/app_settings.dart';

/// Data Transfer Object representing the persisted shape of settings in storage.
class SettingsDto {
  const SettingsDto({this.volume, this.language, this.themeMode});

  final double? volume;
  final String? language;
  final String? themeMode;

  /// Creates a [SettingsDto] from a Map representation (e.g. Hive or JSON).
  factory SettingsDto.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const SettingsDto();

    final dynamic rawVolume = map['volume'];
    final double? volume = switch (rawVolume) {
      num n => n.toDouble(),
      String s => double.tryParse(s),
      _ => null,
    };

    final String? language = map['language'] is String
        ? map['language'] as String
        : null;

    final String? themeMode = map['theme_mode'] is String
        ? map['theme_mode'] as String
        : null;

    return SettingsDto(
      volume: volume,
      language: language,
      themeMode: themeMode,
    );
  }

  /// Creates a [SettingsDto] from the domain model [AppSettings].
  factory SettingsDto.fromDomain(AppSettings domain) {
    return SettingsDto(
      volume: domain.volume,
      language: domain.language.name,
      themeMode: domain.themeMode.name,
    );
  }

  /// Converts the DTO into a serializable Map.
  Map<String, dynamic> toMap() {
    return {'volume': volume, 'language': language, 'theme_mode': themeMode};
  }

  /// Maps the DTO to the clean domain model [AppSettings] with fallback defaults.
  AppSettings toDomain() {
    final double parsedVolume = (volume ?? AppSettings.defaults.volume)
        .clamp(0.0, 1.0)
        .toDouble();

    final AppThemeMode parsedThemeMode = switch (themeMode
        ?.toLowerCase()
        .trim()) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      'system' => AppThemeMode.system,
      _ => AppSettings.defaults.themeMode,
    };

    final AppLanguage parsedLanguage = switch (language?.toLowerCase().trim()) {
      'spanish' || 'es' => AppLanguage.spanish,
      _ => AppSettings.defaults.language,
    };

    return AppSettings(
      volume: parsedVolume,
      themeMode: parsedThemeMode,
      language: parsedLanguage,
    );
  }
}
