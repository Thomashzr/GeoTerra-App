import '../models/quiz_question.dart';

abstract interface class CountryRepository {
  Future<QuizQuestion> getNextQuestion({required int difficulty});
}
