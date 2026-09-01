import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/services/ad_service.dart';
import '../core/services/audio_service.dart';
import '../features/quiz/data/repositories/country_repository_impl.dart';
import '../features/quiz/domain/repositories/country_repository.dart';
import '../features/quiz/presentation/controllers/quiz_controller.dart';

/// Application composition root for quiz infrastructure and presentation
/// dependencies. Views consume these providers but do not construct services.
final appDatabaseProvider = Provider.autoDispose<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final countryRepositoryProvider = Provider.autoDispose<CountryRepository>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return CountryRepositoryImpl(database.countryDao);
});

final quizControllerConfigProvider = Provider.autoDispose<QuizControllerConfig>(
  (ref) => QuizControllerConfig(
    countryRepository: ref.watch(countryRepositoryProvider),
    difficulty: 1,
  ),
);

final audioServiceProvider = Provider.autoDispose<IAudioService>((ref) {
  final audioService = AudioService();
  unawaited(audioService.preload());
  ref.onDispose(() => unawaited(audioService.dispose()));
  return audioService;
});

final adServiceProvider = Provider<IAdService>((ref) {
  final adService = AdMobService();
  unawaited(adService.preload());
  ref.onDispose(() => unawaited(adService.dispose()));
  return adService;
});
