import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/quiz/presentation/screens/quiz_screen.dart';
import '../features/quiz/presentation/screens/result_screen.dart';

const quizRoutePath = '/quiz';
const resultRoutePath = '/result';

@immutable
class QuizResultArgs {
  const QuizResultArgs({required this.score, this.isRecord = false});

  final int score;
  final bool isRecord;
}

final appRouter = GoRouter(
  initialLocation: quizRoutePath,
  routes: [
    GoRoute(
      path: quizRoutePath,
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: resultRoutePath,
      redirect: (context, state) =>
          state.extra is QuizResultArgs ? null : quizRoutePath,
      builder: (context, state) {
        final args = state.extra! as QuizResultArgs;
        return ResultScreen(score: args.score, isRecord: args.isRecord);
      },
    ),
  ],
);
