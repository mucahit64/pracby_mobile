// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExamGroupModel _$ExamGroupModelFromJson(Map<String, dynamic> json) {
  return _ExamGroupModel.fromJson(json);
}

/// @nodoc
mixin _$ExamGroupModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_types')
  List<ExamTypeModel> get examTypes => throw _privateConstructorUsedError;

  /// Serializes this ExamGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamGroupModelCopyWith<ExamGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamGroupModelCopyWith<$Res> {
  factory $ExamGroupModelCopyWith(
    ExamGroupModel value,
    $Res Function(ExamGroupModel) then,
  ) = _$ExamGroupModelCopyWithImpl<$Res, ExamGroupModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'exam_types') List<ExamTypeModel> examTypes,
  });
}

/// @nodoc
class _$ExamGroupModelCopyWithImpl<$Res, $Val extends ExamGroupModel>
    implements $ExamGroupModelCopyWith<$Res> {
  _$ExamGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? examTypes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            examTypes: null == examTypes
                ? _value.examTypes
                : examTypes // ignore: cast_nullable_to_non_nullable
                      as List<ExamTypeModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExamGroupModelImplCopyWith<$Res>
    implements $ExamGroupModelCopyWith<$Res> {
  factory _$$ExamGroupModelImplCopyWith(
    _$ExamGroupModelImpl value,
    $Res Function(_$ExamGroupModelImpl) then,
  ) = __$$ExamGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'exam_types') List<ExamTypeModel> examTypes,
  });
}

/// @nodoc
class __$$ExamGroupModelImplCopyWithImpl<$Res>
    extends _$ExamGroupModelCopyWithImpl<$Res, _$ExamGroupModelImpl>
    implements _$$ExamGroupModelImplCopyWith<$Res> {
  __$$ExamGroupModelImplCopyWithImpl(
    _$ExamGroupModelImpl _value,
    $Res Function(_$ExamGroupModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExamGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? examTypes = null,
  }) {
    return _then(
      _$ExamGroupModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        examTypes: null == examTypes
            ? _value._examTypes
            : examTypes // ignore: cast_nullable_to_non_nullable
                  as List<ExamTypeModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamGroupModelImpl implements _ExamGroupModel {
  const _$ExamGroupModelImpl({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'exam_types') final List<ExamTypeModel> examTypes = const [],
  }) : _examTypes = examTypes;

  factory _$ExamGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamGroupModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<ExamTypeModel> _examTypes;
  @override
  @JsonKey(name: 'exam_types')
  List<ExamTypeModel> get examTypes {
    if (_examTypes is EqualUnmodifiableListView) return _examTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examTypes);
  }

  @override
  String toString() {
    return 'ExamGroupModel(id: $id, name: $name, slug: $slug, description: $description, sortOrder: $sortOrder, isActive: $isActive, examTypes: $examTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._examTypes,
              _examTypes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    description,
    sortOrder,
    isActive,
    const DeepCollectionEquality().hash(_examTypes),
  );

  /// Create a copy of ExamGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamGroupModelImplCopyWith<_$ExamGroupModelImpl> get copyWith =>
      __$$ExamGroupModelImplCopyWithImpl<_$ExamGroupModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamGroupModelImplToJson(this);
  }
}

abstract class _ExamGroupModel implements ExamGroupModel {
  const factory _ExamGroupModel({
    required final String id,
    required final String name,
    required final String slug,
    final String? description,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'exam_types') final List<ExamTypeModel> examTypes,
  }) = _$ExamGroupModelImpl;

  factory _ExamGroupModel.fromJson(Map<String, dynamic> json) =
      _$ExamGroupModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'exam_types')
  List<ExamTypeModel> get examTypes;

  /// Create a copy of ExamGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamGroupModelImplCopyWith<_$ExamGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExamTypeModel _$ExamTypeModelFromJson(Map<String, dynamic> json) {
  return _ExamTypeModel.fromJson(json);
}

