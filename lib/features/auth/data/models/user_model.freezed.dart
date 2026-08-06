// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_goal_xp')
  int get dailyGoalXp => throw _privateConstructorUsedError;
  int get energy => throw _privateConstructorUsedError;
  @JsonKey(name: 'energy_refreshed_at')
  DateTime? get energyRefreshedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_energy_at')
  DateTime? get nextEnergyAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'acorn_balance')
  int get acorns => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_exam_type_id')
  String? get activeExamId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String email,
    String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'daily_goal_xp') int dailyGoalXp,
    int energy,
    @JsonKey(name: 'energy_refreshed_at') DateTime? energyRefreshedAt,
    @JsonKey(name: 'next_energy_at') DateTime? nextEnergyAt,
    @JsonKey(name: 'acorn_balance') int acorns,
    @JsonKey(name: 'active_exam_type_id') String? activeExamId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? role,
    List<String> permissions,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? dailyGoalXp = null,
    Object? energy = null,
    Object? energyRefreshedAt = freezed,
    Object? nextEnergyAt = freezed,
    Object? acorns = null,
    Object? activeExamId = freezed,
    Object? createdAt = freezed,
    Object? role = freezed,
    Object? permissions = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            dailyGoalXp: null == dailyGoalXp
                ? _value.dailyGoalXp
                : dailyGoalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            energy: null == energy
                ? _value.energy
                : energy // ignore: cast_nullable_to_non_nullable
                      as int,
            energyRefreshedAt: freezed == energyRefreshedAt
                ? _value.energyRefreshedAt
                : energyRefreshedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            nextEnergyAt: freezed == nextEnergyAt
                ? _value.nextEnergyAt
                : nextEnergyAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            acorns: null == acorns
                ? _value.acorns
                : acorns // ignore: cast_nullable_to_non_nullable
                      as int,
            activeExamId: freezed == activeExamId
                ? _value.activeExamId
                : activeExamId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'daily_goal_xp') int dailyGoalXp,
    int energy,
    @JsonKey(name: 'energy_refreshed_at') DateTime? energyRefreshedAt,
    @JsonKey(name: 'next_energy_at') DateTime? nextEnergyAt,
    @JsonKey(name: 'acorn_balance') int acorns,
    @JsonKey(name: 'active_exam_type_id') String? activeExamId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? role,
    List<String> permissions,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? dailyGoalXp = null,
    Object? energy = null,
    Object? energyRefreshedAt = freezed,
    Object? nextEnergyAt = freezed,
    Object? acorns = null,
    Object? activeExamId = freezed,
    Object? createdAt = freezed,
    Object? role = freezed,
    Object? permissions = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        dailyGoalXp: null == dailyGoalXp
            ? _value.dailyGoalXp
            : dailyGoalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        energy: null == energy
            ? _value.energy
            : energy // ignore: cast_nullable_to_non_nullable
                  as int,
        energyRefreshedAt: freezed == energyRefreshedAt
            ? _value.energyRefreshedAt
            : energyRefreshedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        nextEnergyAt: freezed == nextEnergyAt
            ? _value.nextEnergyAt
            : nextEnergyAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        acorns: null == acorns
            ? _value.acorns
            : acorns // ignore: cast_nullable_to_non_nullable
                  as int,
        activeExamId: freezed == activeExamId
            ? _value.activeExamId
            : activeExamId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.email,
    required this.username,
    @JsonKey(name: 'avatar_url') this.avatarUrl,
    @JsonKey(name: 'daily_goal_xp') this.dailyGoalXp = 50,
    this.energy = 25,
    @JsonKey(name: 'energy_refreshed_at') this.energyRefreshedAt,
    @JsonKey(name: 'next_energy_at') this.nextEnergyAt,
    @JsonKey(name: 'acorn_balance') this.acorns = 0,
    @JsonKey(name: 'active_exam_type_id') this.activeExamId,
    @JsonKey(name: 'created_at') this.createdAt,
    this.role,
    final List<String> permissions = const [],
  }) : _permissions = permissions;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'daily_goal_xp')
  final int dailyGoalXp;
  @override
  @JsonKey()
  final int energy;
  @override
  @JsonKey(name: 'energy_refreshed_at')
  final DateTime? energyRefreshedAt;
  @override
  @JsonKey(name: 'next_energy_at')
  final DateTime? nextEnergyAt;
  @override
  @JsonKey(name: 'acorn_balance')
  final int acorns;
  @override
  @JsonKey(name: 'active_exam_type_id')
  final String? activeExamId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  final String? role;
  final List<String> _permissions;
  @override
  @JsonKey()
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, avatarUrl: $avatarUrl, dailyGoalXp: $dailyGoalXp, energy: $energy, energyRefreshedAt: $energyRefreshedAt, nextEnergyAt: $nextEnergyAt, acorns: $acorns, activeExamId: $activeExamId, createdAt: $createdAt, role: $role, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.dailyGoalXp, dailyGoalXp) ||
                other.dailyGoalXp == dailyGoalXp) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.energyRefreshedAt, energyRefreshedAt) ||
                other.energyRefreshedAt == energyRefreshedAt) &&
            (identical(other.nextEnergyAt, nextEnergyAt) ||
                other.nextEnergyAt == nextEnergyAt) &&
            (identical(other.acorns, acorns) || other.acorns == acorns) &&
            (identical(other.activeExamId, activeExamId) ||
                other.activeExamId == activeExamId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    username,
    avatarUrl,
    dailyGoalXp,
    energy,
    energyRefreshedAt,
    nextEnergyAt,
    acorns,
    activeExamId,
    createdAt,
    role,
    const DeepCollectionEquality().hash(_permissions),
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String email,
    required final String username,
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'daily_goal_xp') final int dailyGoalXp,
    final int energy,
    @JsonKey(name: 'energy_refreshed_at') final DateTime? energyRefreshedAt,
    @JsonKey(name: 'next_energy_at') final DateTime? nextEnergyAt,
    @JsonKey(name: 'acorn_balance') final int acorns,
    @JsonKey(name: 'active_exam_type_id') final String? activeExamId,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    final String? role,
    final List<String> permissions,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'daily_goal_xp')
  int get dailyGoalXp;
  @override
  int get energy;
  @override
  @JsonKey(name: 'energy_refreshed_at')
  DateTime? get energyRefreshedAt;
  @override
  @JsonKey(name: 'next_energy_at')
  DateTime? get nextEnergyAt;
  @override
  @JsonKey(name: 'acorn_balance')
  int get acorns;
  @override
  @JsonKey(name: 'active_exam_type_id')
  String? get activeExamId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  String? get role;
  @override
  List<String> get permissions;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
