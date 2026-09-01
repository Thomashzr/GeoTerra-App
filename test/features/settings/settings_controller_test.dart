import 'package:flutter_test/flutter_test.dart';

import 'package:geoquiz_app/features/settings/domain/models/app_settings.dart';
import 'package:geoquiz_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:geoquiz_app/features/settings/presentation/controllers/settings_controller.dart';

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository(this.loaded);

  AppSettings loaded;
  final saved = <AppSettings>[];
  bool failLoad = false;
  bool failSave = false;

  @override
  Future<AppSettings> load() async {
    if (failLoad) throw StateError('load failed');
    return loaded;
  }

  @override
  Future<void> save(AppSettings settings) async {
    if (failSave) throw StateError('save failed');
    saved.add(settings);
    loaded = settings;
  }
}

void main() {
  test('starts with product defaults', () {
    final notifier = SettingsNotifier(
      FakeSettingsRepository(const AppSettings()),
      loadOnCreate: false,
    );
    addTearDown(notifier.dispose);

    expect(notifier.state.settings.volume, 0.8);
    expect(notifier.state.settings.language, AppLanguage.spanish);
    expect(notifier.state.settings.themeMode, AppThemeMode.system);
  });

  test('loads and normalizes persisted settings', () async {
    final repository = FakeSettingsRepository(
      const AppSettings(volume: 2, themeMode: AppThemeMode.dark),
    );
    final notifier = SettingsNotifier(repository, loadOnCreate: false);
    addTearDown(notifier.dispose);

    await notifier.load();

    expect(notifier.state.settings.volume, 1.0);
    expect(notifier.state.settings.themeMode, AppThemeMode.dark);
    expect(notifier.state.isLoading, isFalse);
  });

  test('clamps volume and persists changes', () async {
    final repository = FakeSettingsRepository(const AppSettings());
    final notifier = SettingsNotifier(repository, loadOnCreate: false);
    addTearDown(notifier.dispose);

    await notifier.setVolume(-1);
    expect(notifier.state.settings.volume, 0.0);
    await notifier.setVolume(2);
    expect(notifier.state.settings.volume, 1.0);
    expect(repository.saved, hasLength(2));
  });

  test('persists theme and supported language', () async {
    final repository = FakeSettingsRepository(const AppSettings());
    final notifier = SettingsNotifier(repository, loadOnCreate: false);
    addTearDown(notifier.dispose);

    await notifier.setThemeMode(AppThemeMode.light);
    await notifier.setLanguage(AppLanguage.spanish);

    expect(notifier.state.settings.themeMode, AppThemeMode.light);
    expect(notifier.state.settings.language, AppLanguage.spanish);
    expect(repository.loaded.themeMode, AppThemeMode.light);
  });

  test('keeps defaults and exposes load error when storage fails', () async {
    final repository = FakeSettingsRepository(const AppSettings())
      ..failLoad = true;
    final notifier = SettingsNotifier(repository, loadOnCreate: false);
    addTearDown(notifier.dispose);

    await notifier.load();

    expect(notifier.state.settings, AppSettings.defaults);
    expect(notifier.state.errorMessage, isNotNull);
    expect(notifier.state.isLoading, isFalse);
  });

  test('rolls back an optimistic update when save fails', () async {
    final repository = FakeSettingsRepository(const AppSettings())
      ..failSave = true;
    final notifier = SettingsNotifier(repository, loadOnCreate: false);
    addTearDown(notifier.dispose);

    await notifier.setThemeMode(AppThemeMode.dark);

    expect(notifier.state.settings, AppSettings.defaults);
    expect(notifier.state.errorMessage, isNotNull);
  });
}