/// @nodoc
mixin _$ExamTypeModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ExamTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamTypeModelCopyWith<ExamTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamTypeModelCopyWith<$Res> {
  factory $ExamTypeModelCopyWith(
    ExamTypeModel value,
    $Res Function(ExamTypeModel) then,
  ) = _$ExamTypeModelCopyWithImpl<$Res, ExamTypeModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$ExamTypeModelCopyWithImpl<$Res, $Val extends ExamTypeModel>
    implements $ExamTypeModelCopyWith<$Res> {
  _$ExamTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExamTypeModelImplCopyWith<$Res>
    implements $ExamTypeModelCopyWith<$Res> {
  factory _$$ExamTypeModelImplCopyWith(
    _$ExamTypeModelImpl value,
    $Res Function(_$ExamTypeModelImpl) then,
  ) = __$$ExamTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$ExamTypeModelImplCopyWithImpl<$Res>
    extends _$ExamTypeModelCopyWithImpl<$Res, _$ExamTypeModelImpl>
    implements _$$ExamTypeModelImplCopyWith<$Res> {
  __$$ExamTypeModelImplCopyWithImpl(
    _$ExamTypeModelImpl _value,
    $Res Function(_$ExamTypeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExamTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(
      _$ExamTypeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamTypeModelImpl implements _ExamTypeModel {
  const _$ExamTypeModelImpl({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$ExamTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamTypeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ExamTypeModel(id: $id, name: $name, slug: $slug, description: $description, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    description,
    sortOrder,
    isActive,
  );

  /// Create a copy of ExamTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamTypeModelImplCopyWith<_$ExamTypeModelImpl> get copyWith =>
      __$$ExamTypeModelImplCopyWithImpl<_$ExamTypeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamTypeModelImplToJson(this);
  }
}

abstract class _ExamTypeModel implements ExamTypeModel {
  const factory _ExamTypeModel({
    required final String id,
    required final String name,
    required final String slug,
    final String? description,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$ExamTypeModelImpl;

  factory _ExamTypeModel.fromJson(Map<String, dynamic> json) =
      _$ExamTypeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of ExamTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamTypeModelImplCopyWith<_$ExamTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ModuleModel _$ModuleModelFromJson(Map<String, dynamic> json) {
  return _ModuleModel.fromJson(json);
}

/// @nodoc
mixin _$ModuleModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_type_id')
  String get examTypeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ModuleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleModelCopyWith<ModuleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleModelCopyWith<$Res> {
  factory $ModuleModelCopyWith(
    ModuleModel value,
    $Res Function(ModuleModel) then,
  ) = _$ModuleModelCopyWithImpl<$Res, ModuleModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exam_type_id') String examTypeId,
    String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$ModuleModelCopyWithImpl<$Res, $Val extends ModuleModel>
    implements $ModuleModelCopyWith<$Res> {
  _$ModuleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? examTypeId = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModuleModelImplCopyWith<$Res>
    implements $ModuleModelCopyWith<$Res> {
  factory _$$ModuleModelImplCopyWith(
    _$ModuleModelImpl value,
    $Res Function(_$ModuleModelImpl) then,
  ) = __$$ModuleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'exam_type_id') String examTypeId,
    String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$ModuleModelImplCopyWithImpl<$Res>
    extends _$ModuleModelCopyWithImpl<$Res, _$ModuleModelImpl>
    implements _$$ModuleModelImplCopyWith<$Res> {
  __$$ModuleModelImplCopyWithImpl(
    _$ModuleModelImpl _value,
    $Res Function(_$ModuleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? examTypeId = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(
      _$ModuleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        examTypeId: null == examTypeId
            ? _value.examTypeId
            : examTypeId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModuleModelImpl implements _ModuleModel {
  const _$ModuleModelImpl({
    required this.id,
    @JsonKey(name: 'exam_type_id') required this.examTypeId,
    required this.name,
    this.description,
    @JsonKey(name: 'icon_url') this.iconUrl,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$ModuleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModuleModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'exam_type_id')
  final String examTypeId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ModuleModel(id: $id, examTypeId: $examTypeId, name: $name, description: $description, iconUrl: $iconUrl, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.examTypeId, examTypeId) ||
                other.examTypeId == examTypeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    examTypeId,
    name,
    description,
    iconUrl,
    sortOrder,
    isActive,
  );

  /// Create a copy of ModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleModelImplCopyWith<_$ModuleModelImpl> get copyWith =>
      __$$ModuleModelImplCopyWithImpl<_$ModuleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModuleModelImplToJson(this);
  }
}

abstract class _ModuleModel implements ModuleModel {
  const factory _ModuleModel({
    required final String id,
    @JsonKey(name: 'exam_type_id') required final String examTypeId,
    required final String name,
    final String? description,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$ModuleModelImpl;

  factory _ModuleModel.fromJson(Map<String, dynamic> json) =
      _$ModuleModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'exam_type_id')
  String get examTypeId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of ModuleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleModelImplCopyWith<_$ModuleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return _CourseModel.fromJson(json);
}

/// @nodoc
mixin _$CourseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_type_id')
  String? get examTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'module_id')
  String? get moduleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  List<TopicModel> get topics => throw _privateConstructorUsedError;

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseModelCopyWith<CourseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseModelCopyWith<$Res> {
  factory $CourseModelCopyWith(
    CourseModel value,
    $Res Function(CourseModel) then,
  ) = _$CourseModelCopyWithImpl<$Res, CourseModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'name') String title,
    String? description,
    @JsonKey(name: 'icon_url') String? imageUrl,
    String? color,
    @JsonKey(name: 'exam_type_id') String? examTypeId,
    @JsonKey(name: 'module_id') String? moduleId,
    @JsonKey(name: 'sort_order') int sortOrder,
    List<TopicModel> topics,
  });
}

/// @nodoc
class _$CourseModelCopyWithImpl<$Res, $Val extends CourseModel>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? color = freezed,
    Object? examTypeId = freezed,
    Object? moduleId = freezed,
    Object? sortOrder = null,
    Object? topics = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            examTypeId: freezed == examTypeId
                ? _value.examTypeId
                : examTypeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            moduleId: freezed == moduleId
                ? _value.moduleId
                : moduleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            topics: null == topics
                ? _value.topics
                : topics // ignore: cast_nullable_to_non_nullable
                      as List<TopicModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseModelImplCopyWith<$Res>
    implements $CourseModelCopyWith<$Res> {
  factory _$$CourseModelImplCopyWith(
    _$CourseModelImpl value,
    $Res Function(_$CourseModelImpl) then,
  ) = __$$CourseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'name') String title,
    String? description,
    @JsonKey(name: 'icon_url') String? imageUrl,
    String? color,
    @JsonKey(name: 'exam_type_id') String? examTypeId,
    @JsonKey(name: 'module_id') String? moduleId,
    @JsonKey(name: 'sort_order') int sortOrder,
    List<TopicModel> topics,
  });
}

/// @nodoc
class __$$CourseModelImplCopyWithImpl<$Res>
    extends _$CourseModelCopyWithImpl<$Res, _$CourseModelImpl>
    implements _$$CourseModelImplCopyWith<$Res> {
  __$$CourseModelImplCopyWithImpl(
    _$CourseModelImpl _value,
    $Res Function(_$CourseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? color = freezed,
    Object? examTypeId = freezed,
    Object? moduleId = freezed,
    Object? sortOrder = null,
    Object? topics = null,
  }) {
    return _then(
      _$CourseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        examTypeId: freezed == examTypeId
            ? _value.examTypeId
            : examTypeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        moduleId: freezed == moduleId
            ? _value.moduleId
            : moduleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        topics: null == topics
            ? _value._topics
            : topics // ignore: cast_nullable_to_non_nullable
                  as List<TopicModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseModelImpl implements _CourseModel {
  const _$CourseModelImpl({
    required this.id,
    @JsonKey(name: 'name') required this.title,
    this.description,
    @JsonKey(name: 'icon_url') this.imageUrl,
    this.color,
    @JsonKey(name: 'exam_type_id') this.examTypeId,
    @JsonKey(name: 'module_id') this.moduleId,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    final List<TopicModel> topics = const [],
  }) : _topics = topics;

  factory _$CourseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'name')
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'icon_url')
  final String? imageUrl;
  @override
  final String? color;
  @override
  @JsonKey(name: 'exam_type_id')
  final String? examTypeId;
  @override
  @JsonKey(name: 'module_id')
  final String? moduleId;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  final List<TopicModel> _topics;
  @override
  @JsonKey()
  List<TopicModel> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  String toString() {
    return 'CourseModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, color: $color, examTypeId: $examTypeId, moduleId: $moduleId, sortOrder: $sortOrder, topics: $topics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.examTypeId, examTypeId) ||
                other.examTypeId == examTypeId) &&
            (identical(other.moduleId, moduleId) ||
                other.moduleId == moduleId) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._topics, _topics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    imageUrl,
    color,
    examTypeId,
    moduleId,
    sortOrder,
    const DeepCollectionEquality().hash(_topics),
  );

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      __$$CourseModelImplCopyWithImpl<_$CourseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseModelImplToJson(this);
  }
}

abstract class _CourseModel implements CourseModel {
  const factory _CourseModel({
    required final String id,
    @JsonKey(name: 'name') required final String title,
    final String? description,
    @JsonKey(name: 'icon_url') final String? imageUrl,
    final String? color,
    @JsonKey(name: 'exam_type_id') final String? examTypeId,
    @JsonKey(name: 'module_id') final String? moduleId,
    @JsonKey(name: 'sort_order') final int sortOrder,
    final List<TopicModel> topics,
  }) = _$CourseModelImpl;

  factory _CourseModel.fromJson(Map<String, dynamic> json) =
      _$CourseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'name')
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get imageUrl;
  @override
  String? get color;
  @override
  @JsonKey(name: 'exam_type_id')
  String? get examTypeId;
  @override
  @JsonKey(name: 'module_id')
  String? get moduleId;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  List<TopicModel> get topics;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) {
  return _TopicModel.fromJson(json);
}

/// @nodoc
mixin _$TopicModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String? get courseId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_lessons')
  int get totalLessons => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_crown_level')
  int get maxCrownLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlock_after')
  String? get unlockAfter => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<StepModel> get steps => throw _privateConstructorUsedError;
  UserTopicProgress? get progress => throw _privateConstructorUsedError;

  /// Serializes this TopicModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicModelCopyWith<TopicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicModelCopyWith<$Res> {
  factory $TopicModelCopyWith(
    TopicModel value,
    $Res Function(TopicModel) then,
  ) = _$TopicModelCopyWithImpl<$Res, TopicModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'name') String title,
    @JsonKey(name: 'sort_order') int order,
    @JsonKey(name: 'course_id') String? courseId,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'total_lessons') int totalLessons,
    @JsonKey(name: 'max_crown_level') int maxCrownLevel,
    @JsonKey(name: 'unlock_after') String? unlockAfter,
    String status,
    List<StepModel> steps,
    UserTopicProgress? progress,
  });

  $UserTopicProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class _$TopicModelCopyWithImpl<$Res, $Val extends TopicModel>
    implements $TopicModelCopyWith<$Res> {
  _$TopicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? order = null,
    Object? courseId = freezed,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? totalLessons = null,
    Object? maxCrownLevel = null,
    Object? unlockAfter = freezed,
    Object? status = null,
    Object? steps = null,
    Object? progress = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            courseId: freezed == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalLessons: null == totalLessons
                ? _value.totalLessons
                : totalLessons // ignore: cast_nullable_to_non_nullable
                      as int,
            maxCrownLevel: null == maxCrownLevel
                ? _value.maxCrownLevel
                : maxCrownLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            unlockAfter: freezed == unlockAfter
                ? _value.unlockAfter
                : unlockAfter // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<StepModel>,
            progress: freezed == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as UserTopicProgress?,
          )
          as $Val,
    );
  }

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserTopicProgressCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $UserTopicProgressCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TopicModelImplCopyWith<$Res>
    implements $TopicModelCopyWith<$Res> {
  factory _$$TopicModelImplCopyWith(
    _$TopicModelImpl value,
    $Res Function(_$TopicModelImpl) then,
  ) = __$$TopicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'name') String title,
    @JsonKey(name: 'sort_order') int order,
    @JsonKey(name: 'course_id') String? courseId,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'total_lessons') int totalLessons,
    @JsonKey(name: 'max_crown_level') int maxCrownLevel,
    @JsonKey(name: 'unlock_after') String? unlockAfter,
    String status,
    List<StepModel> steps,
    UserTopicProgress? progress,
  });

  @override
  $UserTopicProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$TopicModelImplCopyWithImpl<$Res>
    extends _$TopicModelCopyWithImpl<$Res, _$TopicModelImpl>
    implements _$$TopicModelImplCopyWith<$Res> {
  __$$TopicModelImplCopyWithImpl(
    _$TopicModelImpl _value,
    $Res Function(_$TopicModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? order = null,
    Object? courseId = freezed,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? totalLessons = null,
    Object? maxCrownLevel = null,
    Object? unlockAfter = freezed,
    Object? status = null,
    Object? steps = null,
    Object? progress = freezed,
  }) {
    return _then(
      _$TopicModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        courseId: freezed == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalLessons: null == totalLessons
            ? _value.totalLessons
            : totalLessons // ignore: cast_nullable_to_non_nullable
                  as int,
        maxCrownLevel: null == maxCrownLevel
            ? _value.maxCrownLevel
            : maxCrownLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        unlockAfter: freezed == unlockAfter
            ? _value.unlockAfter
            : unlockAfter // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<StepModel>,
        progress: freezed == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as UserTopicProgress?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicModelImpl implements _TopicModel {
  const _$TopicModelImpl({
    required this.id,
    @JsonKey(name: 'name') required this.title,
    @JsonKey(name: 'sort_order') required this.order,
    @JsonKey(name: 'course_id') this.courseId,
    this.description,
    @JsonKey(name: 'icon_url') this.iconUrl,
    @JsonKey(name: 'total_lessons') this.totalLessons = 0,
    @JsonKey(name: 'max_crown_level') this.maxCrownLevel = 5,
    @JsonKey(name: 'unlock_after') this.unlockAfter,
    this.status = 'approved',
    final List<StepModel> steps = const [],
    this.progress,
  }) : _steps = steps;

  factory _$TopicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'name')
  final String title;
  @override
  @JsonKey(name: 'sort_order')
  final int order;
  @override
  @JsonKey(name: 'course_id')
  final String? courseId;
  @override
  final String? description;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'total_lessons')
  final int totalLessons;
  @override
  @JsonKey(name: 'max_crown_level')
  final int maxCrownLevel;
  @override
  @JsonKey(name: 'unlock_after')
  final String? unlockAfter;
  @override
  @JsonKey()
  final String status;
  final List<StepModel> _steps;
  @override
  @JsonKey()
  List<StepModel> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final UserTopicProgress? progress;

  @override
  String toString() {
    return 'TopicModel(id: $id, title: $title, order: $order, courseId: $courseId, description: $description, iconUrl: $iconUrl, totalLessons: $totalLessons, maxCrownLevel: $maxCrownLevel, unlockAfter: $unlockAfter, status: $status, steps: $steps, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.totalLessons, totalLessons) ||
                other.totalLessons == totalLessons) &&
            (identical(other.maxCrownLevel, maxCrownLevel) ||
                other.maxCrownLevel == maxCrownLevel) &&
            (identical(other.unlockAfter, unlockAfter) ||
                other.unlockAfter == unlockAfter) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    order,
    courseId,
    description,
    iconUrl,
    totalLessons,
    maxCrownLevel,
    unlockAfter,
    status,
    const DeepCollectionEquality().hash(_steps),
    progress,
  );

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicModelImplCopyWith<_$TopicModelImpl> get copyWith =>
      __$$TopicModelImplCopyWithImpl<_$TopicModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicModelImplToJson(this);
  }
}

