import 'dart:math';

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/countries_table.dart';

part 'country_dao.g.dart';

final class CountryQuestionOptions {
  const CountryQuestionOptions({required this.answer, required this.options})
    : assert(options.length == 4, 'A question must have four options.');

  final Country answer;
  final List<Country> options;
}

@DriftAccessor(tables: [Countries])
class CountryDao extends DatabaseAccessor<AppDatabase> with _$CountryDaoMixin {
  CountryDao(super.attachedDatabase, {Random? random})
    : _random = random ?? Random();

  final Random _random;

  Future<CountryQuestionOptions?> getRandomQuestionOptions({
    int? difficulty,
  }) async {
    var answerQuery = select(countries);
    if (difficulty != null) {
      answerQuery = answerQuery
        ..where((country) => country.difficulty.equals(difficulty));
    }
    answerQuery = answerQuery
      ..orderBy([(country) => OrderingTerm.random()])
      ..limit(1);
    final answer = await answerQuery.getSingleOrNull();

    if (answer == null) {
      return null;
    }

    return getQuestionOptionsForCountry(answer.id);
  }

  Future<CountryQuestionOptions> getQuestionOptionsForCountry(
    int answerId,
  ) async {
    final answerQuery = select(countries)
      ..where((country) => country.id.equals(answerId));
    final answer = await answerQuery.getSingleOrNull();

    if (answer == null) {
      throw StateError('Country $answerId does not exist.');
    }

    final distractorQuery = select(countries)
      ..where(
        (country) =>
            country.continent.equals(answer.continent) &
            country.id.equals(answer.id).not(),
      )
      ..orderBy([(country) => OrderingTerm.random()])
      ..limit(3);
    final distractors = await distractorQuery.get();

    if (distractors.length != 3) {
      throw StateError(
        'Continent ${answer.continent} does not have three distractors.',
      );
    }

    final options = <Country>[answer, ...distractors]..shuffle(_random);
    return CountryQuestionOptions(answer: answer, options: options);
  }
}
