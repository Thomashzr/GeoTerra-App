// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizState {

 QuizQuestion? get currentQuestion; int get currentQuestionIndex; int get lives; int get score; int get streak; bool get isGameOver; int get remainingSeconds; bool get isAnswered; Country? get selectedAnswer;
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStateCopyWith<QuizState> get copyWith => _$QuizStateCopyWithImpl<QuizState>(this as QuizState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuizState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState&&(identical(other.currentQuestion, _this.currentQuestion) || other.currentQuestion == _this.currentQuestion)&&(identical(other.currentQuestionIndex, _this.currentQuestionIndex) || other.currentQuestionIndex == _this.currentQuestionIndex)&&(identical(other.lives, _this.lives) || other.lives == _this.lives)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.streak, _this.streak) || other.streak == _this.streak)&&(identical(other.isGameOver, _this.isGameOver) || other.isGameOver == _this.isGameOver)&&(identical(other.remainingSeconds, _this.remainingSeconds) || other.remainingSeconds == _this.remainingSeconds)&&(identical(other.isAnswered, _this.isAnswered) || other.isAnswered == _this.isAnswered)&&const DeepCollectionEquality().equals(other.selectedAnswer, _this.selectedAnswer));
}


@override
int get hashCode {
  final _this = this as QuizState;
  return Object.hash(runtimeType,_this.currentQuestion,_this.currentQuestionIndex,_this.lives,_this.score,_this.streak,_this.isGameOver,_this.remainingSeconds,_this.isAnswered,const DeepCollectionEquality().hash(_this.selectedAnswer));
}

@override
String toString() {
  final _this = this as QuizState;
  return 'QuizState(currentQuestion: ${_this.currentQuestion}, currentQuestionIndex: ${_this.currentQuestionIndex}, lives: ${_this.lives}, score: ${_this.score}, streak: ${_this.streak}, isGameOver: ${_this.isGameOver}, remainingSeconds: ${_this.remainingSeconds}, isAnswered: ${_this.isAnswered}, selectedAnswer: ${_this.selectedAnswer})';
}


}

/// @nodoc
abstract mixin class $QuizStateCopyWith<$Res>  {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) _then) = _$QuizStateCopyWithImpl;
@useResult
$Res call({
 QuizQuestion? currentQuestion, int currentQuestionIndex, int lives, int score, int streak, bool isGameOver, int remainingSeconds, bool isAnswered, Country? selectedAnswer
});


$QuizQuestionCopyWith<$Res>? get currentQuestion;

}
/// @nodoc
class _$QuizStateCopyWithImpl<$Res>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._self, this._then);

  final QuizState _self;
  final $Res Function(QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentQuestion = freezed,Object? currentQuestionIndex = null,Object? lives = null,Object? score = null,Object? streak = null,Object? isGameOver = null,Object? remainingSeconds = null,Object? isAnswered = null,Object? selectedAnswer = freezed,}) {
  return _then(QuizState(
currentQuestion: freezed == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as QuizQuestion?,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,selectedAnswer: freezed == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as Country?,
  ));
}
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<$Res>? get currentQuestion {
    if (_self.currentQuestion == null) {
    return null;
  }

  return $QuizQuestionCopyWith<$Res>(_self.currentQuestion!, (value) {
    return _then(_self.copyWith(currentQuestion: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizState value)  $default,){
final _that = this;
switch (_that) {
case _QuizState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizState value)?  $default,){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuizQuestion? currentQuestion,  int currentQuestionIndex,  int lives,  int score,  int streak,  bool isGameOver,  int remainingSeconds,  bool isAnswered,  Country? selectedAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.currentQuestion,_that.currentQuestionIndex,_that.lives,_that.score,_that.streak,_that.isGameOver,_that.remainingSeconds,_that.isAnswered,_that.selectedAnswer);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuizQuestion? currentQuestion,  int currentQuestionIndex,  int lives,  int score,  int streak,  bool isGameOver,  int remainingSeconds,  bool isAnswered,  Country? selectedAnswer)  $default,) {final _that = this;
switch (_that) {
case _QuizState():
return $default(_that.currentQuestion,_that.currentQuestionIndex,_that.lives,_that.score,_that.streak,_that.isGameOver,_that.remainingSeconds,_that.isAnswered,_that.selectedAnswer);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuizQuestion? currentQuestion,  int currentQuestionIndex,  int lives,  int score,  int streak,  bool isGameOver,  int remainingSeconds,  bool isAnswered,  Country? selectedAnswer)?  $default,) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.currentQuestion,_that.currentQuestionIndex,_that.lives,_that.score,_that.streak,_that.isGameOver,_that.remainingSeconds,_that.isAnswered,_that.selectedAnswer);case _:
  return null;

}
}

}

/// @nodoc


class _QuizState implements QuizState {
  const _QuizState({this.currentQuestion, this.currentQuestionIndex = 0, this.lives = 3, this.score = 0, this.streak = 0, this.isGameOver = false, this.remainingSeconds = 15, this.isAnswered = false, this.selectedAnswer});


@override final  QuizQuestion? currentQuestion;
@override@JsonKey() final  int currentQuestionIndex;
@override@JsonKey() final  int lives;
@override@JsonKey() final  int score;
@override@JsonKey() final  int streak;
@override@JsonKey() final  bool isGameOver;
@override@JsonKey() final  int remainingSeconds;
@override@JsonKey() final  bool isAnswered;
@override final  Country? selectedAnswer;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizStateCopyWith<_QuizState> get copyWith => __$QuizStateCopyWithImpl<_QuizState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizState&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.lives, lives) || other.lives == lives)&&(identical(other.score, score) || other.score == score)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&const DeepCollectionEquality().equals(other.selectedAnswer, selectedAnswer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentQuestion,currentQuestionIndex,lives,score,streak,isGameOver,remainingSeconds,isAnswered,const DeepCollectionEquality().hash(selectedAnswer));
}

@override
String toString() {
    return 'QuizState(currentQuestion: $currentQuestion, currentQuestionIndex: $currentQuestionIndex, lives: $lives, score: $score, streak: $streak, isGameOver: $isGameOver, remainingSeconds: $remainingSeconds, isAnswered: $isAnswered, selectedAnswer: $selectedAnswer)';
}


}

/// @nodoc
abstract mixin class _$QuizStateCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizStateCopyWith(_QuizState value, $Res Function(_QuizState) _then) = __$QuizStateCopyWithImpl;
@override @useResult
$Res call({
 QuizQuestion? currentQuestion, int currentQuestionIndex, int lives, int score, int streak, bool isGameOver, int remainingSeconds, bool isAnswered, Country? selectedAnswer
});


@override $QuizQuestionCopyWith<$Res>? get currentQuestion;

}
/// @nodoc
class __$QuizStateCopyWithImpl<$Res>
    implements _$QuizStateCopyWith<$Res> {
  __$QuizStateCopyWithImpl(this._self, this._then);

  final _QuizState _self;
  final $Res Function(_QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentQuestion = freezed,Object? currentQuestionIndex = null,Object? lives = null,Object? score = null,Object? streak = null,Object? isGameOver = null,Object? remainingSeconds = null,Object? isAnswered = null,Object? selectedAnswer = freezed,}) {
  return _then(_QuizState(
currentQuestion: freezed == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as QuizQuestion?,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,selectedAnswer: freezed == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as Country?,
  ));
}

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<$Res>? get currentQuestion {
    if (_self.currentQuestion == null) {
    return null;
  }

  return $QuizQuestionCopyWith<$Res>(_self.currentQuestion!, (value) {
    return _then(_self.copyWith(currentQuestion: value));
  });
}
}

// dart format on
