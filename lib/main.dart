import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/models/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final settingsBox = await SettingsHiveLocalDataSource.openBox();
  final settingsRepository = SettingsRepositoryImpl.fromBox(settingsBox);

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(
      settingsControllerProvider.select((state) => state.settings.themeMode),
    );

    return MaterialApp.router(
      title: 'GeoQuiz',
      debugShowCheckedModeBanner: false,
      theme: GeoQuizTheme.light,
      darkTheme: GeoQuizTheme.dark,
      themeMode: _materialThemeMode(preference),
      routerConfig: appRouter,
    );
  }
}

ThemeMode _materialThemeMode(AppThemeMode preference) => switch (preference) {
  AppThemeMode.system => ThemeMode.system,
  AppThemeMode.light => ThemeMode.light,
  AppThemeMode.dark => ThemeMode.dark,
};
