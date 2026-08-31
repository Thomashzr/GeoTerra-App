import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/core/database/app_database.dart';
import 'package:geoquiz_app/features/quiz/domain/models/quiz_question.dart';
import 'package:geoquiz_app/features/quiz/domain/repositories/country_repository.dart';
import 'package:geoquiz_app/features/quiz/presentation/controllers/quiz_controller.dart';

void main() {
  group('QuizNotifier', () {
    test('timeout consumes one life and answers without a selection', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);

        async.elapse(const Duration(seconds: 15));

        expect(notifier.state.lives, 2);
        expect(notifier.state.remainingSeconds, 0);
        expect(notifier.state.isAnswered, isTrue);
        expect(notifier.state.selectedAnswer, isNull);
        expect(notifier.state.isGameOver, isFalse);
        notifier.dispose();
      });
    });

    test('third consecutive correct answer scores with a x2 multiplier', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);

        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.score, 150);
        expect(notifier.state.streak, 1);

        _loadNextQuestion(notifier, async);
        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.score, 300);
        expect(notifier.state.streak, 2);

        _loadNextQuestion(notifier, async);
        final scoreBeforeThirdAnswer = notifier.state.score;
        notifier.submitAnswer(notifier.state.currentQuestion!.target);

        // 15 remaining seconds * 10 base points * x2 at streak 3.
        expect(notifier.state.score - scoreBeforeThirdAnswer, 300);
        expect(notifier.state.score, 600);
        expect(notifier.state.streak, 3);
        notifier.dispose();
      });
    });

    test('third incorrect answer exhausts lives and ends the game', () {
      fakeAsync((async) {
        final notifier = _createNotifier();

        for (var answerNumber = 1; answerNumber <= 3; answerNumber++) {
          _loadNextQuestion(notifier, async);
          notifier.submitAnswer(_wrongAnswer);
          expect(notifier.state.lives, 3 - answerNumber);
        }

        expect(notifier.state.lives, 0);
        expect(notifier.state.isGameOver, isTrue);
        expect(notifier.state.isAnswered, isTrue);
        notifier.dispose();
      });
    });

    test('next question resets answer flags and restarts the countdown', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);
        notifier.submitAnswer(_wrongAnswer);

        expect(notifier.state.currentQuestionIndex, 0);
        expect(notifier.state.isAnswered, isTrue);
        expect(notifier.state.selectedAnswer, _wrongAnswer);

        _loadNextQuestion(notifier, async);

        expect(notifier.state.currentQuestionIndex, 1);
        expect(notifier.state.remainingSeconds, 15);
        expect(notifier.state.isAnswered, isFalse);
        expect(notifier.state.selectedAnswer, isNull);

        async.elapse(const Duration(seconds: 1));
        expect(notifier.state.remainingSeconds, 14);
        notifier.dispose();
      });
    });

    test('submitting the same correct answer twice only scores once', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);
        final answer = notifier.state.currentQuestion!.target;

        notifier
          ..submitAnswer(answer)
          ..submitAnswer(answer);

        expect(notifier.state.score, 150);
        expect(notifier.state.streak, 1);
        expect(notifier.state.lives, 3);
        notifier.dispose();
      });
    });

    test('submitting the same incorrect answer twice only costs one life', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);

        notifier
          ..submitAnswer(_wrongAnswer)
          ..submitAnswer(_wrongAnswer);

        expect(notifier.state.lives, 2);
        expect(notifier.state.score, 0);
        expect(notifier.state.streak, 0);
        notifier.dispose();
      });
    });
  });
}

QuizNotifier _createNotifier() => QuizNotifier(
  countryRepository: _FakeCountryRepository([
    _questionFor(_argentina),
    _questionFor(_brazil),
    _questionFor(_chile),
    _questionFor(_argentina),
  ]),
  difficulty: 1,
);

void _loadNextQuestion(QuizNotifier notifier, FakeAsync async) {
  unawaited(notifier.nextQuestion());
  async.flushMicrotasks();
  expect(notifier.state.currentQuestion, isNotNull);
}

QuizQuestion _questionFor(Country target) => QuizQuestion(
  target: target,
  options: const [_argentina, _brazil, _chile, _wrongAnswer],
);

class _FakeCountryRepository implements CountryRepository {
  _FakeCountryRepository(this._questions);

  final List<QuizQuestion> _questions;
  int _nextQuestionIndex = 0;

  @override
  Future<QuizQuestion> getNextQuestion({required int difficulty}) async {
    final question = _questions[_nextQuestionIndex % _questions.length];
    _nextQuestionIndex++;
    return question;
  }
}

const _argentina = Country(
  id: 1,
  isoCode: 'AR',
  nameEs: 'Argentina',
  capitalEs: 'Buenos Aires',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/ar.svg',
);

const _brazil = Country(
  id: 2,
  isoCode: 'BR',
  nameEs: 'Brasil',
  capitalEs: 'Brasilia',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/br.svg',
);

const _chile = Country(
  id: 3,
  isoCode: 'CL',
  nameEs: 'Chile',
  capitalEs: 'Santiago',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/cl.svg',
);

const _wrongAnswer = Country(
  id: 4,
  isoCode: 'UY',
  nameEs: 'Uruguay',
  capitalEs: 'Montevideo',
  continent: 'Americas',
  difficulty: 1,
  flagAssetPath: 'assets/flags/uy.svg',
);
