import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// StateNotifier keeps persistence details outside widgets while exposing an
/// immutable snapshot that is easy to consume from Riverpod.
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._repository, {bool loadOnCreate = true})
    : super(const SettingsState()) {
    if (loadOnCreate) unawaited(load());
  }

  final SettingsRepository _repository;
  bool _disposed = false;

  Future<void> load() async {
    if (_disposed) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final loaded = (await _repository.load()).normalized;
      if (!_disposed) {
        state = state.copyWith(settings: loaded, isLoading: false);
      }
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No se pudieron cargar los ajustes.',
        );
      }
    }
  }

  Future<void> setVolume(double value) => _update(
    state.settings.copyWith(volume: value.clamp(0.0, 1.0).toDouble()),
  );

  Future<void> setLanguage(AppLanguage language) =>
      _update(state.settings.copyWith(language: language));

  Future<void> setThemeMode(AppThemeMode themeMode) =>
      _update(state.settings.copyWith(themeMode: themeMode));

  Future<void> reset() => _update(AppSettings.defaults);

  Future<void> _update(AppSettings next) async {
    if (_disposed) return;
    final previous = state.settings;
    state = state.copyWith(settings: next.normalized, errorMessage: null);
    try {
      await _repository.save(state.settings);
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          settings: previous,
          errorMessage: 'No se pudieron guardar los ajustes.',
        );
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