abstract class _TopicModel implements TopicModel {
  const factory _TopicModel({
    required final String id,
    @JsonKey(name: 'name') required final String title,
    @JsonKey(name: 'sort_order') required final int order,
    @JsonKey(name: 'course_id') final String? courseId,
    final String? description,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    @JsonKey(name: 'total_lessons') final int totalLessons,
    @JsonKey(name: 'max_crown_level') final int maxCrownLevel,
    @JsonKey(name: 'unlock_after') final String? unlockAfter,
    final String status,
    final List<StepModel> steps,
    final UserTopicProgress? progress,
  }) = _$TopicModelImpl;

  factory _TopicModel.fromJson(Map<String, dynamic> json) =
      _$TopicModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'name')
  String get title;
  @override
  @JsonKey(name: 'sort_order')
  int get order;
  @override
  @JsonKey(name: 'course_id')
  String? get courseId;
  @override
  String? get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'total_lessons')
  int get totalLessons;
  @override
  @JsonKey(name: 'max_crown_level')
  int get maxCrownLevel;
  @override
  @JsonKey(name: 'unlock_after')
  String? get unlockAfter;
  @override
  String get status;
  @override
  List<StepModel> get steps;
  @override
  UserTopicProgress? get progress;

  /// Create a copy of TopicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicModelImplCopyWith<_$TopicModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StepModel _$StepModelFromJson(Map<String, dynamic> json) {
  return _StepModel.fromJson(json);
}

