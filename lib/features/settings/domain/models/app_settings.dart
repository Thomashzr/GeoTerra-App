import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// Languages supported by the application. More locales can be added without
/// changing the settings persistence contract.
enum AppLanguage { spanish }

enum AppThemeMode { system, light, dark }

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(0.8) double volume,
    @Default(AppLanguage.spanish) AppLanguage language,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
  }) = _AppSettings;

  const AppSettings._();

  static const defaults = AppSettings();

  /// Defensive normalization for values read from older/corrupt storage.
  AppSettings get normalized =>
      copyWith(volume: volume.clamp(0.0, 1.0).toDouble());
}

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(AppSettings.defaults) AppSettings settings,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SettingsState;
}
