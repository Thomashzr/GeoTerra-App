import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../domain/models/app_settings.dart';
import 'settings_screen.dart';

/// Riverpod integration boundary for the otherwise presentational
/// [SettingsScreen]. Navigation is injected by the app router.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(
      settingsControllerProvider.select((state) => state.errorMessage),
      (previous, next) {
        if (next == null || next == previous) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next)));
      },
    );

    final state = ref.watch(settingsControllerProvider);
    final settings = state.settings;
    final notifier = ref.read(settingsControllerProvider.notifier);

    return SettingsScreen(
      volume: settings.volume,
      isMuted: settings.volume == 0,
      language: _languageCode(settings.language),
      themeMode: _materialThemeMode(settings.themeMode),
      onVolumeChanged: (value) => unawaited(notifier.setVolume(value)),
      onMutedChanged: (muted) => unawaited(
        notifier.setVolume(muted ? 0 : AppSettings.defaults.volume),
      ),
      onLanguageChanged: (_) =>
          unawaited(notifier.setLanguage(AppLanguage.spanish)),
      onThemeModeChanged: (mode) =>
          unawaited(notifier.setThemeMode(_appThemeMode(mode))),
      onBack: onBack,
    );
  }
}

String _languageCode(AppLanguage language) => switch (language) {
  AppLanguage.spanish => 'es',
};

ThemeMode _materialThemeMode(AppThemeMode mode) => switch (mode) {
  AppThemeMode.system => ThemeMode.system,
  AppThemeMode.light => ThemeMode.light,
  AppThemeMode.dark => ThemeMode.dark,
};

AppThemeMode _appThemeMode(ThemeMode mode) => switch (mode) {
  ThemeMode.system => AppThemeMode.system,
  ThemeMode.light => AppThemeMode.light,
  ThemeMode.dark => AppThemeMode.dark,
};