/// @nodoc
mixin _$StepModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_type')
  StepType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'topic_id')
  String? get topicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'tests_required')
  int get testsRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'reward_type')
  String? get rewardType => throw _privateConstructorUsedError;
  @JsonKey(name: 'reward_amount')
  int? get rewardAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reward_item_id')
  String? get rewardItemId => throw _privateConstructorUsedError;
  UserStepProgress? get progress => throw _privateConstructorUsedError;

  /// Serializes this StepModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StepModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StepModelCopyWith<StepModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StepModelCopyWith<$Res> {
  factory $StepModelCopyWith(StepModel value, $Res Function(StepModel) then) =
      _$StepModelCopyWithImpl<$Res, StepModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sort_order') int order,
    @JsonKey(name: 'step_type') StepType type,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'name') String title,
    String? description,
    @JsonKey(name: 'tests_required') int testsRequired,
    @JsonKey(name: 'reward_type') String? rewardType,
    @JsonKey(name: 'reward_amount') int? rewardAmount,
    @JsonKey(name: 'reward_item_id') String? rewardItemId,
    UserStepProgress? progress,
  });

  $UserStepProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class _$StepModelCopyWithImpl<$Res, $Val extends StepModel>
    implements $StepModelCopyWith<$Res> {
  _$StepModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StepModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? type = null,
    Object? topicId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? testsRequired = null,
    Object? rewardType = freezed,
    Object? rewardAmount = freezed,
    Object? rewardItemId = freezed,
    Object? progress = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as StepType,
            topicId: freezed == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            testsRequired: null == testsRequired
                ? _value.testsRequired
                : testsRequired // ignore: cast_nullable_to_non_nullable
                      as int,
            rewardType: freezed == rewardType
                ? _value.rewardType
                : rewardType // ignore: cast_nullable_to_non_nullable
                      as String?,
            rewardAmount: freezed == rewardAmount
                ? _value.rewardAmount
                : rewardAmount // ignore: cast_nullable_to_non_nullable
                      as int?,
            rewardItemId: freezed == rewardItemId
                ? _value.rewardItemId
                : rewardItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            progress: freezed == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as UserStepProgress?,
          )
          as $Val,
    );
  }

  /// Create a copy of StepModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStepProgressCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $UserStepProgressCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StepModelImplCopyWith<$Res>
    implements $StepModelCopyWith<$Res> {
  factory _$$StepModelImplCopyWith(
    _$StepModelImpl value,
    $Res Function(_$StepModelImpl) then,
  ) = __$$StepModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'sort_order') int order,
    @JsonKey(name: 'step_type') StepType type,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'name') String title,
    String? description,
    @JsonKey(name: 'tests_required') int testsRequired,
    @JsonKey(name: 'reward_type') String? rewardType,
    @JsonKey(name: 'reward_amount') int? rewardAmount,
    @JsonKey(name: 'reward_item_id') String? rewardItemId,
    UserStepProgress? progress,
  });

  @override
  $UserStepProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$StepModelImplCopyWithImpl<$Res>
    extends _$StepModelCopyWithImpl<$Res, _$StepModelImpl>
    implements _$$StepModelImplCopyWith<$Res> {
  __$$StepModelImplCopyWithImpl(
    _$StepModelImpl _value,
    $Res Function(_$StepModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StepModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? type = null,
    Object? topicId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? testsRequired = null,
    Object? rewardType = freezed,
    Object? rewardAmount = freezed,
    Object? rewardItemId = freezed,
    Object? progress = freezed,
  }) {
    return _then(
      _$StepModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as StepType,
        topicId: freezed == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        testsRequired: null == testsRequired
            ? _value.testsRequired
            : testsRequired // ignore: cast_nullable_to_non_nullable
                  as int,
        rewardType: freezed == rewardType
            ? _value.rewardType
            : rewardType // ignore: cast_nullable_to_non_nullable
                  as String?,
        rewardAmount: freezed == rewardAmount
            ? _value.rewardAmount
            : rewardAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        rewardItemId: freezed == rewardItemId
            ? _value.rewardItemId
            : rewardItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        progress: freezed == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as UserStepProgress?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StepModelImpl implements _StepModel {
  const _$StepModelImpl({
    required this.id,
    @JsonKey(name: 'sort_order') required this.order,
    @JsonKey(name: 'step_type') required this.type,
    @JsonKey(name: 'topic_id') this.topicId,
    @JsonKey(name: 'name') this.title = '',
    this.description,
    @JsonKey(name: 'tests_required') this.testsRequired = 5,
    @JsonKey(name: 'reward_type') this.rewardType,
    @JsonKey(name: 'reward_amount') this.rewardAmount,
    @JsonKey(name: 'reward_item_id') this.rewardItemId,
    this.progress,
  });

  factory _$StepModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StepModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'sort_order')
  final int order;
  @override
  @JsonKey(name: 'step_type')
  final StepType type;
  @override
  @JsonKey(name: 'topic_id')
  final String? topicId;
  @override
  @JsonKey(name: 'name')
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'tests_required')
  final int testsRequired;
  @override
  @JsonKey(name: 'reward_type')
  final String? rewardType;
  @override
  @JsonKey(name: 'reward_amount')
  final int? rewardAmount;
  @override
  @JsonKey(name: 'reward_item_id')
  final String? rewardItemId;
  @override
  final UserStepProgress? progress;

  @override
  String toString() {
    return 'StepModel(id: $id, order: $order, type: $type, topicId: $topicId, title: $title, description: $description, testsRequired: $testsRequired, rewardType: $rewardType, rewardAmount: $rewardAmount, rewardItemId: $rewardItemId, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StepModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.testsRequired, testsRequired) ||
                other.testsRequired == testsRequired) &&
            (identical(other.rewardType, rewardType) ||
                other.rewardType == rewardType) &&
            (identical(other.rewardAmount, rewardAmount) ||
                other.rewardAmount == rewardAmount) &&
            (identical(other.rewardItemId, rewardItemId) ||
                other.rewardItemId == rewardItemId) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    order,
    type,
    topicId,
    title,
    description,
    testsRequired,
    rewardType,
    rewardAmount,
    rewardItemId,
    progress,
  );

  /// Create a copy of StepModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StepModelImplCopyWith<_$StepModelImpl> get copyWith =>
      __$$StepModelImplCopyWithImpl<_$StepModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StepModelImplToJson(this);
  }
}

