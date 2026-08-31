import '../../../../core/database/daos/country_dao.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  const CountryRepositoryImpl(this._countryDao);

  final CountryDao _countryDao;

  @override
  Future<QuizQuestion> getNextQuestion({required int difficulty}) async {
    final questionOptions = await _countryDao.getRandomQuestionOptions(
      difficulty: difficulty,
    );

    if (questionOptions == null) {
      throw StateError(
        'No questions available for difficulty level $difficulty.',
      );
    }

    return QuizQuestion(
      target: questionOptions.answer,
      options: questionOptions.options,
      timeLimitSeconds: 15,
    );
  }
}
