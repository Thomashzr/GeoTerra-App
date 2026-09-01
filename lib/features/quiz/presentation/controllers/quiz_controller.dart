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
    this.tickInterval = const Duration(seconds: 1),
  });

  final CountryRepository countryRepository;
  final int difficulty;
  final Duration tickInterval;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is QuizControllerConfig &&
            identical(countryRepository, other.countryRepository) &&
            difficulty == other.difficulty &&
            tickInterval == other.tickInterval;
  }

  @override
  int get hashCode => Object.hash(
    identityHashCode(countryRepository),
    difficulty,
    tickInterval,
  );
}

final quizControllerProvider = StateNotifierProvider.autoDispose
    .family<QuizNotifier, QuizState, QuizControllerConfig>((ref, config) {
      final notifier = QuizNotifier(
        countryRepository: config.countryRepository,
        difficulty: config.difficulty,
        tickInterval: config.tickInterval,
      );
      unawaited(notifier.nextQuestion());
      return notifier;
    });

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier({
    required CountryRepository countryRepository,
    required int difficulty,
    Duration tickInterval = const Duration(seconds: 1),
  }) : this._(countryRepository, difficulty, tickInterval);

  QuizNotifier._(this._countryRepository, this._difficulty, this._tickInterval)
    : super(const QuizState());

  final CountryRepository _countryRepository;
  final int _difficulty;
  final Duration _tickInterval;

  Timer? _timer;
  bool _isLoading = false;
  int _questionRequestId = 0;

  Future<void> nextQuestion() async {
    if (state.isGameOver || _isLoading) {
      return;
    }

    _cancelTimer();
    _isLoading = true;
    final requestId = ++_questionRequestId;
    final hadQuestion = state.currentQuestion != null;

    try {
      final question = await _countryRepository.getNextQuestion(
        difficulty: _difficulty,
      );

      if (requestId != _questionRequestId) {
        return;
      }

      state = state.copyWith(
        currentQuestion: question,
        currentQuestionIndex: hadQuestion
            ? state.currentQuestionIndex + 1
            : state.currentQuestionIndex,
        remainingSeconds: question.timeLimitSeconds,
        isAnswered: false,
        selectedAnswer: null,
      );
      _startTimer();
    } finally {
      if (requestId == _questionRequestId) {
        _isLoading = false;
      }
    }
  }

  void submitAnswer(Country selected) {
    final question = state.currentQuestion;
    if (question == null ||
        state.isAnswered ||
        state.isGameOver ||
        _isLoading) {
      return;
    }

    _cancelTimer();

    if (selected.id == question.target.id) {
      final newStreak = state.streak + 1;
      final multiplier = 1 + newStreak ~/ 3;
      final earnedPoints = state.remainingSeconds * 10 * multiplier;

      state = state.copyWith(
        score: state.score + earnedPoints,
        streak: newStreak,
        isAnswered: true,
        selectedAnswer: selected,
      );
      return;
    }

    _registerIncorrectAnswer(selectedAnswer: selected);
  }

  void reviveWithOneLife() {
    if (!state.isGameOver) {
      return;
    }

    state = state.copyWith(lives: 1, isGameOver: false, isAnswered: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(_tickInterval, _onTick);
  }

  void _onTick(Timer timer) {
    if (state.isAnswered || state.isGameOver) {
      _cancelTimer();
      return;
    }

    final remainingSeconds = state.remainingSeconds - 1;
    if (remainingSeconds <= 0) {
      _cancelTimer();
      _registerIncorrectAnswer(selectedAnswer: null, remainingSeconds: 0);
      return;
    }

    state = state.copyWith(remainingSeconds: remainingSeconds);
  }

  void _registerIncorrectAnswer({
    required Country? selectedAnswer,
    int? remainingSeconds,
  }) {
    final remainingLives = state.lives > 0 ? state.lives - 1 : 0;
    state = state.copyWith(
      lives: remainingLives,
      streak: 0,
      isGameOver: remainingLives == 0,
      remainingSeconds: remainingSeconds ?? state.remainingSeconds,
      isAnswered: true,
      selectedAnswer: selectedAnswer,
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _questionRequestId++;
    _cancelTimer();
    super.dispose();
  }
}