abstract class _StepModel implements StepModel {
  const factory _StepModel({
    required final String id,
    @JsonKey(name: 'sort_order') required final int order,
    @JsonKey(name: 'step_type') required final StepType type,
    @JsonKey(name: 'topic_id') final String? topicId,
    @JsonKey(name: 'name') final String title,
    final String? description,
    @JsonKey(name: 'tests_required') final int testsRequired,
    @JsonKey(name: 'reward_type') final String? rewardType,
    @JsonKey(name: 'reward_amount') final int? rewardAmount,
    @JsonKey(name: 'reward_item_id') final String? rewardItemId,
    final UserStepProgress? progress,
  }) = _$StepModelImpl;

  factory _StepModel.fromJson(Map<String, dynamic> json) =
      _$StepModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'sort_order')
  int get order;
  @override
  @JsonKey(name: 'step_type')
  StepType get type;
  @override
  @JsonKey(name: 'topic_id')
  String? get topicId;
  @override
  @JsonKey(name: 'name')
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'tests_required')
  int get testsRequired;
  @override
  @JsonKey(name: 'reward_type')
  String? get rewardType;
  @override
  @JsonKey(name: 'reward_amount')
  int? get rewardAmount;
  @override
  @JsonKey(name: 'reward_item_id')
  String? get rewardItemId;
  @override
  UserStepProgress? get progress;

  /// Create a copy of StepModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StepModelImplCopyWith<_$StepModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserTopicProgress _$UserTopicProgressFromJson(Map<String, dynamic> json) {
  return _UserTopicProgress.fromJson(json);
}

