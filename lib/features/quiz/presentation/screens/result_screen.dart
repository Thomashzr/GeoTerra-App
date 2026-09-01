import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.score, required this.isRecord, super.key});

  final int score;
  final bool isRecord;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    isRecord ? Icons.emoji_events_rounded : Icons.public,
                    color: isRecord
                        ? Colors.amber.shade700
                        : colorScheme.primary,
                    size: 88,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Partida terminada',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$score puntos',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (isRecord) ...[
                    const SizedBox(height: 12),
                    Text(
                      '¡Nuevo récord!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  FilledButton.icon(
                    onPressed: () => context.go(quizRoutePath),
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Jugar de nuevo'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.go(homeRoutePath),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Volver'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
