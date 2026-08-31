import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizTopBar extends StatelessWidget {
  const QuizTopBar({
    required this.lives,
    required this.score,
    required this.remainingSeconds,
    required this.totalSeconds,
    super.key,
  });

  final int lives;
  final int score;
  final int remainingSeconds;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final safeLives = lives.clamp(0, 99);
    final safeTotal = totalSeconds > 0 ? totalSeconds : 1;
    final safeRemaining = remainingSeconds.clamp(0, safeTotal);
    final progress = safeRemaining / safeTotal;
    final progressColor = _progressColor(progress);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: '$safeLives vidas restantes',
                liveRegion: true,
                child: ExcludeSemantics(
                  child: Wrap(
                    spacing: 3,
                    children: [
                      for (var index = 0; index < safeLives; index++)
                        Icon(
                              Icons.favorite_rounded,
                              color: Colors.red.shade600,
                              size: 27,
                            )
                            .animate()
                            .fadeIn(delay: (index * 60).ms)
                            .scale(
                              begin: const Offset(0.65, 0.65),
                              duration: 450.ms,
                              delay: (index * 60).ms,
                              curve: Curves.elasticOut,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Semantics(
              label: 'Puntuación: $score puntos',
              liveRegion: true,
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: Colors.amber.shade700,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$score',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Semantics(
              label: '$safeRemaining segundos restantes',
              liveRegion: true,
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 23),
                    const SizedBox(width: 4),
                    Text(
                      '${safeRemaining}s',
                      style: textTheme.titleMedium?.copyWith(
                        color: progressColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Semantics(
          label: 'Tiempo restante',
          value: '${(progress * 100).round()} por ciento',
          child: ExcludeSemantics(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(999)),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                color: progressColor,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _progressColor(double progress) {
    if (progress > 0.5) {
      return const Color(0xFF2E7D32);
    }
    if (progress > 0.25) {
      return const Color(0xFFF9A825);
    }
    return const Color(0xFFC62828);
  }
}
