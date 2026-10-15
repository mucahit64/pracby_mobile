// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizFinishResult _$QuizFinishResultFromJson(Map<String, dynamic> json) {
  return _QuizFinishResult.fromJson(json);
}

/// @nodoc
mixin _$QuizFinishResult {
  @JsonKey(name: 'xp_earned')
  int get xpEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'acorn_earned')
  int get acornEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'correct_answers')
  int get correctAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_questions')
  int get totalQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_completed')
  bool get stepCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'topic_completed')
  bool get topicCompleted => throw _privateConstructorUsedError;

  /// Serializes this QuizFinishResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizFinishResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizFinishResultCopyWith<QuizFinishResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizFinishResultCopyWith<$Res> {
  factory $QuizFinishResultCopyWith(
    QuizFinishResult value,
    $Res Function(QuizFinishResult) then,
  ) = _$QuizFinishResultCopyWithImpl<$Res, QuizFinishResult>;
  @useResult
  $Res call({
    @JsonKey(name: 'xp_earned') int xpEarned,
    @JsonKey(name: 'acorn_earned') int acornEarned,
    @JsonKey(name: 'correct_answers') int correctAnswers,
    @JsonKey(name: 'total_questions') int totalQuestions,
    @JsonKey(name: 'step_completed') bool stepCompleted,
    @JsonKey(name: 'topic_completed') bool topicCompleted,
  });
}

/// @nodoc
class _$QuizFinishResultCopyWithImpl<$Res, $Val extends QuizFinishResult>
    implements $QuizFinishResultCopyWith<$Res> {
  _$QuizFinishResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizFinishResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? xpEarned = null,
    Object? acornEarned = null,
    Object? correctAnswers = null,
    Object? totalQuestions = null,
    Object? stepCompleted = null,
    Object? topicCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            xpEarned: null == xpEarned
                ? _value.xpEarned
                : xpEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            acornEarned: null == acornEarned
                ? _value.acornEarned
                : acornEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            stepCompleted: null == stepCompleted
                ? _value.stepCompleted
                : stepCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            topicCompleted: null == topicCompleted
                ? _value.topicCompleted
                : topicCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizFinishResultImplCopyWith<$Res>
    implements $QuizFinishResultCopyWith<$Res> {
  factory _$$QuizFinishResultImplCopyWith(
    _$QuizFinishResultImpl value,
    $Res Function(_$QuizFinishResultImpl) then,
  ) = __$$QuizFinishResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'xp_earned') int xpEarned,
    @JsonKey(name: 'acorn_earned') int acornEarned,
    @JsonKey(name: 'correct_answers') int correctAnswers,
    @JsonKey(name: 'total_questions') int totalQuestions,
    @JsonKey(name: 'step_completed') bool stepCompleted,
    @JsonKey(name: 'topic_completed') bool topicCompleted,
  });
}

/// @nodoc
class __$$QuizFinishResultImplCopyWithImpl<$Res>
    extends _$QuizFinishResultCopyWithImpl<$Res, _$QuizFinishResultImpl>
    implements _$$QuizFinishResultImplCopyWith<$Res> {
  __$$QuizFinishResultImplCopyWithImpl(
    _$QuizFinishResultImpl _value,
    $Res Function(_$QuizFinishResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizFinishResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? xpEarned = null,
    Object? acornEarned = null,
    Object? correctAnswers = null,
    Object? totalQuestions = null,
    Object? stepCompleted = null,
    Object? topicCompleted = null,
  }) {
    return _then(
      _$QuizFinishResultImpl(
        xpEarned: null == xpEarned
            ? _value.xpEarned
            : xpEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        acornEarned: null == acornEarned
            ? _value.acornEarned
            : acornEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        stepCompleted: null == stepCompleted
            ? _value.stepCompleted
            : stepCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        topicCompleted: null == topicCompleted
            ? _value.topicCompleted
            : topicCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizFinishResultImpl implements _QuizFinishResult {
  const _$QuizFinishResultImpl({
    @JsonKey(name: 'xp_earned') this.xpEarned = 0,
    @JsonKey(name: 'acorn_earned') this.acornEarned = 0,
    @JsonKey(name: 'correct_answers') this.correctAnswers = 0,
    @JsonKey(name: 'total_questions') this.totalQuestions = 0,
    @JsonKey(name: 'step_completed') this.stepCompleted = false,
    @JsonKey(name: 'topic_completed') this.topicCompleted = false,
  });

  factory _$QuizFinishResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizFinishResultImplFromJson(json);

  @override
  @JsonKey(name: 'xp_earned')
  final int xpEarned;
  @override
  @JsonKey(name: 'acorn_earned')
  final int acornEarned;
  @override
  @JsonKey(name: 'correct_answers')
  final int correctAnswers;
  @override
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @override
  @JsonKey(name: 'step_completed')
  final bool stepCompleted;
  @override
  @JsonKey(name: 'topic_completed')
  final bool topicCompleted;

  @override
  String toString() {
    return 'QuizFinishResult(xpEarned: $xpEarned, acornEarned: $acornEarned, correctAnswers: $correctAnswers, totalQuestions: $totalQuestions, stepCompleted: $stepCompleted, topicCompleted: $topicCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizFinishResultImpl &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.acornEarned, acornEarned) ||
                other.acornEarned == acornEarned) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.stepCompleted, stepCompleted) ||
                other.stepCompleted == stepCompleted) &&
            (identical(other.topicCompleted, topicCompleted) ||
                other.topicCompleted == topicCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    xpEarned,
    acornEarned,
    correctAnswers,
    totalQuestions,
    stepCompleted,
    topicCompleted,
  );

  /// Create a copy of QuizFinishResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizFinishResultImplCopyWith<_$QuizFinishResultImpl> get copyWith =>
      __$$QuizFinishResultImplCopyWithImpl<_$QuizFinishResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizFinishResultImplToJson(this);
  }
}

abstract class _QuizFinishResult implements QuizFinishResult {
  const factory _QuizFinishResult({
    @JsonKey(name: 'xp_earned') final int xpEarned,
    @JsonKey(name: 'acorn_earned') final int acornEarned,
    @JsonKey(name: 'correct_answers') final int correctAnswers,
    @JsonKey(name: 'total_questions') final int totalQuestions,
    @JsonKey(name: 'step_completed') final bool stepCompleted,
    @JsonKey(name: 'topic_completed') final bool topicCompleted,
  }) = _$QuizFinishResultImpl;

  factory _QuizFinishResult.fromJson(Map<String, dynamic> json) =
      _$QuizFinishResultImpl.fromJson;

  @override
  @JsonKey(name: 'xp_earned')
  int get xpEarned;
  @override
  @JsonKey(name: 'acorn_earned')
  int get acornEarned;
  @override
  @JsonKey(name: 'correct_answers')
  int get correctAnswers;
  @override
  @JsonKey(name: 'total_questions')
  int get totalQuestions;
  @override
  @JsonKey(name: 'step_completed')
  bool get stepCompleted;
  @override
  @JsonKey(name: 'topic_completed')
  bool get topicCompleted;

  /// Create a copy of QuizFinishResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizFinishResultImplCopyWith<_$QuizFinishResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
