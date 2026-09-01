import 'package:flutter/material.dart';

/// Shared field-atlas visual language used across the whole application.
///
/// The palette is intentionally drawn from navigation charts rather than the
/// default Material blue: ocean teal, paper, ink and a warm meridian accent.
abstract final class GeoQuizTheme {
  static const ocean = Color(0xFF0B6870);
  static const lagoon = Color(0xFF18A6A3);
  static const meridian = Color(0xFFE49A27);
  static const paper = Color(0xFFF5F1E8);
  static const ink = Color(0xFF16323A);
  static const deepOcean = Color(0xFF071E25);

  static ThemeData get light => _theme(
    ColorScheme.fromSeed(
      seedColor: ocean,
      brightness: Brightness.light,
      surface: paper,
    ).copyWith(
      primary: ocean,
      onPrimary: Colors.white,
      secondary: const Color(0xFF9A5A16),
      onSecondary: Colors.white,
      tertiary: meridian,
      onTertiary: const Color(0xFF402800),
      surface: paper,
      onSurface: ink,
      surfaceContainer: const Color(0xFFEDE7DA),
      surfaceContainerHighest: const Color(0xFFE3DDD1),
      outline: const Color(0xFF687A7C),
      outlineVariant: const Color(0xFFC4CCC7),
    ),
  );

  static ThemeData get dark => _theme(
    ColorScheme.fromSeed(
      seedColor: lagoon,
      brightness: Brightness.dark,
      surface: deepOcean,
    ).copyWith(
      primary: const Color(0xFF79D8D5),
      onPrimary: const Color(0xFF003739),
      secondary: const Color(0xFFFFBD66),
      onSecondary: const Color(0xFF472A00),
      tertiary: const Color(0xFFFFC46F),
      onTertiary: const Color(0xFF432B00),
      surface: deepOcean,
      onSurface: const Color(0xFFE4F1EE),
      surfaceContainer: const Color(0xFF0D3038),
      surfaceContainerHighest: const Color(0xFF173E46),
      outline: const Color(0xFF8AA09E),
      outlineVariant: const Color(0xFF36545A),
    ),
  );

  static ThemeData _theme(ColorScheme colorScheme) {
    final materialText = Typography.material2021().black.apply(
      fontFamily: 'sans-serif',
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    final textTheme = materialText.copyWith(
      displayLarge: _display(materialText.displayLarge),
      displayMedium: _display(materialText.displayMedium),
      displaySmall: _display(materialText.displaySmall),
      headlineLarge: _display(materialText.headlineLarge),
      headlineMedium: _display(materialText.headlineMedium),
      headlineSmall: _display(materialText.headlineSmall),
      labelSmall: materialText.labelSmall?.copyWith(
        fontFamily: 'monospace',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        trackHeight: 6,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      focusColor: colorScheme.primary.withValues(alpha: 0.18),
    );
  }

  static TextStyle? _display(TextStyle? style) => style?.copyWith(
    fontFamily: 'serif',
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    height: 1.05,
  );
}
