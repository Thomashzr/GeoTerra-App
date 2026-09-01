import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:geoquiz_app/app/providers.dart';
import 'package:geoquiz_app/app/router.dart';
import 'package:geoquiz_app/core/services/ad_service.dart';
import 'package:geoquiz_app/core/services/audio_service.dart';
import 'package:geoquiz_app/features/quiz/domain/models/country.dart';
import 'package:geoquiz_app/features/quiz/domain/models/quiz_question.dart';
import 'package:geoquiz_app/features/quiz/domain/repositories/country_repository.dart';
import 'package:geoquiz_app/features/settings/domain/models/app_settings.dart';
import 'package:geoquiz_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:geoquiz_app/features/settings/presentation/screens/settings_page.dart';

void main() {
  testWidgets('home play action navigates to quiz', (tester) async {
    final router = _router();
    addTearDown(router.dispose);
    await tester.pumpWidget(_App(router: router));

    expect(find.text('GeoQuiz'), findsOneWidget);
    await tester.tap(find.text('Comenzar expedición'));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, quizRoutePath);
  });

  testWidgets('home settings action navigates to settings', (tester) async {
    final router = _router();
    addTearDown(router.dispose);
    await tester.pumpWidget(_App(router: router));

    await tester.tap(find.text('Ajustes de viaje'));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, settingsRoutePath);
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}

GoRouter _router() => GoRouter(
  initialLocation: homeRoutePath,
  routes: appRouter.configuration.routes,
);

class _App extends StatelessWidget {
  const _App({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      countryRepositoryProvider.overrideWithValue(_FakeRepository()),
      audioServiceProvider.overrideWithValue(_FakeAudioService()),
      adServiceProvider.overrideWithValue(_FakeAdService()),
      settingsRepositoryProvider.overrideWithValue(_FakeSettingsRepository()),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _FakeRepository implements CountryRepository {
  @override
  Future<QuizQuestion> getNextQuestion({required int difficulty}) async =>
      const QuizQuestion(target: _country, options: [_country]);
}

class _FakeAudioService implements IAudioService {
  @override
  Future<void> dispose() async {}
  @override
  Future<void> playError() async {}
  @override
  Future<void> playGameOver() async {}
  @override
  Future<void> playSuccess() async {}
  @override
  Future<void> playTick() async {}
  @override
  Future<void> preload() async {}
}

class _FakeAdService implements IAdService {
  @override
  Future<void> dispose() async {}
  @override
  Future<BannerAd?> loadBannerAd() async => null;
  @override
  Future<void> preload() async {}
  @override
  Future<bool> showInterstitialIfEligible() async => false;
  @override
  Future<bool> showRewardedAd() async => false;
}

class _FakeSettingsRepository implements SettingsRepository {
  AppSettings value = AppSettings.defaults;

  @override
  Future<AppSettings> load() async => value;

  @override
  Future<void> save(AppSettings settings) async => value = settings;
}

const _country = Country(
  id: 1,
  isoCode: 'AR',
  nameEs: 'Argentina',
  capitalEs: 'Buenos Aires',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/ar.svg',
);
