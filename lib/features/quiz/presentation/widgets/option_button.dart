import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum OptionButtonState { neutral, selected, correct, incorrect }

class OptionButton extends StatelessWidget {
  const OptionButton({
    required this.label,
    required this.visualState,
    required this.onPressed,
    super.key,
  });

  final String label;
  final OptionButtonState visualState;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(Theme.of(context).colorScheme);
    final semanticValue = switch (visualState) {
      OptionButtonState.neutral => null,
      OptionButtonState.selected => 'Respuesta seleccionada',
      OptionButtonState.correct => 'Respuesta correcta',
      OptionButtonState.incorrect => 'Respuesta incorrecta',
    };
    final button = Semantics(
      value: semanticValue,
      selected: visualState == OptionButtonState.selected,
      button: true,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          disabledBackgroundColor: colors.background,
          disabledForegroundColor: colors.foreground,
          elevation: visualState == OptionButtonState.neutral ? 0 : 1,
          side: BorderSide(color: colors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    if (visualState != OptionButtonState.incorrect ||
        MediaQuery.disableAnimationsOf(context)) {
      return button;
    }
    return button.animate().shakeX(
      duration: 360.ms,
      amount: 6,
      hz: 4,
      curve: Curves.easeInOut,
    );
  }

  _OptionColors _colorsFor(ColorScheme colorScheme) => switch (visualState) {
    OptionButtonState.neutral => _OptionColors(
      background: colorScheme.surfaceContainer,
      foreground: colorScheme.onSurface,
      border: colorScheme.outlineVariant,
    ),
    OptionButtonState.selected => _OptionColors(
      background: colorScheme.primaryContainer,
      foreground: colorScheme.onPrimaryContainer,
      border: colorScheme.primary,
    ),
    OptionButtonState.correct => const _OptionColors(
      background: Color(0xFF217348),
      foreground: Colors.white,
      border: Color(0xFF145331),
    ),
    OptionButtonState.incorrect => const _OptionColors(
      background: Color(0xFFB83232),
      foreground: Colors.white,
      border: Color(0xFF7E1D1D),
    ),
  };
}

class _OptionColors {
  const _OptionColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
  final Color background;
  final Color foreground;
  final Color border;
}
