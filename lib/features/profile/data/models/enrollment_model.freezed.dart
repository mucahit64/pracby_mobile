// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EnrollmentModel _$EnrollmentModelFromJson(Map<String, dynamic> json) {
  return _EnrollmentModel.fromJson(json);
}

/// @nodoc
mixin _$EnrollmentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_type_id')
  String get examTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'enrolled_at')
  DateTime get enrolledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_type_name')
  String get examTypeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_type_slug')
  String get examTypeSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_group_name')
  String get examGroupName => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_group_slug')
  String get examGroupSlug => throw _privateConstructorUsedError;

  /// Serializes this EnrollmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnrollmentModelCopyWith<EnrollmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrollmentModelCopyWith<$Res> {
  factory $EnrollmentModelCopyWith(
    EnrollmentModel value,
    $Res Function(EnrollmentModel) then,
  ) = _$EnrollmentModelCopyWithImpl<$Res, EnrollmentModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exam_type_id') String examTypeId,
    @JsonKey(name: 'enrolled_at') DateTime enrolledAt,
    @JsonKey(name: 'exam_type_name') String examTypeName,
    @JsonKey(name: 'exam_type_slug') String examTypeSlug,
    @JsonKey(name: 'exam_group_name') String examGroupName,
    @JsonKey(name: 'exam_group_slug') String examGroupSlug,
  });
}

/// @nodoc
class _$EnrollmentModelCopyWithImpl<$Res, $Val extends EnrollmentModel>
    implements $EnrollmentModelCopyWith<$Res> {
  _$EnrollmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? examTypeId = null,
    Object? enrolledAt = null,
    Object? examTypeName = null,
    Object? examTypeSlug = null,
    Object? examGroupName = null,
    Object? examGroupSlug = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            examTypeId: null == examTypeId
                ? _value.examTypeId
                : examTypeId // ignore: cast_nullable_to_non_nullable
                      as String,
            enrolledAt: null == enrolledAt
                ? _value.enrolledAt
                : enrolledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            examTypeName: null == examTypeName
                ? _value.examTypeName
                : examTypeName // ignore: cast_nullable_to_non_nullable
                      as String,
            examTypeSlug: null == examTypeSlug
                ? _value.examTypeSlug
                : examTypeSlug // ignore: cast_nullable_to_non_nullable
                      as String,
            examGroupName: null == examGroupName
                ? _value.examGroupName
                : examGroupName // ignore: cast_nullable_to_non_nullable
                      as String,
            examGroupSlug: null == examGroupSlug
                ? _value.examGroupSlug
                : examGroupSlug // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnrollmentModelImplCopyWith<$Res>
    implements $EnrollmentModelCopyWith<$Res> {
  factory _$$EnrollmentModelImplCopyWith(
    _$EnrollmentModelImpl value,
    $Res Function(_$EnrollmentModelImpl) then,
  ) = __$$EnrollmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exam_type_id') String examTypeId,
    @JsonKey(name: 'enrolled_at') DateTime enrolledAt,
    @JsonKey(name: 'exam_type_name') String examTypeName,
    @JsonKey(name: 'exam_type_slug') String examTypeSlug,
    @JsonKey(name: 'exam_group_name') String examGroupName,
    @JsonKey(name: 'exam_group_slug') String examGroupSlug,
  });
}

