import 'package:freezed_annotation/freezed_annotation.dart';

import 'country.dart';
import 'quiz_question.dart';

part 'quiz_state.freezed.dart';

@freezed
abstract class QuizState with _$QuizState {
  const factory QuizState({
    QuizQuestion? currentQuestion,
    @Default(0) int currentQuestionIndex,
    @Default(3) int lives,
    @Default(0) int score,
    @Default(0) int streak,
    @Default(false) bool isGameOver,
    @Default(15) int remainingSeconds,
    @Default(false) bool isAnswered,
    Country? selectedAnswer,
  }) = _QuizState;
}
