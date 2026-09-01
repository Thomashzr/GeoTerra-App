import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/core/database/app_database.dart';
import 'package:geoquiz_app/core/services/audio_service.dart';
import 'package:geoquiz_app/features/quiz/domain/models/quiz_question.dart';
import 'package:geoquiz_app/features/quiz/domain/repositories/country_repository.dart';
import 'package:geoquiz_app/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:geoquiz_app/main.dart';

void main() {
  testWidgets('GeoQuiz renders its first offline question', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          countryRepositoryProvider.overrideWithValue(_FakeCountryRepository()),
          audioServiceProvider.overrideWithValue(_FakeAudioService()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('GeoQuiz'), findsOneWidget);
    expect(find.text('Jugar'), findsOneWidget);
    await tester.tap(find.text('Jugar'));
    await tester.pumpAndSettle();

    expect(find.text('¿De qué país es esta bandera?'), findsOneWidget);
    expect(find.text('Argentina'), findsOneWidget);
    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('Chile'), findsOneWidget);
    expect(find.text('Uruguay'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

class _FakeCountryRepository implements CountryRepository {
  @override
  Future<QuizQuestion> getNextQuestion({required int difficulty}) async {
    return const QuizQuestion(
      target: _argentina,
      options: [_argentina, _brazil, _chile, _uruguay],
    );
  }
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

const _argentina = Country(
  id: 1,
  isoCode: 'AR',
  nameEs: 'Argentina',
  capitalEs: 'Buenos Aires',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/ar.svg',
);

const _brazil = Country(
  id: 2,
  isoCode: 'BR',
  nameEs: 'Brasil',
  capitalEs: 'Brasilia',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/br.svg',
);

const _chile = Country(
  id: 3,
  isoCode: 'CL',
  nameEs: 'Chile',
  capitalEs: 'Santiago',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/cl.svg',
);

const _uruguay = Country(
  id: 4,
  isoCode: 'UY',
  nameEs: 'Uruguay',
  capitalEs: 'Montevideo',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/uy.svg',
);
