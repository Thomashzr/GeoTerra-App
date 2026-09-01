import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/features/settings/presentation/screens/settings_screen.dart';

void main() {
  Widget buildScreen({
    double volume = .8,
    bool isMuted = false,
    String language = 'es',
    ThemeMode themeMode = ThemeMode.system,
    VoidCallback? onBack,
    ValueChanged<double>? onVolumeChanged,
    ValueChanged<bool>? onMutedChanged,
    ValueChanged<String>? onLanguageChanged,
    ValueChanged<ThemeMode>? onThemeModeChanged,
  }) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: SettingsScreen(
        volume: volume,
        isMuted: isMuted,
        language: language,
        themeMode: themeMode,
        onBack: onBack ?? () {},
        onVolumeChanged: onVolumeChanged ?? (_) {},
        onMutedChanged: onMutedChanged ?? (_) {},
        onLanguageChanged: onLanguageChanged ?? (_) {},
        onThemeModeChanged: onThemeModeChanged ?? (_) {},
      ),
    );
  }

  testWidgets('emits volume and mute changes', (tester) async {
    double? volume;
    bool? muted;
    await tester.pumpWidget(
      buildScreen(
        onVolumeChanged: (value) => volume = value,
        onMutedChanged: (value) => muted = value,
      ),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(.35);
    await tester.tap(find.byType(SwitchListTile));

    expect(volume, .35);
    expect(muted, isTrue);
  });

  testWidgets('shows Spanish as the only language and emits selection', (
    tester,
  ) async {
    String? language;
    await tester.pumpWidget(
      buildScreen(onLanguageChanged: (value) => language = value),
    );

    expect(find.text('Español'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español').last);

    expect(language, 'es');
  });

  testWidgets('emits theme mode and back navigation', (tester) async {
    ThemeMode? selectedTheme;
    var wentBack = false;
    await tester.pumpWidget(
      buildScreen(
        onBack: () => wentBack = true,
        onThemeModeChanged: (value) => selectedTheme = value,
      ),
    );

    await tester.ensureVisible(find.text('Oscuro'));
    await tester.tap(find.text('Oscuro'));
    await tester.tap(find.byTooltip('Volver'));

    expect(selectedTheme, ThemeMode.dark);
    expect(wentBack, isTrue);
  });
}
