// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizAnswer _$QuizAnswerFromJson(Map<String, dynamic> json) {
  return _QuizAnswer.fromJson(json);
}

/// @nodoc
mixin _$QuizAnswer {
  String get questionId => throw _privateConstructorUsedError;

  /// ISO 8601 in UTC (`...Z`); Zod's `datetime()` rejects local offsets.
  String get answeredAt => throw _privateConstructorUsedError;
  String? get answerId => throw _privateConstructorUsedError;
  bool get isSkipped => throw _privateConstructorUsedError;
  int? get timeSpent => throw _privateConstructorUsedError;
  String? get textAnswer => throw _privateConstructorUsedError;
  List<MatchingAnswerPair>? get matchingAnswer =>
      throw _privateConstructorUsedError;
  List<int>? get orderedIndices => throw _privateConstructorUsedError;

  /// Only for flashcards; the server grades every other type itself.
  bool? get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this QuizAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerCopyWith<QuizAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerCopyWith<$Res> {
  factory $QuizAnswerCopyWith(
    QuizAnswer value,
    $Res Function(QuizAnswer) then,
  ) = _$QuizAnswerCopyWithImpl<$Res, QuizAnswer>;
  @useResult
  $Res call({
    String questionId,
    String answeredAt,
    String? answerId,
    bool isSkipped,
    int? timeSpent,
    String? textAnswer,
    List<MatchingAnswerPair>? matchingAnswer,
    List<int>? orderedIndices,
    bool? isCorrect,
  });
}

/// @nodoc
class _$QuizAnswerCopyWithImpl<$Res, $Val extends QuizAnswer>
    implements $QuizAnswerCopyWith<$Res> {
  _$QuizAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? answeredAt = null,
    Object? answerId = freezed,
    Object? isSkipped = null,
    Object? timeSpent = freezed,
    Object? textAnswer = freezed,
    Object? matchingAnswer = freezed,
    Object? orderedIndices = freezed,
    Object? isCorrect = freezed,
  }) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            answeredAt: null == answeredAt
                ? _value.answeredAt
                : answeredAt // ignore: cast_nullable_to_non_nullable
                      as String,
            answerId: freezed == answerId
                ? _value.answerId
                : answerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSkipped: null == isSkipped
                ? _value.isSkipped
                : isSkipped // ignore: cast_nullable_to_non_nullable
                      as bool,
            timeSpent: freezed == timeSpent
                ? _value.timeSpent
                : timeSpent // ignore: cast_nullable_to_non_nullable
                      as int?,
            textAnswer: freezed == textAnswer
                ? _value.textAnswer
                : textAnswer // ignore: cast_nullable_to_non_nullable
                      as String?,
            matchingAnswer: freezed == matchingAnswer
                ? _value.matchingAnswer
                : matchingAnswer // ignore: cast_nullable_to_non_nullable
                      as List<MatchingAnswerPair>?,
            orderedIndices: freezed == orderedIndices
                ? _value.orderedIndices
                : orderedIndices // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            isCorrect: freezed == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerImplCopyWith<$Res>
    implements $QuizAnswerCopyWith<$Res> {
  factory _$$QuizAnswerImplCopyWith(
    _$QuizAnswerImpl value,
    $Res Function(_$QuizAnswerImpl) then,
  ) = __$$QuizAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String questionId,
    String answeredAt,
    String? answerId,
    bool isSkipped,
    int? timeSpent,
    String? textAnswer,
    List<MatchingAnswerPair>? matchingAnswer,
    List<int>? orderedIndices,
    bool? isCorrect,
  });
}