/// @nodoc
mixin _$UserTopicProgress {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'topic_id')
  String get topicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'crown_level')
  int get crownLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'lessons_completed')
  int get lessonsCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_unlocked')
  bool get isUnlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_practiced_at')
  DateTime? get lastPracticedAt => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_review_at')
  DateTime? get nextReviewAt => throw _privateConstructorUsedError;

  /// The topic final (the boss on the map): best score and first finish.
  @JsonKey(name: 'final_best_score')
  int get finalBestScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_completed_at')
  DateTime? get finalCompletedAt => throw _privateConstructorUsedError;

  /// Serializes this UserTopicProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserTopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserTopicProgressCopyWith<UserTopicProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserTopicProgressCopyWith<$Res> {
  factory $UserTopicProgressCopyWith(
    UserTopicProgress value,
    $Res Function(UserTopicProgress) then,
  ) = _$UserTopicProgressCopyWithImpl<$Res, UserTopicProgress>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'topic_id') String topicId,
    @JsonKey(name: 'crown_level') int crownLevel,
    @JsonKey(name: 'lessons_completed') int lessonsCompleted,
    @JsonKey(name: 'is_unlocked') bool isUnlocked,
    @JsonKey(name: 'last_practiced_at') DateTime? lastPracticedAt,
    double strength,
    @JsonKey(name: 'next_review_at') DateTime? nextReviewAt,
    @JsonKey(name: 'final_best_score') int finalBestScore,
    @JsonKey(name: 'final_completed_at') DateTime? finalCompletedAt,
  });
}

/// @nodoc
class _$UserTopicProgressCopyWithImpl<$Res, $Val extends UserTopicProgress>
    implements $UserTopicProgressCopyWith<$Res> {
  _$UserTopicProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserTopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topicId = null,
    Object? crownLevel = null,
    Object? lessonsCompleted = null,
    Object? isUnlocked = null,
    Object? lastPracticedAt = freezed,
    Object? strength = null,
    Object? nextReviewAt = freezed,
    Object? finalBestScore = null,
    Object? finalCompletedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            topicId: null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String,
            crownLevel: null == crownLevel
                ? _value.crownLevel
                : crownLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            lessonsCompleted: null == lessonsCompleted
                ? _value.lessonsCompleted
                : lessonsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            isUnlocked: null == isUnlocked
                ? _value.isUnlocked
                : isUnlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastPracticedAt: freezed == lastPracticedAt
                ? _value.lastPracticedAt
                : lastPracticedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            strength: null == strength
                ? _value.strength
                : strength // ignore: cast_nullable_to_non_nullable
                      as double,
            nextReviewAt: freezed == nextReviewAt
                ? _value.nextReviewAt
                : nextReviewAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            finalBestScore: null == finalBestScore
                ? _value.finalBestScore
                : finalBestScore // ignore: cast_nullable_to_non_nullable
                      as int,
            finalCompletedAt: freezed == finalCompletedAt
                ? _value.finalCompletedAt
                : finalCompletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserTopicProgressImplCopyWith<$Res>
    implements $UserTopicProgressCopyWith<$Res> {
  factory _$$UserTopicProgressImplCopyWith(
    _$UserTopicProgressImpl value,
    $Res Function(_$UserTopicProgressImpl) then,
  ) = __$$UserTopicProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'topic_id') String topicId,
    @JsonKey(name: 'crown_level') int crownLevel,
    @JsonKey(name: 'lessons_completed') int lessonsCompleted,
    @JsonKey(name: 'is_unlocked') bool isUnlocked,
    @JsonKey(name: 'last_practiced_at') DateTime? lastPracticedAt,
    double strength,
    @JsonKey(name: 'next_review_at') DateTime? nextReviewAt,
    @JsonKey(name: 'final_best_score') int finalBestScore,
    @JsonKey(name: 'final_completed_at') DateTime? finalCompletedAt,
  });
}

