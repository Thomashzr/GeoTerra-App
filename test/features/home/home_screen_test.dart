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
    expect(find.text('Jugar'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Reto diario'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Reto diario'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Jugar'));
    await tester.tap(find.text('Ajustes'));
    expect(played, isTrue);
    expect(settingsOpened, isTrue);
  });

  testWidgets('default settings action opens a functional placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();

    expect(
      find.text('Los ajustes estarán disponibles próximamente.'),
      findsOneWidget,
    );
    expect(find.text('Cerrar'), findsOneWidget);
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Los ajustes estarán disponibles próximamente.'),
      findsNothing,
    );
  });
}
