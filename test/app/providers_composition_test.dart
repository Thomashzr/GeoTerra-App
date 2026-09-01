import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:geoquiz_app/app/providers.dart';
import 'package:geoquiz_app/features/quiz/domain/models/quiz_question.dart';
import 'package:geoquiz_app/features/quiz/domain/repositories/country_repository.dart';
import 'package:geoquiz_app/core/services/ad_service.dart';
import 'package:geoquiz_app/core/services/audio_service.dart';

void main() {
  test(
    'composition root wires an overridden repository without real plugins',
    () {
      final repository = _FakeCountryRepository();
      final audio = _FakeAudioService();
      final ads = _FakeAdService();
      final container = ProviderContainer(
        overrides: [
          countryRepositoryProvider.overrideWithValue(repository),
          audioServiceProvider.overrideWithValue(audio),
          adServiceProvider.overrideWithValue(ads),
        ],
      );
      addTearDown(container.dispose);

      final config = container.read(quizControllerConfigProvider);

      expect(identical(config.countryRepository, repository), isTrue);
      expect(config.difficulty, 1);
      expect(identical(container.read(audioServiceProvider), audio), isTrue);
      expect(identical(container.read(adServiceProvider), ads), isTrue);
    },
  );
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

class _FakeCountryRepository implements CountryRepository {
  @override
  Future<QuizQuestion> getNextQuestion({required int difficulty}) {
    throw UnimplementedError();
  }
}