/// @nodoc
class __$$UserTopicProgressImplCopyWithImpl<$Res>
    extends _$UserTopicProgressCopyWithImpl<$Res, _$UserTopicProgressImpl>
    implements _$$UserTopicProgressImplCopyWith<$Res> {
  __$$UserTopicProgressImplCopyWithImpl(
    _$UserTopicProgressImpl _value,
    $Res Function(_$UserTopicProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserTopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topicId = null,
    Object? crownLevel = null,
    Object? lessonsCompleted = null,
    Object? isUnlocked = null,
    Object? lastPracticedAt = freezed,
    Object? strength = null,
    Object? nextReviewAt = freezed,
    Object? finalBestScore = null,
    Object? finalCompletedAt = freezed,
  }) {
    return _then(
      _$UserTopicProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        topicId: null == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String,
        crownLevel: null == crownLevel
            ? _value.crownLevel
            : crownLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        lessonsCompleted: null == lessonsCompleted
            ? _value.lessonsCompleted
            : lessonsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        isUnlocked: null == isUnlocked
            ? _value.isUnlocked
            : isUnlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastPracticedAt: freezed == lastPracticedAt
            ? _value.lastPracticedAt
            : lastPracticedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        strength: null == strength
            ? _value.strength
            : strength // ignore: cast_nullable_to_non_nullable
                  as double,
        nextReviewAt: freezed == nextReviewAt
            ? _value.nextReviewAt
            : nextReviewAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        finalBestScore: null == finalBestScore
            ? _value.finalBestScore
            : finalBestScore // ignore: cast_nullable_to_non_nullable
                  as int,
        finalCompletedAt: freezed == finalCompletedAt
            ? _value.finalCompletedAt
            : finalCompletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserTopicProgressImpl implements _UserTopicProgress {
  const _$UserTopicProgressImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'topic_id') required this.topicId,
    @JsonKey(name: 'crown_level') this.crownLevel = 0,
    @JsonKey(name: 'lessons_completed') this.lessonsCompleted = 0,
    @JsonKey(name: 'is_unlocked') this.isUnlocked = false,
    @JsonKey(name: 'last_practiced_at') this.lastPracticedAt,
    this.strength = 0.0,
    @JsonKey(name: 'next_review_at') this.nextReviewAt,
    @JsonKey(name: 'final_best_score') this.finalBestScore = 0,
    @JsonKey(name: 'final_completed_at') this.finalCompletedAt,
  });

  factory _$UserTopicProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserTopicProgressImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'topic_id')
  final String topicId;
  @override
  @JsonKey(name: 'crown_level')
  final int crownLevel;
  @override
  @JsonKey(name: 'lessons_completed')
  final int lessonsCompleted;
  @override
  @JsonKey(name: 'is_unlocked')
  final bool isUnlocked;
  @override
  @JsonKey(name: 'last_practiced_at')
  final DateTime? lastPracticedAt;
  @override
  @JsonKey()
  final double strength;
  @override
  @JsonKey(name: 'next_review_at')
  final DateTime? nextReviewAt;

  /// The topic final (the boss on the map): best score and first finish.
  @override
  @JsonKey(name: 'final_best_score')
  final int finalBestScore;
  @override
  @JsonKey(name: 'final_completed_at')
  final DateTime? finalCompletedAt;

  @override
  String toString() {
    return 'UserTopicProgress(id: $id, userId: $userId, topicId: $topicId, crownLevel: $crownLevel, lessonsCompleted: $lessonsCompleted, isUnlocked: $isUnlocked, lastPracticedAt: $lastPracticedAt, strength: $strength, nextReviewAt: $nextReviewAt, finalBestScore: $finalBestScore, finalCompletedAt: $finalCompletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserTopicProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.crownLevel, crownLevel) ||
                other.crownLevel == crownLevel) &&
            (identical(other.lessonsCompleted, lessonsCompleted) ||
                other.lessonsCompleted == lessonsCompleted) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.lastPracticedAt, lastPracticedAt) ||
                other.lastPracticedAt == lastPracticedAt) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.nextReviewAt, nextReviewAt) ||
                other.nextReviewAt == nextReviewAt) &&
            (identical(other.finalBestScore, finalBestScore) ||
                other.finalBestScore == finalBestScore) &&
            (identical(other.finalCompletedAt, finalCompletedAt) ||
                other.finalCompletedAt == finalCompletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    topicId,
    crownLevel,
    lessonsCompleted,
    isUnlocked,
    lastPracticedAt,
    strength,
    nextReviewAt,
    finalBestScore,
    finalCompletedAt,
  );

  /// Create a copy of UserTopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserTopicProgressImplCopyWith<_$UserTopicProgressImpl> get copyWith =>
      __$$UserTopicProgressImplCopyWithImpl<_$UserTopicProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserTopicProgressImplToJson(this);
  }
}

abstract class _UserTopicProgress implements UserTopicProgress {
  const factory _UserTopicProgress({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'topic_id') required final String topicId,
    @JsonKey(name: 'crown_level') final int crownLevel,
    @JsonKey(name: 'lessons_completed') final int lessonsCompleted,
    @JsonKey(name: 'is_unlocked') final bool isUnlocked,
    @JsonKey(name: 'last_practiced_at') final DateTime? lastPracticedAt,
    final double strength,
    @JsonKey(name: 'next_review_at') final DateTime? nextReviewAt,
    @JsonKey(name: 'final_best_score') final int finalBestScore,
    @JsonKey(name: 'final_completed_at') final DateTime? finalCompletedAt,
  }) = _$UserTopicProgressImpl;

  factory _UserTopicProgress.fromJson(Map<String, dynamic> json) =
      _$UserTopicProgressImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'topic_id')
  String get topicId;
  @override
  @JsonKey(name: 'crown_level')
  int get crownLevel;
  @override
  @JsonKey(name: 'lessons_completed')
  int get lessonsCompleted;
  @override
  @JsonKey(name: 'is_unlocked')
  bool get isUnlocked;
  @override
  @JsonKey(name: 'last_practiced_at')
  DateTime? get lastPracticedAt;
  @override
  double get strength;
  @override
  @JsonKey(name: 'next_review_at')
  DateTime? get nextReviewAt;

  /// The topic final (the boss on the map): best score and first finish.
  @override
  @JsonKey(name: 'final_best_score')
  int get finalBestScore;
  @override
  @JsonKey(name: 'final_completed_at')
  DateTime? get finalCompletedAt;

  /// Create a copy of UserTopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserTopicProgressImplCopyWith<_$UserTopicProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStepProgress _$UserStepProgressFromJson(Map<String, dynamic> json) {
  return _UserStepProgress.fromJson(json);
}

/// @nodoc
mixin _$UserStepProgress {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_id')
  String get stepId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tests_completed')
  int get testsCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_step_completed')
  bool get isStepCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'step_final_passed')
  bool get stepFinalPassed => throw _privateConstructorUsedError;
  int get stars => throw _privateConstructorUsedError;

  /// Best accuracy (0-100) — shown on completed lesson nodes (docs 6.4).
  @JsonKey(name: 'best_score')
  int get bestScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this UserStepProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStepProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStepProgressCopyWith<UserStepProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStepProgressCopyWith<$Res> {
  factory $UserStepProgressCopyWith(
    UserStepProgress value,
    $Res Function(UserStepProgress) then,
  ) = _$UserStepProgressCopyWithImpl<$Res, UserStepProgress>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'step_id') String stepId,
    @JsonKey(name: 'tests_completed') int testsCompleted,
    @JsonKey(name: 'is_step_completed') bool isStepCompleted,
    @JsonKey(name: 'step_final_passed') bool stepFinalPassed,
    int stars,
    @JsonKey(name: 'best_score') int bestScore,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  });
}

