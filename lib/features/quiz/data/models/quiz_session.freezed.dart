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

QuizSession _$QuizSessionFromJson(Map<String, dynamic> json) {
  return _QuizSession.fromJson(json);
}

/// @nodoc
mixin _$QuizSession {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_id')
  String? get stepId => throw _privateConstructorUsedError;
  @JsonKey(name: 'topic_id')
  String? get topicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'test_id')
  String? get testId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_type')
  String get sessionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_final_test')
  bool get isFinalTest => throw _privateConstructorUsedError;
  List<QuestionModel> get questions => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_questions')
  int get totalQuestions => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_earned')
  int get xpEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'correct_answers')
  int get correctAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'energy_lost')
  int get energyLost => throw _privateConstructorUsedError;

  /// Serializes this QuizSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizSessionCopyWith<QuizSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizSessionCopyWith<$Res> {
  factory $QuizSessionCopyWith(
    QuizSession value,
    $Res Function(QuizSession) then,
  ) = _$QuizSessionCopyWithImpl<$Res, QuizSession>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'step_id') String? stepId,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'test_id') String? testId,
    @JsonKey(name: 'session_type') String sessionType,
    @JsonKey(name: 'is_final_test') bool isFinalTest,
    List<QuestionModel> questions,
    @JsonKey(name: 'total_questions') int totalQuestions,
    int score,
    @JsonKey(name: 'xp_earned') int xpEarned,
    @JsonKey(name: 'correct_answers') int correctAnswers,
    @JsonKey(name: 'energy_lost') int energyLost,
  });
}

/// @nodoc
class _$QuizSessionCopyWithImpl<$Res, $Val extends QuizSession>
    implements $QuizSessionCopyWith<$Res> {
  _$QuizSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stepId = freezed,
    Object? topicId = freezed,
    Object? testId = freezed,
    Object? sessionType = null,
    Object? isFinalTest = null,
    Object? questions = null,
    Object? totalQuestions = null,
    Object? score = null,
    Object? xpEarned = null,
    Object? correctAnswers = null,
    Object? energyLost = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            stepId: freezed == stepId
                ? _value.stepId
                : stepId // ignore: cast_nullable_to_non_nullable
                      as String?,
            topicId: freezed == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String?,
            testId: freezed == testId
                ? _value.testId
                : testId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sessionType: null == sessionType
                ? _value.sessionType
                : sessionType // ignore: cast_nullable_to_non_nullable
                      as String,
            isFinalTest: null == isFinalTest
                ? _value.isFinalTest
                : isFinalTest // ignore: cast_nullable_to_non_nullable
                      as bool,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuestionModel>,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            xpEarned: null == xpEarned
                ? _value.xpEarned
                : xpEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            energyLost: null == energyLost
                ? _value.energyLost
                : energyLost // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizSessionImplCopyWith<$Res>
    implements $QuizSessionCopyWith<$Res> {
  factory _$$QuizSessionImplCopyWith(
    _$QuizSessionImpl value,
    $Res Function(_$QuizSessionImpl) then,
  ) = __$$QuizSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'step_id') String? stepId,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'test_id') String? testId,
    @JsonKey(name: 'session_type') String sessionType,
    @JsonKey(name: 'is_final_test') bool isFinalTest,
    List<QuestionModel> questions,
    @JsonKey(name: 'total_questions') int totalQuestions,
    int score,
    @JsonKey(name: 'xp_earned') int xpEarned,
    @JsonKey(name: 'correct_answers') int correctAnswers,
    @JsonKey(name: 'energy_lost') int energyLost,
  });
}

