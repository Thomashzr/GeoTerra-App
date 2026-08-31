import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/core/database/app_database.dart';
import 'package:geoquiz_app/core/database/daos/country_dao.dart';

void main() {
  late AppDatabase database;
  late CountryDao dao;

  setUp(() async {
    database = AppDatabase(executor: NativeDatabase.memory());
    dao = CountryDao(database, random: Random(7));

    for (var index = 0; index < 5; index++) {
      await database
          .into(database.countries)
          .insert(
            CountriesCompanion.insert(
              isoCode: 'A$index',
              nameEs: 'País $index',
              capitalEs: 'Capital $index',
              continent: 'Americas',
              difficulty: 1,
              flagAssetPath: 'assets/flags/a$index.svg',
            ),
          );
    }
  });

  tearDown(() => database.close());

  test(
    'returns one answer and three unique same-continent distractors',
    () async {
      final result = await dao.getQuestionOptionsForCountry(1);

      expect(result.answer.id, 1);
      expect(result.options, hasLength(4));
      expect(result.options.map((country) => country.id).toSet(), hasLength(4));
      expect(
        result.options.every(
          (country) => country.continent == result.answer.continent,
        ),
        isTrue,
      );
      expect(result.options, contains(result.answer));
    },
  );

  test('fails clearly when the requested country does not exist', () async {
    expect(
      () => dao.getQuestionOptionsForCountry(999),
      throwsA(isA<StateError>()),
    );
  });
}
