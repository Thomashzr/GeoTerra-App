import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/country_dao.dart';
import '../../domain/models/country.dart';
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
      target: _toDomain(questionOptions.answer),
      options: questionOptions.options.map(_toDomain).toList(),
      timeLimitSeconds: 15,
    );
  }

  static Country _toDomain(db.Country row) {
    return Country(
      id: row.id,
      isoCode: row.isoCode,
      nameEs: row.nameEs,
      capitalEs: row.capitalEs,
      continent: row.continent,
      difficulty: row.difficulty,
      flagAssetPath: row.flagAssetPath,
    );
  }
}