/// @nodoc
class _$UserStepProgressCopyWithImpl<$Res, $Val extends UserStepProgress>
    implements $UserStepProgressCopyWith<$Res> {
  _$UserStepProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStepProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? stepId = null,
    Object? testsCompleted = null,
    Object? isStepCompleted = null,
    Object? stepFinalPassed = null,
    Object? stars = null,
    Object? bestScore = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            stepId: null == stepId
                ? _value.stepId
                : stepId // ignore: cast_nullable_to_non_nullable
                      as String,
            testsCompleted: null == testsCompleted
                ? _value.testsCompleted
                : testsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            isStepCompleted: null == isStepCompleted
                ? _value.isStepCompleted
                : isStepCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            stepFinalPassed: null == stepFinalPassed
                ? _value.stepFinalPassed
                : stepFinalPassed // ignore: cast_nullable_to_non_nullable
                      as bool,
            stars: null == stars
                ? _value.stars
                : stars // ignore: cast_nullable_to_non_nullable
                      as int,
            bestScore: null == bestScore
                ? _value.bestScore
                : bestScore // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStepProgressImplCopyWith<$Res>
    implements $UserStepProgressCopyWith<$Res> {
  factory _$$UserStepProgressImplCopyWith(
    _$UserStepProgressImpl value,
    $Res Function(_$UserStepProgressImpl) then,
  ) = __$$UserStepProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'step_id') String stepId,
    @JsonKey(name: 'tests_completed') int testsCompleted,
    @JsonKey(name: 'is_step_completed') bool isStepCompleted,
    @JsonKey(name: 'step_final_passed') bool stepFinalPassed,
    int stars,
    @JsonKey(name: 'best_score') int bestScore,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  });
}

/// @nodoc
class __$$UserStepProgressImplCopyWithImpl<$Res>
    extends _$UserStepProgressCopyWithImpl<$Res, _$UserStepProgressImpl>
    implements _$$UserStepProgressImplCopyWith<$Res> {
  __$$UserStepProgressImplCopyWithImpl(
    _$UserStepProgressImpl _value,
    $Res Function(_$UserStepProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStepProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? stepId = null,
    Object? testsCompleted = null,
    Object? isStepCompleted = null,
    Object? stepFinalPassed = null,
    Object? stars = null,
    Object? bestScore = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$UserStepProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        stepId: null == stepId
            ? _value.stepId
            : stepId // ignore: cast_nullable_to_non_nullable
                  as String,
        testsCompleted: null == testsCompleted
            ? _value.testsCompleted
            : testsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        isStepCompleted: null == isStepCompleted
            ? _value.isStepCompleted
            : isStepCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        stepFinalPassed: null == stepFinalPassed
            ? _value.stepFinalPassed
            : stepFinalPassed // ignore: cast_nullable_to_non_nullable
                  as bool,
        stars: null == stars
            ? _value.stars
            : stars // ignore: cast_nullable_to_non_nullable
                  as int,
        bestScore: null == bestScore
            ? _value.bestScore
            : bestScore // ignore: cast_nullable_to_non_nullable
                  as int,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStepProgressImpl implements _UserStepProgress {
  const _$UserStepProgressImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'step_id') required this.stepId,
    @JsonKey(name: 'tests_completed') this.testsCompleted = 0,
    @JsonKey(name: 'is_step_completed') this.isStepCompleted = false,
    @JsonKey(name: 'step_final_passed') this.stepFinalPassed = false,
    this.stars = 0,
    @JsonKey(name: 'best_score') this.bestScore = 0,
    @JsonKey(name: 'completed_at') this.completedAt,
  });

  factory _$UserStepProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStepProgressImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'step_id')
  final String stepId;
  @override
  @JsonKey(name: 'tests_completed')
  final int testsCompleted;
  @override
  @JsonKey(name: 'is_step_completed')
  final bool isStepCompleted;
  @override
  @JsonKey(name: 'step_final_passed')
  final bool stepFinalPassed;
  @override
  @JsonKey()
  final int stars;

  /// Best accuracy (0-100) — shown on completed lesson nodes (docs 6.4).
  @override
  @JsonKey(name: 'best_score')
  final int bestScore;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'UserStepProgress(id: $id, userId: $userId, stepId: $stepId, testsCompleted: $testsCompleted, isStepCompleted: $isStepCompleted, stepFinalPassed: $stepFinalPassed, stars: $stars, bestScore: $bestScore, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStepProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.stepId, stepId) || other.stepId == stepId) &&
            (identical(other.testsCompleted, testsCompleted) ||
                other.testsCompleted == testsCompleted) &&
            (identical(other.isStepCompleted, isStepCompleted) ||
                other.isStepCompleted == isStepCompleted) &&
            (identical(other.stepFinalPassed, stepFinalPassed) ||
                other.stepFinalPassed == stepFinalPassed) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.bestScore, bestScore) ||
                other.bestScore == bestScore) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    stepId,
    testsCompleted,
    isStepCompleted,
    stepFinalPassed,
    stars,
    bestScore,
    completedAt,
  );

  /// Create a copy of UserStepProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStepProgressImplCopyWith<_$UserStepProgressImpl> get copyWith =>
      __$$UserStepProgressImplCopyWithImpl<_$UserStepProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStepProgressImplToJson(this);
  }
}

abstract class _UserStepProgress implements UserStepProgress {
  const factory _UserStepProgress({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'step_id') required final String stepId,
    @JsonKey(name: 'tests_completed') final int testsCompleted,
    @JsonKey(name: 'is_step_completed') final bool isStepCompleted,
    @JsonKey(name: 'step_final_passed') final bool stepFinalPassed,
    final int stars,
    @JsonKey(name: 'best_score') final int bestScore,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
  }) = _$UserStepProgressImpl;

  factory _UserStepProgress.fromJson(Map<String, dynamic> json) =
      _$UserStepProgressImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'step_id')
  String get stepId;
  @override
  @JsonKey(name: 'tests_completed')
  int get testsCompleted;
  @override
  @JsonKey(name: 'is_step_completed')
  bool get isStepCompleted;
  @override
  @JsonKey(name: 'step_final_passed')
  bool get stepFinalPassed;
  @override
  int get stars;

  /// Best accuracy (0-100) — shown on completed lesson nodes (docs 6.4).
  @override
  @JsonKey(name: 'best_score')
  int get bestScore;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;

  /// Create a copy of UserStepProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStepProgressImplCopyWith<_$UserStepProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
