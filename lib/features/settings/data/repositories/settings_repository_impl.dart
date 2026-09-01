import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/settings_dto.dart';

/// Implementation of [SettingsRepository] backing persistence via [SettingsLocalDataSource].
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  /// Convenience factory to instantiate repository directly from a Hive [Box].
  factory SettingsRepositoryImpl.fromBox(Box<dynamic> box) {
    return SettingsRepositoryImpl(SettingsHiveLocalDataSource(box));
  }

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<AppSettings> load() async {
    try {
      final dto = await _localDataSource.getSettings();
      return dto.toDomain();
    } catch (_) {
      // In case of storage read issues, fallback gracefully to default values.
      return AppSettings.defaults;
    }
  }

  @override
  Future<void> save(AppSettings settings) async {
    final normalized = settings.normalized;
    final dto = SettingsDto.fromDomain(normalized);
    await _localDataSource.saveSettings(dto);
  }
}
