import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz_app/features/quiz/domain/models/country.dart';
import 'package:geoquiz_app/features/quiz/domain/models/quiz_question.dart';
import 'package:geoquiz_app/features/quiz/domain/repositories/country_repository.dart';
import 'package:geoquiz_app/features/quiz/presentation/controllers/quiz_controller.dart';

void main() {
  group('QuizNotifier', () {
    test('waiting does not penalize the answer or reduce its score', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);
        async.elapse(const Duration(minutes: 2));
        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.lives, 3);
        expect(notifier.state.score, 150);
        expect(notifier.state.streak, 1);
        expect(notifier.state.isAnswered, isTrue);
        notifier.dispose();
      });
    });

    test('correct answers score 150 times the streak multiplier', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);
        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.score, 150);
        _advanceAfterCorrectAnswer(notifier, async);
        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.score, 300);
        _advanceAfterCorrectAnswer(notifier, async);
        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.score, 600);
        expect(notifier.state.streak, 3);
        notifier.dispose();
      });
    });

    test('a correct answer auto-advances exactly once after feedback', () {
      fakeAsync((async) {
        final repository = _FakeCountryRepository([
          _questionFor(_argentina),
          _questionFor(_brazil),
        ]);
        final notifier = _createNotifier(repository: repository);
        _loadNextQuestion(notifier, async);
        notifier.submitAnswer(notifier.state.currentQuestion!.target);
        expect(notifier.state.isAnswered, isTrue);
        expect(notifier.state.currentQuestionIndex, 0);
        expect(repository.requestCount, 1);
        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();
        expect(notifier.state.currentQuestionIndex, 1);
        expect(notifier.state.isAnswered, isFalse);
        expect(repository.requestCount, 2);
        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();
        expect(repository.requestCount, 2);
        notifier.dispose();
      });
    });

    test('an incorrect answer does not auto-advance and costs one life', () {
      fakeAsync((async) {
        final repository = _FakeCountryRepository([
          _questionFor(_argentina),
          _questionFor(_brazil),
        ]);
        final notifier = _createNotifier(repository: repository);
        _loadNextQuestion(notifier, async);
        notifier.submitAnswer(_wrongAnswer);
        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();
        expect(notifier.state.currentQuestionIndex, 0);
        expect(notifier.state.isAnswered, isTrue);
        expect(notifier.state.lives, 2);
        expect(repository.requestCount, 1);
        notifier.dispose();
      });
    });

    test('the third incorrect answer ends the game', () {
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

    test('revive restores one life without changing score or feedback', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);
        for (var answerNumber = 0; answerNumber < 3; answerNumber++) {
          notifier.submitAnswer(_wrongAnswer);
          if (answerNumber < 2) _loadNextQuestion(notifier, async);
        }
        expect(notifier.state.isGameOver, isTrue);
        notifier.reviveWithOneLife();
        expect(notifier.state.lives, 1);
        expect(notifier.state.isGameOver, isFalse);
        expect(notifier.state.isAnswered, isTrue);
        expect(notifier.state.score, 0);
        _loadNextQuestion(notifier, async);
        expect(notifier.state.isAnswered, isFalse);
        notifier.dispose();
      });
    });

    test('revive is ignored while the game is active', () {
      fakeAsync((async) {
        final notifier = _createNotifier();
        _loadNextQuestion(notifier, async);
        notifier.reviveWithOneLife();
        expect(notifier.state.lives, 3);
        expect(notifier.state.isGameOver, isFalse);
        expect(notifier.state.isAnswered, isFalse);
        notifier.dispose();
      });
    });

    test('double submit of a correct answer scores and advances once', () {
      fakeAsync((async) {
        final repository = _FakeCountryRepository([
          _questionFor(_argentina),
          _questionFor(_brazil),
        ]);
        final notifier = _createNotifier(repository: repository);
        _loadNextQuestion(notifier, async);
        final answer = notifier.state.currentQuestion!.target;
        notifier
          ..submitAnswer(answer)
          ..submitAnswer(answer);
        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();
        expect(notifier.state.score, 150);
        expect(notifier.state.streak, 1);
        expect(notifier.state.lives, 3);
        expect(repository.requestCount, 2);
        notifier.dispose();
      });
    });

    test('double submit of an incorrect answer costs one life', () {
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

QuizNotifier _createNotifier({_FakeCountryRepository? repository}) =>
    QuizNotifier(
      countryRepository:
          repository ??
          _FakeCountryRepository([
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

void _advanceAfterCorrectAnswer(QuizNotifier notifier, FakeAsync async) {
  async.elapse(const Duration(seconds: 1));
  async.flushMicrotasks();
  expect(notifier.state.isAnswered, isFalse);
}

QuizQuestion _questionFor(Country target) => QuizQuestion(
  target: target,
  options: const [_argentina, _brazil, _chile, _wrongAnswer],
);

class _FakeCountryRepository implements CountryRepository {
  _FakeCountryRepository(this._questions);

  final List<QuizQuestion> _questions;
  int _nextQuestionIndex = 0;

  int get requestCount => _nextQuestionIndex;

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
