import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizTopBar extends StatelessWidget {
  const QuizTopBar({required this.lives, required this.score, super.key});
  final int lives;
  final int score;

  @override
  Widget build(BuildContext context) {
    final safeLives = lives.clamp(0, 99);
    final colors = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final largeText =
                    MediaQuery.textScalerOf(context).scale(14) > 18;
                final hearts = Semantics(
                  label: '$safeLives vidas restantes',
                  liveRegion: true,
                  child: ExcludeSemantics(
                    child: Wrap(
                      spacing: 3,
                      children: [
                        for (var i = 0; i < safeLives; i++)
                          _heart(colors, i, reduceMotion),
                      ],
                    ),
                  ),
                );
                final metrics = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Metric(
                      icon: Icons.stars_rounded,
                      value: '$score',
                      label: 'Puntuación: $score puntos',
                      color: colors.tertiary,
                    ),
                  ],
                );

                if (largeText || constraints.maxWidth < 320) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      hearts,
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerRight, child: metrics),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: hearts),
                    metrics,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _heart(ColorScheme colors, int index, bool reduceMotion) {
    final icon = Icon(Icons.favorite_rounded, color: colors.error, size: 25);
    if (reduceMotion) return icon;
    return icon
        .animate()
        .fadeIn(delay: (index * 45).ms)
        .scale(
          begin: const Offset(.75, .75),
          duration: 260.ms,
          delay: (index * 45).ms,
          curve: Curves.easeOutBack,
        );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    liveRegion: true,
    child: ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}
