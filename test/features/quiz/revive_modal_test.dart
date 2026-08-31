import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/core/services/ad_service.dart';
import 'package:geoquiz_app/features/quiz/presentation/widgets/revive_modal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  testWidgets('successful reward calls onRevived but not onFinished', (
    tester,
  ) async {
    final adService = _FakeAdService(Future.value(true));
    var reviveCalls = 0;
    var finishCalls = 0;

    await tester.pumpWidget(
      _testApp(
        adService: adService,
        onRevived: () => reviveCalls++,
        onFinished: () => finishCalls++,
      ),
    );
    await tester.tap(
      find.text('Ver un anuncio para continuar con 1 vida extra'),
    );
    await tester.pumpAndSettle();

    expect(adService.rewardedCalls, 1);
    expect(reviveCalls, 1);
    expect(finishCalls, 0);
  });

  testWidgets('failed reward displays an error without reviving', (
    tester,
  ) async {
    final adService = _FakeAdService(Future.value(false));
    var reviveCalls = 0;

    await tester.pumpWidget(
      _testApp(adService: adService, onRevived: () => reviveCalls++),
    );
    await tester.tap(
      find.text('Ver un anuncio para continuar con 1 vida extra'),
    );
    await tester.pumpAndSettle();

    expect(reviveCalls, 0);
    expect(
      find.text('El anuncio no se completó. Puedes intentarlo de nuevo.'),
      findsOneWidget,
    );
  });

  testWidgets('pending reward shows loading and ignores a second tap', (
    tester,
  ) async {
    final reward = Completer<bool>();
    final adService = _FakeAdService(reward.future);
    var reviveCalls = 0;

    await tester.pumpWidget(
      _testApp(adService: adService, onRevived: () => reviveCalls++),
    );
    final rewardButton = find.text(
      'Ver un anuncio para continuar con 1 vida extra',
    );

    await tester.tap(rewardButton);
    await tester.pump();
    await tester.tap(find.text('Cargando anuncio…'));
    await tester.pump();

    expect(adService.rewardedCalls, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(reviveCalls, 0);

    reward.complete(true);
    await tester.pumpAndSettle();
    expect(reviveCalls, 1);
  });
}

Widget _testApp({
  required IAdService adService,
  required VoidCallback onRevived,
  VoidCallback? onFinished,
}) {
  return MaterialApp(
    home: Scaffold(
      body: ReviveModal(
        adService: adService,
        onRevived: onRevived,
        onFinished: onFinished ?? () {},
      ),
    ),
  );
}

class _FakeAdService implements IAdService {
  _FakeAdService(this._rewardResult);

  final Future<bool> _rewardResult;
  int rewardedCalls = 0;

  @override
  Future<void> dispose() async {}

  @override
  Future<BannerAd?> loadBannerAd() async => null;

  @override
  Future<void> preload() async {}

  @override
  Future<bool> showInterstitialIfEligible() async => false;

  @override
  Future<bool> showRewardedAd() {
    rewardedCalls++;
    return _rewardResult;
  }
}
