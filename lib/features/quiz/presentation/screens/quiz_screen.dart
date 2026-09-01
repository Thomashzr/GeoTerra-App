import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/providers.dart';
import '../../../../core/services/ad_service.dart';
import '../../domain/models/quiz_state.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/flag_card.dart';
import '../widgets/option_button.dart';
import '../widgets/quiz_top_bar.dart';
import '../widgets/revive_modal.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(quizControllerConfigProvider);
    final controllerProvider = quizControllerProvider(config);
    final audioService = ref.watch(audioServiceProvider);
    final adService = ref.watch(adServiceProvider);

    ref.listen<QuizState>(controllerProvider, (previous, next) {
      final justAnswered = next.isAnswered && previous?.isAnswered != true;
      if (justAnswered) {
        final selectedAnswer = next.selectedAnswer;
        final target = next.currentQuestion?.target;

        if (next.isGameOver) {
          unawaited(audioService.playGameOver());
        } else if (selectedAnswer != null &&
            target != null &&
            selectedAnswer.id == target.id) {
          unawaited(audioService.playSuccess());
        } else {
          unawaited(audioService.playError());
        }
      } else if (!next.isAnswered &&
          previous != null &&
          next.remainingSeconds != previous.remainingSeconds &&
          next.remainingSeconds > 0 &&
          next.remainingSeconds <= 5) {
        unawaited(audioService.playTick());
      }

      if (next.isGameOver && previous?.isGameOver != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            unawaited(
              _showGameOverFlow(
                context: context,
                ref: ref,
                config: config,
                gameOverState: next,
                adService: adService,
              ),
            );
          }
        });
      }
    });

    final state = ref.watch(controllerProvider);
    final question = state.currentQuestion;

    if (question == null) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                QuizTopBar(
                  lives: state.lives,
                  score: state.score,
                  remainingSeconds: state.remainingSeconds,
                  totalSeconds: question.timeLimitSeconds,
                ),
                const SizedBox(height: 28),
                Text(
                  'Pregunta ${state.currentQuestionIndex + 1}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿De qué país es esta bandera?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                FlagCard(assetPath: question.target.flagAssetPath),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 560 ? 2 : 1;
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: columns == 1 ? 5 : 3.4,
                      children: [
                        for (final option in question.options)
                          OptionButton(
                            label: option.nameEs,
                            visualState: _optionVisualState(
                              state: state,
                              optionId: option.id,
                            ),
                            onPressed: state.isAnswered
                                ? null
                                : () => ref
                                      .read(controllerProvider.notifier)
                                      .submitAnswer(option),
                          ),
                      ],
                    );
                  },
                ),
                if (state.isAnswered && !state.isGameOver) ...[
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => unawaited(
                      ref.read(controllerProvider.notifier).nextQuestion(),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Siguiente pregunta'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showGameOverFlow({
    required BuildContext context,
    required WidgetRef ref,
    required QuizControllerConfig config,
    required QuizState gameOverState,
    required IAdService adService,
  }) async {
    final wasRevived = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ReviveModal(
        adService: adService,
        onRevived: () => Navigator.of(dialogContext).pop(true),
        onFinished: () => Navigator.of(dialogContext).pop(false),
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (wasRevived == true) {
      ref.read(quizControllerProvider(config).notifier).reviveWithOneLife();
      return;
    }

    await adService.showInterstitialIfEligible();
    if (context.mounted) {
      _openResults(context, gameOverState.score);
    }
  }

  void _openResults(BuildContext context, int score) {
    if (!context.mounted) {
      return;
    }

    context.go(resultRoutePath, extra: QuizResultArgs(score: score));
  }
}

OptionButtonState _optionVisualState({
  required QuizState state,
  required int optionId,
}) {
  if (!state.isAnswered) {
    return OptionButtonState.neutral;
  }

  if (optionId == state.currentQuestion?.target.id) {
    return OptionButtonState.correct;
  }

  if (optionId == state.selectedAnswer?.id) {
    return OptionButtonState.incorrect;
  }

  return OptionButtonState.neutral;
}