/// @nodoc
class __$$QuizAnswerImplCopyWithImpl<$Res>
    extends _$QuizAnswerCopyWithImpl<$Res, _$QuizAnswerImpl>
    implements _$$QuizAnswerImplCopyWith<$Res> {
  __$$QuizAnswerImplCopyWithImpl(
    _$QuizAnswerImpl _value,
    $Res Function(_$QuizAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? answeredAt = null,
    Object? answerId = freezed,
    Object? isSkipped = null,
    Object? timeSpent = freezed,
    Object? textAnswer = freezed,
    Object? matchingAnswer = freezed,
    Object? orderedIndices = freezed,
    Object? isCorrect = freezed,
  }) {
    return _then(
      _$QuizAnswerImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        answeredAt: null == answeredAt
            ? _value.answeredAt
            : answeredAt // ignore: cast_nullable_to_non_nullable
                  as String,
        answerId: freezed == answerId
            ? _value.answerId
            : answerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSkipped: null == isSkipped
            ? _value.isSkipped
            : isSkipped // ignore: cast_nullable_to_non_nullable
                  as bool,
        timeSpent: freezed == timeSpent
            ? _value.timeSpent
            : timeSpent // ignore: cast_nullable_to_non_nullable
                  as int?,
        textAnswer: freezed == textAnswer
            ? _value.textAnswer
            : textAnswer // ignore: cast_nullable_to_non_nullable
                  as String?,
        matchingAnswer: freezed == matchingAnswer
            ? _value._matchingAnswer
            : matchingAnswer // ignore: cast_nullable_to_non_nullable
                  as List<MatchingAnswerPair>?,
        orderedIndices: freezed == orderedIndices
            ? _value._orderedIndices
            : orderedIndices // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        isCorrect: freezed == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _$QuizAnswerImpl implements _QuizAnswer {
  const _$QuizAnswerImpl({
    required this.questionId,
    required this.answeredAt,
    this.answerId,
    this.isSkipped = false,
    this.timeSpent,
    this.textAnswer,
    final List<MatchingAnswerPair>? matchingAnswer,
    final List<int>? orderedIndices,
    this.isCorrect,
  }) : _matchingAnswer = matchingAnswer,
       _orderedIndices = orderedIndices;

  factory _$QuizAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnswerImplFromJson(json);

  @override
  final String questionId;

  /// ISO 8601 in UTC (`...Z`); Zod's `datetime()` rejects local offsets.
  @override
  final String answeredAt;
  @override
  final String? answerId;
  @override
  @JsonKey()
  final bool isSkipped;
  @override
  final int? timeSpent;
  @override
  final String? textAnswer;
  final List<MatchingAnswerPair>? _matchingAnswer;
  @override
  List<MatchingAnswerPair>? get matchingAnswer {
    final value = _matchingAnswer;
    if (value == null) return null;
    if (_matchingAnswer is EqualUnmodifiableListView) return _matchingAnswer;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _orderedIndices;
  @override
  List<int>? get orderedIndices {
    final value = _orderedIndices;
    if (value == null) return null;
    if (_orderedIndices is EqualUnmodifiableListView) return _orderedIndices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Only for flashcards; the server grades every other type itself.
  @override
  final bool? isCorrect;

  @override
  String toString() {
    return 'QuizAnswer(questionId: $questionId, answeredAt: $answeredAt, answerId: $answerId, isSkipped: $isSkipped, timeSpent: $timeSpent, textAnswer: $textAnswer, matchingAnswer: $matchingAnswer, orderedIndices: $orderedIndices, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt) &&
            (identical(other.answerId, answerId) ||
                other.answerId == answerId) &&
            (identical(other.isSkipped, isSkipped) ||
                other.isSkipped == isSkipped) &&
            (identical(other.timeSpent, timeSpent) ||
                other.timeSpent == timeSpent) &&
            (identical(other.textAnswer, textAnswer) ||
                other.textAnswer == textAnswer) &&
            const DeepCollectionEquality().equals(
              other._matchingAnswer,
              _matchingAnswer,
            ) &&
            const DeepCollectionEquality().equals(
              other._orderedIndices,
              _orderedIndices,
            ) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    questionId,
    answeredAt,
    answerId,
    isSkipped,
    timeSpent,
    textAnswer,
    const DeepCollectionEquality().hash(_matchingAnswer),
    const DeepCollectionEquality().hash(_orderedIndices),
    isCorrect,
  );

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      __$$QuizAnswerImplCopyWithImpl<_$QuizAnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnswerImplToJson(this);
  }
}

abstract class _QuizAnswer implements QuizAnswer {
  const factory _QuizAnswer({
    required final String questionId,
    required final String answeredAt,
    final String? answerId,
    final bool isSkipped,
    final int? timeSpent,
    final String? textAnswer,
    final List<MatchingAnswerPair>? matchingAnswer,
    final List<int>? orderedIndices,
    final bool? isCorrect,
  }) = _$QuizAnswerImpl;

  factory _QuizAnswer.fromJson(Map<String, dynamic> json) =
      _$QuizAnswerImpl.fromJson;

  @override
  String get questionId;

  /// ISO 8601 in UTC (`...Z`); Zod's `datetime()` rejects local offsets.
  @override
  String get answeredAt;
  @override
  String? get answerId;
  @override
  bool get isSkipped;
  @override
  int? get timeSpent;
  @override
  String? get textAnswer;
  @override
  List<MatchingAnswerPair>? get matchingAnswer;
  @override
  List<int>? get orderedIndices;

  /// Only for flashcards; the server grades every other type itself.
  @override
  bool? get isCorrect;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchingAnswerPair _$MatchingAnswerPairFromJson(Map<String, dynamic> json) {
  return _MatchingAnswerPair.fromJson(json);
}

/// @nodoc
mixin _$MatchingAnswerPair {
  int get leftIndex => throw _privateConstructorUsedError;
  int get rightIndex => throw _privateConstructorUsedError;

  /// Serializes this MatchingAnswerPair to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchingAnswerPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchingAnswerPairCopyWith<MatchingAnswerPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingAnswerPairCopyWith<$Res> {
  factory $MatchingAnswerPairCopyWith(
    MatchingAnswerPair value,
    $Res Function(MatchingAnswerPair) then,
  ) = _$MatchingAnswerPairCopyWithImpl<$Res, MatchingAnswerPair>;
  @useResult
  $Res call({int leftIndex, int rightIndex});
}

/// @nodoc
class _$MatchingAnswerPairCopyWithImpl<$Res, $Val extends MatchingAnswerPair>
    implements $MatchingAnswerPairCopyWith<$Res> {
  _$MatchingAnswerPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingAnswerPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? leftIndex = null, Object? rightIndex = null}) {
    return _then(
      _value.copyWith(
            leftIndex: null == leftIndex
                ? _value.leftIndex
                : leftIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            rightIndex: null == rightIndex
                ? _value.rightIndex
                : rightIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchingAnswerPairImplCopyWith<$Res>
    implements $MatchingAnswerPairCopyWith<$Res> {
  factory _$$MatchingAnswerPairImplCopyWith(
    _$MatchingAnswerPairImpl value,
    $Res Function(_$MatchingAnswerPairImpl) then,
  ) = __$$MatchingAnswerPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int leftIndex, int rightIndex});
}

/// @nodoc
class __$$MatchingAnswerPairImplCopyWithImpl<$Res>
    extends _$MatchingAnswerPairCopyWithImpl<$Res, _$MatchingAnswerPairImpl>
    implements _$$MatchingAnswerPairImplCopyWith<$Res> {
  __$$MatchingAnswerPairImplCopyWithImpl(
    _$MatchingAnswerPairImpl _value,
    $Res Function(_$MatchingAnswerPairImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingAnswerPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? leftIndex = null, Object? rightIndex = null}) {
    return _then(
      _$MatchingAnswerPairImpl(
        leftIndex: null == leftIndex
            ? _value.leftIndex
            : leftIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        rightIndex: null == rightIndex
            ? _value.rightIndex
            : rightIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchingAnswerPairImpl implements _MatchingAnswerPair {
  const _$MatchingAnswerPairImpl({
    required this.leftIndex,
    required this.rightIndex,
  });

  factory _$MatchingAnswerPairImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchingAnswerPairImplFromJson(json);

  @override
  final int leftIndex;
  @override
  final int rightIndex;

  @override
  String toString() {
    return 'MatchingAnswerPair(leftIndex: $leftIndex, rightIndex: $rightIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchingAnswerPairImpl &&
            (identical(other.leftIndex, leftIndex) ||
                other.leftIndex == leftIndex) &&
            (identical(other.rightIndex, rightIndex) ||
                other.rightIndex == rightIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, leftIndex, rightIndex);

  /// Create a copy of MatchingAnswerPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchingAnswerPairImplCopyWith<_$MatchingAnswerPairImpl> get copyWith =>
      __$$MatchingAnswerPairImplCopyWithImpl<_$MatchingAnswerPairImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchingAnswerPairImplToJson(this);
  }
}

abstract class _MatchingAnswerPair implements MatchingAnswerPair {
  const factory _MatchingAnswerPair({
    required final int leftIndex,
    required final int rightIndex,
  }) = _$MatchingAnswerPairImpl;

  factory _MatchingAnswerPair.fromJson(Map<String, dynamic> json) =
      _$MatchingAnswerPairImpl.fromJson;

  @override
  int get leftIndex;
  @override
  int get rightIndex;

  /// Create a copy of MatchingAnswerPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchingAnswerPairImplCopyWith<_$MatchingAnswerPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
