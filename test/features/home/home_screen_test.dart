import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/features/home/presentation/screens/home_screen.dart';

void main() {
  testWidgets('shows home actions and disables daily challenge', (
    tester,
  ) async {
    var played = false;
    var settingsOpened = false;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          onPlay: () => played = true,
          onSettings: () => settingsOpened = true,
        ),
      ),
    );

    expect(find.text('GeoQuiz'), findsOneWidget);
    expect(find.text('Comenzar expedición'), findsOneWidget);
    expect(find.text('Ajustes de viaje'), findsOneWidget);
    expect(find.text('Reto diario'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Reto diario'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Comenzar expedición'));
    await tester.tap(find.text('Ajustes de viaje'));
    expect(played, isTrue);
    expect(settingsOpened, isTrue);
  });
}
