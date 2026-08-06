// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return _QuestionModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_text')
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  QuestionType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'answers')
  List<AnswerOption>? get options => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  String? get hint => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  @JsonKey(name: 'point_value')
  int get pointValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_data')
  Map<String, dynamic>? get typeData => throw _privateConstructorUsedError; // For fill-in-blank
  List<String>? get blanks => throw _privateConstructorUsedError;
  List<String>? get chips =>
      throw _privateConstructorUsedError; // For flashcard
  String? get front => throw _privateConstructorUsedError;
  String? get back => throw _privateConstructorUsedError;

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionModelCopyWith<QuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelCopyWith<$Res> {
  factory $QuestionModelCopyWith(
    QuestionModel value,
    $Res Function(QuestionModel) then,
  ) = _$QuestionModelCopyWithImpl<$Res, QuestionModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'question_text') String text,
    @JsonKey(name: 'question_type') QuestionType type,
    @JsonKey(name: 'answers') List<AnswerOption>? options,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? explanation,
    String? hint,
    int difficulty,
    @JsonKey(name: 'point_value') int pointValue,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
    List<String>? blanks,
    List<String>? chips,
    String? front,
    String? back,
  });
}

/// @nodoc
class _$QuestionModelCopyWithImpl<$Res, $Val extends QuestionModel>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? options = freezed,
    Object? imageUrl = freezed,
    Object? explanation = freezed,
    Object? hint = freezed,
    Object? difficulty = null,
    Object? pointValue = null,
    Object? sortOrder = null,
    Object? typeData = freezed,
    Object? blanks = freezed,
    Object? chips = freezed,
    Object? front = freezed,
    Object? back = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as QuestionType,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<AnswerOption>?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
            hint: freezed == hint
                ? _value.hint
                : hint // ignore: cast_nullable_to_non_nullable
                      as String?,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as int,
            pointValue: null == pointValue
                ? _value.pointValue
                : pointValue // ignore: cast_nullable_to_non_nullable
                      as int,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            typeData: freezed == typeData
                ? _value.typeData
                : typeData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            blanks: freezed == blanks
                ? _value.blanks
                : blanks // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            chips: freezed == chips
                ? _value.chips
                : chips // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            front: freezed == front
                ? _value.front
                : front // ignore: cast_nullable_to_non_nullable
                      as String?,
            back: freezed == back
                ? _value.back
                : back // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuestionModelImplCopyWith<$Res>
    implements $QuestionModelCopyWith<$Res> {
  factory _$$QuestionModelImplCopyWith(
    _$QuestionModelImpl value,
    $Res Function(_$QuestionModelImpl) then,
  ) = __$$QuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'question_text') String text,
    @JsonKey(name: 'question_type') QuestionType type,
    @JsonKey(name: 'answers') List<AnswerOption>? options,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? explanation,
    String? hint,
    int difficulty,
    @JsonKey(name: 'point_value') int pointValue,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
    List<String>? blanks,
    List<String>? chips,
    String? front,
    String? back,
  });
}