/// @nodoc
class __$$EnrollmentModelImplCopyWithImpl<$Res>
    extends _$EnrollmentModelCopyWithImpl<$Res, _$EnrollmentModelImpl>
    implements _$$EnrollmentModelImplCopyWith<$Res> {
  __$$EnrollmentModelImplCopyWithImpl(
    _$EnrollmentModelImpl _value,
    $Res Function(_$EnrollmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? examTypeId = null,
    Object? enrolledAt = null,
    Object? examTypeName = null,
    Object? examTypeSlug = null,
    Object? examGroupName = null,
    Object? examGroupSlug = null,
  }) {
    return _then(
      _$EnrollmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        examTypeId: null == examTypeId
            ? _value.examTypeId
            : examTypeId // ignore: cast_nullable_to_non_nullable
                  as String,
        enrolledAt: null == enrolledAt
            ? _value.enrolledAt
            : enrolledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        examTypeName: null == examTypeName
            ? _value.examTypeName
            : examTypeName // ignore: cast_nullable_to_non_nullable
                  as String,
        examTypeSlug: null == examTypeSlug
            ? _value.examTypeSlug
            : examTypeSlug // ignore: cast_nullable_to_non_nullable
                  as String,
        examGroupName: null == examGroupName
            ? _value.examGroupName
            : examGroupName // ignore: cast_nullable_to_non_nullable
                  as String,
        examGroupSlug: null == examGroupSlug
            ? _value.examGroupSlug
            : examGroupSlug // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnrollmentModelImpl implements _EnrollmentModel {
  const _$EnrollmentModelImpl({
    required this.id,
    @JsonKey(name: 'exam_type_id') required this.examTypeId,
    @JsonKey(name: 'enrolled_at') required this.enrolledAt,
    @JsonKey(name: 'exam_type_name') required this.examTypeName,
    @JsonKey(name: 'exam_type_slug') required this.examTypeSlug,
    @JsonKey(name: 'exam_group_name') required this.examGroupName,
    @JsonKey(name: 'exam_group_slug') required this.examGroupSlug,
  });

  factory _$EnrollmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnrollmentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'exam_type_id')
  final String examTypeId;
  @override
  @JsonKey(name: 'enrolled_at')
  final DateTime enrolledAt;
  @override
  @JsonKey(name: 'exam_type_name')
  final String examTypeName;
  @override
  @JsonKey(name: 'exam_type_slug')
  final String examTypeSlug;
  @override
  @JsonKey(name: 'exam_group_name')
  final String examGroupName;
  @override
  @JsonKey(name: 'exam_group_slug')
  final String examGroupSlug;

  @override
  String toString() {
    return 'EnrollmentModel(id: $id, examTypeId: $examTypeId, enrolledAt: $enrolledAt, examTypeName: $examTypeName, examTypeSlug: $examTypeSlug, examGroupName: $examGroupName, examGroupSlug: $examGroupSlug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnrollmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.examTypeId, examTypeId) ||
                other.examTypeId == examTypeId) &&
            (identical(other.enrolledAt, enrolledAt) ||
                other.enrolledAt == enrolledAt) &&
            (identical(other.examTypeName, examTypeName) ||
                other.examTypeName == examTypeName) &&
            (identical(other.examTypeSlug, examTypeSlug) ||
                other.examTypeSlug == examTypeSlug) &&
            (identical(other.examGroupName, examGroupName) ||
                other.examGroupName == examGroupName) &&
            (identical(other.examGroupSlug, examGroupSlug) ||
                other.examGroupSlug == examGroupSlug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    examTypeId,
    enrolledAt,
    examTypeName,
    examTypeSlug,
    examGroupName,
    examGroupSlug,
  );

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnrollmentModelImplCopyWith<_$EnrollmentModelImpl> get copyWith =>
      __$$EnrollmentModelImplCopyWithImpl<_$EnrollmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EnrollmentModelImplToJson(this);
  }
}

abstract class _EnrollmentModel implements EnrollmentModel {
  const factory _EnrollmentModel({
    required final String id,
    @JsonKey(name: 'exam_type_id') required final String examTypeId,
    @JsonKey(name: 'enrolled_at') required final DateTime enrolledAt,
    @JsonKey(name: 'exam_type_name') required final String examTypeName,
    @JsonKey(name: 'exam_type_slug') required final String examTypeSlug,
    @JsonKey(name: 'exam_group_name') required final String examGroupName,
    @JsonKey(name: 'exam_group_slug') required final String examGroupSlug,
  }) = _$EnrollmentModelImpl;

  factory _EnrollmentModel.fromJson(Map<String, dynamic> json) =
      _$EnrollmentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'exam_type_id')
  String get examTypeId;
  @override
  @JsonKey(name: 'enrolled_at')
  DateTime get enrolledAt;
  @override
  @JsonKey(name: 'exam_type_name')
  String get examTypeName;
  @override
  @JsonKey(name: 'exam_type_slug')
  String get examTypeSlug;
  @override
  @JsonKey(name: 'exam_group_name')
  String get examGroupName;
  @override
  @JsonKey(name: 'exam_group_slug')
  String get examGroupSlug;

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnrollmentModelImplCopyWith<_$EnrollmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