/// @nodoc
class __$$QuizSessionImplCopyWithImpl<$Res>
    extends _$QuizSessionCopyWithImpl<$Res, _$QuizSessionImpl>
    implements _$$QuizSessionImplCopyWith<$Res> {
  __$$QuizSessionImplCopyWithImpl(
    _$QuizSessionImpl _value,
    $Res Function(_$QuizSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stepId = freezed,
    Object? topicId = freezed,
    Object? testId = freezed,
    Object? sessionType = null,
    Object? isFinalTest = null,
    Object? questions = null,
    Object? totalQuestions = null,
    Object? score = null,
    Object? xpEarned = null,
    Object? correctAnswers = null,
    Object? energyLost = null,
  }) {
    return _then(
      _$QuizSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stepId: freezed == stepId
            ? _value.stepId
            : stepId // ignore: cast_nullable_to_non_nullable
                  as String?,
        topicId: freezed == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String?,
        testId: freezed == testId
            ? _value.testId
            : testId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sessionType: null == sessionType
            ? _value.sessionType
            : sessionType // ignore: cast_nullable_to_non_nullable
                  as String,
        isFinalTest: null == isFinalTest
            ? _value.isFinalTest
            : isFinalTest // ignore: cast_nullable_to_non_nullable
                  as bool,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuestionModel>,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        xpEarned: null == xpEarned
            ? _value.xpEarned
            : xpEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        energyLost: null == energyLost
            ? _value.energyLost
            : energyLost // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizSessionImpl implements _QuizSession {
  const _$QuizSessionImpl({
    required this.id,
    @JsonKey(name: 'step_id') this.stepId,
    @JsonKey(name: 'topic_id') this.topicId,
    @JsonKey(name: 'test_id') this.testId,
    @JsonKey(name: 'session_type') this.sessionType = 'lesson',
    @JsonKey(name: 'is_final_test') this.isFinalTest = false,
    required final List<QuestionModel> questions,
    @JsonKey(name: 'total_questions') this.totalQuestions = 0,
    this.score = 0,
    @JsonKey(name: 'xp_earned') this.xpEarned = 0,
    @JsonKey(name: 'correct_answers') this.correctAnswers = 0,
    @JsonKey(name: 'energy_lost') this.energyLost = 0,
  }) : _questions = questions;

  factory _$QuizSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizSessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'step_id')
  final String? stepId;
  @override
  @JsonKey(name: 'topic_id')
  final String? topicId;
  @override
  @JsonKey(name: 'test_id')
  final String? testId;
  @override
  @JsonKey(name: 'session_type')
  final String sessionType;
  @override
  @JsonKey(name: 'is_final_test')
  final bool isFinalTest;
  final List<QuestionModel> _questions;
  @override
  List<QuestionModel> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @override
  @JsonKey()
  final int score;
  @override
  @JsonKey(name: 'xp_earned')
  final int xpEarned;
  @override
  @JsonKey(name: 'correct_answers')
  final int correctAnswers;
  @override
  @JsonKey(name: 'energy_lost')
  final int energyLost;

  @override
  String toString() {
    return 'QuizSession(id: $id, stepId: $stepId, topicId: $topicId, testId: $testId, sessionType: $sessionType, isFinalTest: $isFinalTest, questions: $questions, totalQuestions: $totalQuestions, score: $score, xpEarned: $xpEarned, correctAnswers: $correctAnswers, energyLost: $energyLost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stepId, stepId) || other.stepId == stepId) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.testId, testId) || other.testId == testId) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.isFinalTest, isFinalTest) ||
                other.isFinalTest == isFinalTest) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.energyLost, energyLost) ||
                other.energyLost == energyLost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stepId,
    topicId,
    testId,
    sessionType,
    isFinalTest,
    const DeepCollectionEquality().hash(_questions),
    totalQuestions,
    score,
    xpEarned,
    correctAnswers,
    energyLost,
  );

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSessionImplCopyWith<_$QuizSessionImpl> get copyWith =>
      __$$QuizSessionImplCopyWithImpl<_$QuizSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizSessionImplToJson(this);
  }
}

abstract class _QuizSession implements QuizSession {
  const factory _QuizSession({
    required final String id,
    @JsonKey(name: 'step_id') final String? stepId,
    @JsonKey(name: 'topic_id') final String? topicId,
    @JsonKey(name: 'test_id') final String? testId,
    @JsonKey(name: 'session_type') final String sessionType,
    @JsonKey(name: 'is_final_test') final bool isFinalTest,
    required final List<QuestionModel> questions,
    @JsonKey(name: 'total_questions') final int totalQuestions,
    final int score,
    @JsonKey(name: 'xp_earned') final int xpEarned,
    @JsonKey(name: 'correct_answers') final int correctAnswers,
    @JsonKey(name: 'energy_lost') final int energyLost,
  }) = _$QuizSessionImpl;

  factory _QuizSession.fromJson(Map<String, dynamic> json) =
      _$QuizSessionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'step_id')
  String? get stepId;
  @override
  @JsonKey(name: 'topic_id')
  String? get topicId;
  @override
  @JsonKey(name: 'test_id')
  String? get testId;
  @override
  @JsonKey(name: 'session_type')
  String get sessionType;
  @override
  @JsonKey(name: 'is_final_test')
  bool get isFinalTest;
  @override
  List<QuestionModel> get questions;
  @override
  @JsonKey(name: 'total_questions')
  int get totalQuestions;
  @override
  int get score;
  @override
  @JsonKey(name: 'xp_earned')
  int get xpEarned;
  @override
  @JsonKey(name: 'correct_answers')
  int get correctAnswers;
  @override
  @JsonKey(name: 'energy_lost')
  int get energyLost;

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizSessionImplCopyWith<_$QuizSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizFinishResult _$QuizFinishResultFromJson(Map<String, dynamic> json) {
  return _QuizFinishResult.fromJson(json);
}