/// @nodoc
class __$$QuestionModelImplCopyWithImpl<$Res>
    extends _$QuestionModelCopyWithImpl<$Res, _$QuestionModelImpl>
    implements _$$QuestionModelImplCopyWith<$Res> {
  __$$QuestionModelImplCopyWithImpl(
    _$QuestionModelImpl _value,
    $Res Function(_$QuestionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? options = freezed,
    Object? imageUrl = freezed,
    Object? explanation = freezed,
    Object? hint = freezed,
    Object? difficulty = null,
    Object? pointValue = null,
    Object? sortOrder = null,
    Object? typeData = freezed,
    Object? blanks = freezed,
    Object? chips = freezed,
    Object? front = freezed,
    Object? back = freezed,
  }) {
    return _then(
      _$QuestionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as QuestionType,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<AnswerOption>?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
        hint: freezed == hint
            ? _value.hint
            : hint // ignore: cast_nullable_to_non_nullable
                  as String?,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as int,
        pointValue: null == pointValue
            ? _value.pointValue
            : pointValue // ignore: cast_nullable_to_non_nullable
                  as int,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        typeData: freezed == typeData
            ? _value._typeData
            : typeData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        blanks: freezed == blanks
            ? _value._blanks
            : blanks // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        chips: freezed == chips
            ? _value._chips
            : chips // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        front: freezed == front
            ? _value.front
            : front // ignore: cast_nullable_to_non_nullable
                  as String?,
        back: freezed == back
            ? _value.back
            : back // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionModelImpl implements _QuestionModel {
  const _$QuestionModelImpl({
    required this.id,
    @JsonKey(name: 'question_text') required this.text,
    @JsonKey(name: 'question_type') required this.type,
    @JsonKey(name: 'answers') final List<AnswerOption>? options,
    @JsonKey(name: 'image_url') this.imageUrl,
    this.explanation,
    this.hint,
    this.difficulty = 1,
    @JsonKey(name: 'point_value') this.pointValue = 1,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'type_data') final Map<String, dynamic>? typeData,
    final List<String>? blanks,
    final List<String>? chips,
    this.front,
    this.back,
  }) : _options = options,
       _typeData = typeData,
       _blanks = blanks,
       _chips = chips;

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'question_text')
  final String text;
  @override
  @JsonKey(name: 'question_type')
  final QuestionType type;
  final List<AnswerOption>? _options;
  @override
  @JsonKey(name: 'answers')
  List<AnswerOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String? explanation;
  @override
  final String? hint;
  @override
  @JsonKey()
  final int difficulty;
  @override
  @JsonKey(name: 'point_value')
  final int pointValue;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  final Map<String, dynamic>? _typeData;
  @override
  @JsonKey(name: 'type_data')
  Map<String, dynamic>? get typeData {
    final value = _typeData;
    if (value == null) return null;
    if (_typeData is EqualUnmodifiableMapView) return _typeData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // For fill-in-blank
  final List<String>? _blanks;
  // For fill-in-blank
  @override
  List<String>? get blanks {
    final value = _blanks;
    if (value == null) return null;
    if (_blanks is EqualUnmodifiableListView) return _blanks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _chips;
  @override
  List<String>? get chips {
    final value = _chips;
    if (value == null) return null;
    if (_chips is EqualUnmodifiableListView) return _chips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // For flashcard
  @override
  final String? front;
  @override
  final String? back;

  @override
  String toString() {
    return 'QuestionModel(id: $id, text: $text, type: $type, options: $options, imageUrl: $imageUrl, explanation: $explanation, hint: $hint, difficulty: $difficulty, pointValue: $pointValue, sortOrder: $sortOrder, typeData: $typeData, blanks: $blanks, chips: $chips, front: $front, back: $back)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.pointValue, pointValue) ||
                other.pointValue == pointValue) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._typeData, _typeData) &&
            const DeepCollectionEquality().equals(other._blanks, _blanks) &&
            const DeepCollectionEquality().equals(other._chips, _chips) &&
            (identical(other.front, front) || other.front == front) &&
            (identical(other.back, back) || other.back == back));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    text,
    type,
    const DeepCollectionEquality().hash(_options),
    imageUrl,
    explanation,
    hint,
    difficulty,
    pointValue,
    sortOrder,
    const DeepCollectionEquality().hash(_typeData),
    const DeepCollectionEquality().hash(_blanks),
    const DeepCollectionEquality().hash(_chips),
    front,
    back,
  );

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      __$$QuestionModelImplCopyWithImpl<_$QuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelImplToJson(this);
  }
}

abstract class _QuestionModel implements QuestionModel {
  const factory _QuestionModel({
    required final String id,
    @JsonKey(name: 'question_text') required final String text,
    @JsonKey(name: 'question_type') required final QuestionType type,
    @JsonKey(name: 'answers') final List<AnswerOption>? options,
    @JsonKey(name: 'image_url') final String? imageUrl,
    final String? explanation,
    final String? hint,
    final int difficulty,
    @JsonKey(name: 'point_value') final int pointValue,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'type_data') final Map<String, dynamic>? typeData,
    final List<String>? blanks,
    final List<String>? chips,
    final String? front,
    final String? back,
  }) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'question_text')
  String get text;
  @override
  @JsonKey(name: 'question_type')
  QuestionType get type;
  @override
  @JsonKey(name: 'answers')
  List<AnswerOption>? get options;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String? get explanation;
  @override
  String? get hint;
  @override
  int get difficulty;
  @override
  @JsonKey(name: 'point_value')
  int get pointValue;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'type_data')
  Map<String, dynamic>? get typeData; // For fill-in-blank
  @override
  List<String>? get blanks;
  @override
  List<String>? get chips; // For flashcard
  @override
  String? get front;
  @override
  String? get back;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnswerOption _$AnswerOptionFromJson(Map<String, dynamic> json) {
  return _AnswerOption.fromJson(json);
}

