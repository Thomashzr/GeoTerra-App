import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/app_database.dart';

part 'quiz_question.freezed.dart';

@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required Country target,
    required List<Country> options,
    @Default(15) int timeLimitSeconds,
  }) = _QuizQuestion;
}
