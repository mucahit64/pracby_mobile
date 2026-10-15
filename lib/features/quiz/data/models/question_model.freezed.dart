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
  @JsonKey(name: 'question_type', unknownEnumValue: QuestionType.multipleChoice)
  QuestionType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'answers')
  List<AnswerOption> get options => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_source')
  String? get examSource => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  String? get hint => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  @JsonKey(name: 'point_value')
  int get pointValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_data')
  Map<String, dynamic>? get typeData => throw _privateConstructorUsedError;

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
    @JsonKey(
      name: 'question_type',
      unknownEnumValue: QuestionType.multipleChoice,
    )
    QuestionType type,
    @JsonKey(name: 'answers') List<AnswerOption> options,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'exam_source') String? examSource,
    String? explanation,
    String? hint,
    int difficulty,
    @JsonKey(name: 'point_value') int pointValue,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
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
    Object? options = null,
    Object? imageUrl = freezed,
    Object? examSource = freezed,
    Object? explanation = freezed,
    Object? hint = freezed,
    Object? difficulty = null,
    Object? pointValue = null,
    Object? sortOrder = null,
    Object? typeData = freezed,
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
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<AnswerOption>,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            examSource: freezed == examSource
                ? _value.examSource
                : examSource // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(
      name: 'question_type',
      unknownEnumValue: QuestionType.multipleChoice,
    )
    QuestionType type,
    @JsonKey(name: 'answers') List<AnswerOption> options,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'exam_source') String? examSource,
    String? explanation,
    String? hint,
    int difficulty,
    @JsonKey(name: 'point_value') int pointValue,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
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
    Object? options = null,
    Object? imageUrl = freezed,
    Object? examSource = freezed,
    Object? explanation = freezed,
    Object? hint = freezed,
    Object? difficulty = null,
    Object? pointValue = null,
    Object? sortOrder = null,
    Object? typeData = freezed,
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
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<AnswerOption>,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        examSource: freezed == examSource
            ? _value.examSource
            : examSource // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(
      name: 'question_type',
      unknownEnumValue: QuestionType.multipleChoice,
    )
    required this.type,
    @JsonKey(name: 'answers') final List<AnswerOption> options = const [],
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'exam_source') this.examSource,
    this.explanation,
    this.hint,
    this.difficulty = 1,
    @JsonKey(name: 'point_value') this.pointValue = 1,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'type_data') final Map<String, dynamic>? typeData,
  }) : _options = options,
       _typeData = typeData;

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'question_text')
  final String text;
  @override
  @JsonKey(name: 'question_type', unknownEnumValue: QuestionType.multipleChoice)
  final QuestionType type;
  final List<AnswerOption> _options;
  @override
  @JsonKey(name: 'answers')
  List<AnswerOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'exam_source')
  final String? examSource;
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

  @override
  String toString() {
    return 'QuestionModel(id: $id, text: $text, type: $type, options: $options, imageUrl: $imageUrl, examSource: $examSource, explanation: $explanation, hint: $hint, difficulty: $difficulty, pointValue: $pointValue, sortOrder: $sortOrder, typeData: $typeData)';
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
            (identical(other.examSource, examSource) ||
                other.examSource == examSource) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.pointValue, pointValue) ||
                other.pointValue == pointValue) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._typeData, _typeData));
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
    examSource,
    explanation,
    hint,
    difficulty,
    pointValue,
    sortOrder,
    const DeepCollectionEquality().hash(_typeData),
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
    @JsonKey(
      name: 'question_type',
      unknownEnumValue: QuestionType.multipleChoice,
    )
    required final QuestionType type,
    @JsonKey(name: 'answers') final List<AnswerOption> options,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'exam_source') final String? examSource,
    final String? explanation,
    final String? hint,
    final int difficulty,
    @JsonKey(name: 'point_value') final int pointValue,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'type_data') final Map<String, dynamic>? typeData,
  }) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'question_text')
  String get text;
  @override
  @JsonKey(name: 'question_type', unknownEnumValue: QuestionType.multipleChoice)
  QuestionType get type;
  @override
  @JsonKey(name: 'answers')
  List<AnswerOption> get options;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'exam_source')
  String? get examSource;
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
  Map<String, dynamic>? get typeData;

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
  String toString() {
    return 'AnswerOption(id: $id, text: $text, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isCorrect);

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

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerOptionImplCopyWith<_$AnswerOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