/// @nodoc
mixin _$QuizFinishResult {
  @JsonKey(name: 'xp_earned')
  int get xpEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'acorn_earned')
  int get acornEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_completed')
  bool get stepCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'topic_completed')
  bool get topicCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'reward_available')
  bool get rewardAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'correct_answers')
  int get correctAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_questions')
  int get totalQuestions => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'step_completed') bool stepCompleted,
    @JsonKey(name: 'topic_completed') bool topicCompleted,
    @JsonKey(name: 'reward_available') bool rewardAvailable,
    @JsonKey(name: 'correct_answers') int correctAnswers,
    @JsonKey(name: 'total_questions') int totalQuestions,
    int score,
    int duration,
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
    Object? stepCompleted = null,
    Object? topicCompleted = null,
    Object? rewardAvailable = null,
    Object? correctAnswers = null,
    Object? totalQuestions = null,
    Object? score = null,
    Object? duration = null,
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
            stepCompleted: null == stepCompleted
                ? _value.stepCompleted
                : stepCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            topicCompleted: null == topicCompleted
                ? _value.topicCompleted
                : topicCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            rewardAvailable: null == rewardAvailable
                ? _value.rewardAvailable
                : rewardAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
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
    @JsonKey(name: 'step_completed') bool stepCompleted,
    @JsonKey(name: 'topic_completed') bool topicCompleted,
    @JsonKey(name: 'reward_available') bool rewardAvailable,
    @JsonKey(name: 'correct_answers') int correctAnswers,
    @JsonKey(name: 'total_questions') int totalQuestions,
    int score,
    int duration,
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
    Object? stepCompleted = null,
    Object? topicCompleted = null,
    Object? rewardAvailable = null,
    Object? correctAnswers = null,
    Object? totalQuestions = null,
    Object? score = null,
    Object? duration = null,
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
        stepCompleted: null == stepCompleted
            ? _value.stepCompleted
            : stepCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        topicCompleted: null == topicCompleted
            ? _value.topicCompleted
            : topicCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        rewardAvailable: null == rewardAvailable
            ? _value.rewardAvailable
            : rewardAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
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
    @JsonKey(name: 'step_completed') this.stepCompleted = false,
    @JsonKey(name: 'topic_completed') this.topicCompleted = false,
    @JsonKey(name: 'reward_available') this.rewardAvailable = false,
    @JsonKey(name: 'correct_answers') this.correctAnswers = 0,
    @JsonKey(name: 'total_questions') this.totalQuestions = 0,
    this.score = 0,
    this.duration = 0,
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
  @JsonKey(name: 'step_completed')
  final bool stepCompleted;
  @override
  @JsonKey(name: 'topic_completed')
  final bool topicCompleted;
  @override
  @JsonKey(name: 'reward_available')
  final bool rewardAvailable;
  @override
  @JsonKey(name: 'correct_answers')
  final int correctAnswers;
  @override
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @override
  @JsonKey()
  final int score;
  @override
  @JsonKey()
  final int duration;

  @override
  String toString() {
    return 'QuizFinishResult(xpEarned: $xpEarned, acornEarned: $acornEarned, stepCompleted: $stepCompleted, topicCompleted: $topicCompleted, rewardAvailable: $rewardAvailable, correctAnswers: $correctAnswers, totalQuestions: $totalQuestions, score: $score, duration: $duration)';
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
            (identical(other.stepCompleted, stepCompleted) ||
                other.stepCompleted == stepCompleted) &&
            (identical(other.topicCompleted, topicCompleted) ||
                other.topicCompleted == topicCompleted) &&
            (identical(other.rewardAvailable, rewardAvailable) ||
                other.rewardAvailable == rewardAvailable) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    xpEarned,
    acornEarned,
    stepCompleted,
    topicCompleted,
    rewardAvailable,
    correctAnswers,
    totalQuestions,
    score,
    duration,
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
    @JsonKey(name: 'step_completed') final bool stepCompleted,
    @JsonKey(name: 'topic_completed') final bool topicCompleted,
    @JsonKey(name: 'reward_available') final bool rewardAvailable,
    @JsonKey(name: 'correct_answers') final int correctAnswers,
    @JsonKey(name: 'total_questions') final int totalQuestions,
    final int score,
    final int duration,
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
  @JsonKey(name: 'step_completed')
  bool get stepCompleted;
  @override
  @JsonKey(name: 'topic_completed')
  bool get topicCompleted;
  @override
  @JsonKey(name: 'reward_available')
  bool get rewardAvailable;
  @override
  @JsonKey(name: 'correct_answers')
  int get correctAnswers;
  @override
  @JsonKey(name: 'total_questions')
  int get totalQuestions;
  @override
  int get score;
  @override
  int get duration;

  /// Create a copy of QuizFinishResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizFinishResultImplCopyWith<_$QuizFinishResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
