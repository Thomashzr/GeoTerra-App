import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/country.dart';
import '../../domain/models/quiz_state.dart';
import '../../domain/repositories/country_repository.dart';

@immutable
class QuizControllerConfig {
  const QuizControllerConfig({
    required this.countryRepository,
    required this.difficulty,
  });

  final CountryRepository countryRepository;
  final int difficulty;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is QuizControllerConfig &&
            identical(countryRepository, other.countryRepository) &&
            difficulty == other.difficulty;
  }

  @override
  int get hashCode =>
      Object.hash(identityHashCode(countryRepository), difficulty);
}

final quizControllerProvider = StateNotifierProvider.autoDispose
    .family<QuizNotifier, QuizState, QuizControllerConfig>((ref, config) {
      final notifier = QuizNotifier(
        countryRepository: config.countryRepository,
        difficulty: config.difficulty,
      );
      unawaited(notifier.nextQuestion());
      return notifier;
    });

class QuizNotifier extends StateNotifier<QuizState> {
  static const _correctAnswerFeedbackDelay = Duration(seconds: 1);

  QuizNotifier({
    required CountryRepository countryRepository,
    required int difficulty,
  }) : this._(countryRepository, difficulty);

  QuizNotifier._(this._countryRepository, this._difficulty)
    : super(const QuizState());

  final CountryRepository _countryRepository;
  final int _difficulty;

  Timer? _autoAdvanceTimer;
  bool _isLoading = false;
  bool _isDisposed = false;
  int _questionRequestId = 0;

  Future<void> nextQuestion() async {
    if (_isDisposed || state.isGameOver || _isLoading) {
      return;
    }

    _cancelAutoAdvance();
    _isLoading = true;
    final requestId = ++_questionRequestId;
    final hadQuestion = state.currentQuestion != null;

    try {
      final question = await _countryRepository.getNextQuestion(
        difficulty: _difficulty,
      );

      if (_isDisposed || requestId != _questionRequestId) {
        return;
      }

      state = state.copyWith(
        currentQuestion: question,
        currentQuestionIndex: hadQuestion
            ? state.currentQuestionIndex + 1
            : state.currentQuestionIndex,
        isAnswered: false,
        selectedAnswer: null,
      );
    } finally {
      if (!_isDisposed && requestId == _questionRequestId) {
        _isLoading = false;
      }
    }
  }

  void submitAnswer(Country selected) {
    final question = state.currentQuestion;
    if (_isDisposed ||
        question == null ||
        state.isAnswered ||
        state.isGameOver ||
        _isLoading ||
        _autoAdvanceTimer != null) {
      return;
    }

    if (selected.id == question.target.id) {
      final newStreak = state.streak + 1;
      final multiplier = 1 + newStreak ~/ 3;
      final earnedPoints = 150 * multiplier;

      state = state.copyWith(
        score: state.score + earnedPoints,
        streak: newStreak,
        isAnswered: true,
        selectedAnswer: selected,
      );
      _scheduleAutoAdvance();
      return;
    }

    _registerIncorrectAnswer(selectedAnswer: selected);
  }

  void reviveWithOneLife() {
    if (_isDisposed || !state.isGameOver) {
      return;
    }

    state = state.copyWith(lives: 1, isGameOver: false, isAnswered: true);
  }

  void _scheduleAutoAdvance() {
    if (_isDisposed || _isLoading) {
      return;
    }

    _cancelAutoAdvance();
    _autoAdvanceTimer = Timer(_correctAnswerFeedbackDelay, () {
      _autoAdvanceTimer = null;
      if (_isDisposed || state.isGameOver || !state.isAnswered) {
        return;
      }
      unawaited(nextQuestion());
    });
  }

  void _registerIncorrectAnswer({required Country? selectedAnswer}) {
    final remainingLives = state.lives > 0 ? state.lives - 1 : 0;
    state = state.copyWith(
      lives: remainingLives,
      streak: 0,
      isGameOver: remainingLives == 0,
      isAnswered: true,
      selectedAnswer: selectedAnswer,
    );
  }

  void _cancelAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _questionRequestId++;
    _cancelAutoAdvance();
    super.dispose();
  }
}
