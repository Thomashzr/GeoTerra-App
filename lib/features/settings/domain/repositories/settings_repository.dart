import '../models/app_settings.dart';

/// Contract for loading and persisting application settings.
abstract interface class SettingsRepository {
  /// Loads persisted settings or returns defaults when uninitialized or corrupted.
  Future<AppSettings> load();

  /// Persists settings to storage.
  Future<void> save(AppSettings settings);
}