/// @nodoc
mixin _$AnswerOption {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'answer_text')
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  /// Serializes this AnswerOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerOptionCopyWith<AnswerOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerOptionCopyWith<$Res> {
  factory $AnswerOptionCopyWith(
    AnswerOption value,
    $Res Function(AnswerOption) then,
  ) = _$AnswerOptionCopyWithImpl<$Res, AnswerOption>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'answer_text') String text,
    @JsonKey(name: 'is_correct') bool isCorrect,
    String? label,
  });
}

/// @nodoc
class _$AnswerOptionCopyWithImpl<$Res, $Val extends AnswerOption>
    implements $AnswerOptionCopyWith<$Res> {
  _$AnswerOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
    Object? label = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnswerOptionImplCopyWith<$Res>
    implements $AnswerOptionCopyWith<$Res> {
  factory _$$AnswerOptionImplCopyWith(
    _$AnswerOptionImpl value,
    $Res Function(_$AnswerOptionImpl) then,
  ) = __$$AnswerOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'answer_text') String text,
    @JsonKey(name: 'is_correct') bool isCorrect,
    String? label,
  });
}

/// @nodoc
class __$$AnswerOptionImplCopyWithImpl<$Res>
    extends _$AnswerOptionCopyWithImpl<$Res, _$AnswerOptionImpl>
    implements _$$AnswerOptionImplCopyWith<$Res> {
  __$$AnswerOptionImplCopyWithImpl(
    _$AnswerOptionImpl _value,
    $Res Function(_$AnswerOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
    Object? label = freezed,
  }) {
    return _then(
      _$AnswerOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerOptionImpl implements _AnswerOption {
  const _$AnswerOptionImpl({
    required this.id,
    @JsonKey(name: 'answer_text') required this.text,
    @JsonKey(name: 'is_correct') this.isCorrect = false,
    this.label,
  });

  factory _$AnswerOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerOptionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'answer_text')
  final String text;
  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  final String? label;

  @override
  String toString() {
    return 'AnswerOption(id: $id, text: $text, isCorrect: $isCorrect, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isCorrect, label);

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerOptionImplCopyWith<_$AnswerOptionImpl> get copyWith =>
      __$$AnswerOptionImplCopyWithImpl<_$AnswerOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerOptionImplToJson(this);
  }
}

abstract class _AnswerOption implements AnswerOption {
  const factory _AnswerOption({
    required final String id,
    @JsonKey(name: 'answer_text') required final String text,
    @JsonKey(name: 'is_correct') final bool isCorrect,
    final String? label,
  }) = _$AnswerOptionImpl;

  factory _AnswerOption.fromJson(Map<String, dynamic> json) =
      _$AnswerOptionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'answer_text')
  String get text;
  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  String? get label;

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerOptionImplCopyWith<_$AnswerOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchingPair _$MatchingPairFromJson(Map<String, dynamic> json) {
  return _MatchingPair.fromJson(json);
}

/// @nodoc
mixin _$MatchingPair {
  String get left => throw _privateConstructorUsedError;
  String get right => throw _privateConstructorUsedError;

  /// Serializes this MatchingPair to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchingPairCopyWith<MatchingPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingPairCopyWith<$Res> {
  factory $MatchingPairCopyWith(
    MatchingPair value,
    $Res Function(MatchingPair) then,
  ) = _$MatchingPairCopyWithImpl<$Res, MatchingPair>;
  @useResult
  $Res call({String left, String right});
}

/// @nodoc
class _$MatchingPairCopyWithImpl<$Res, $Val extends MatchingPair>
    implements $MatchingPairCopyWith<$Res> {
  _$MatchingPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? left = null, Object? right = null}) {
    return _then(
      _value.copyWith(
            left: null == left
                ? _value.left
                : left // ignore: cast_nullable_to_non_nullable
                      as String,
            right: null == right
                ? _value.right
                : right // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchingPairImplCopyWith<$Res>
    implements $MatchingPairCopyWith<$Res> {
  factory _$$MatchingPairImplCopyWith(
    _$MatchingPairImpl value,
    $Res Function(_$MatchingPairImpl) then,
  ) = __$$MatchingPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String left, String right});
}

/// @nodoc
class __$$MatchingPairImplCopyWithImpl<$Res>
    extends _$MatchingPairCopyWithImpl<$Res, _$MatchingPairImpl>
    implements _$$MatchingPairImplCopyWith<$Res> {
  __$$MatchingPairImplCopyWithImpl(
    _$MatchingPairImpl _value,
    $Res Function(_$MatchingPairImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? left = null, Object? right = null}) {
    return _then(
      _$MatchingPairImpl(
        left: null == left
            ? _value.left
            : left // ignore: cast_nullable_to_non_nullable
                  as String,
        right: null == right
            ? _value.right
            : right // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchingPairImpl implements _MatchingPair {
  const _$MatchingPairImpl({required this.left, required this.right});

  factory _$MatchingPairImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchingPairImplFromJson(json);

  @override
  final String left;
  @override
  final String right;

  @override
  String toString() {
    return 'MatchingPair(left: $left, right: $right)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchingPairImpl &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.right, right) || other.right == right));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, left, right);

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchingPairImplCopyWith<_$MatchingPairImpl> get copyWith =>
      __$$MatchingPairImplCopyWithImpl<_$MatchingPairImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchingPairImplToJson(this);
  }
}

abstract class _MatchingPair implements MatchingPair {
  const factory _MatchingPair({
    required final String left,
    required final String right,
  }) = _$MatchingPairImpl;

  factory _MatchingPair.fromJson(Map<String, dynamic> json) =
      _$MatchingPairImpl.fromJson;

  @override
  String get left;
  @override
  String get right;

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchingPairImplCopyWith<_$MatchingPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderingItem _$OrderingItemFromJson(Map<String, dynamic> json) {
  return _OrderingItem.fromJson(json);
}

/// @nodoc
mixin _$OrderingItem {
  String get text => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;

  /// Serializes this OrderingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderingItemCopyWith<OrderingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderingItemCopyWith<$Res> {
  factory $OrderingItemCopyWith(
    OrderingItem value,
    $Res Function(OrderingItem) then,
  ) = _$OrderingItemCopyWithImpl<$Res, OrderingItem>;
  @useResult
  $Res call({String text, int position});
}

/// @nodoc
class _$OrderingItemCopyWithImpl<$Res, $Val extends OrderingItem>
    implements $OrderingItemCopyWith<$Res> {
  _$OrderingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? position = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderingItemImplCopyWith<$Res>
    implements $OrderingItemCopyWith<$Res> {
  factory _$$OrderingItemImplCopyWith(
    _$OrderingItemImpl value,
    $Res Function(_$OrderingItemImpl) then,
  ) = __$$OrderingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, int position});
}

/// @nodoc
class __$$OrderingItemImplCopyWithImpl<$Res>
    extends _$OrderingItemCopyWithImpl<$Res, _$OrderingItemImpl>
    implements _$$OrderingItemImplCopyWith<$Res> {
  __$$OrderingItemImplCopyWithImpl(
    _$OrderingItemImpl _value,
    $Res Function(_$OrderingItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? position = null}) {
    return _then(
      _$OrderingItemImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderingItemImpl implements _OrderingItem {
  const _$OrderingItemImpl({required this.text, required this.position});

  factory _$OrderingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderingItemImplFromJson(json);

  @override
  final String text;
  @override
  final int position;

  @override
  String toString() {
    return 'OrderingItem(text: $text, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderingItemImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, position);

  /// Create a copy of OrderingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderingItemImplCopyWith<_$OrderingItemImpl> get copyWith =>
      __$$OrderingItemImplCopyWithImpl<_$OrderingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderingItemImplToJson(this);
  }
}

abstract class _OrderingItem implements OrderingItem {
  const factory _OrderingItem({
    required final String text,
    required final int position,
  }) = _$OrderingItemImpl;

  factory _OrderingItem.fromJson(Map<String, dynamic> json) =
      _$OrderingItemImpl.fromJson;

  @override
  String get text;
  @override
  int get position;

  /// Create a copy of OrderingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderingItemImplCopyWith<_$OrderingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
