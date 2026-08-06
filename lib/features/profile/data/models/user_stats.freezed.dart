// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_xp')
  int get totalXp => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_streak')
  int get maxStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_xp')
  int get dailyXp => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekly_xp')
  int get weeklyXp => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'quizzes_completed')
  int get quizzesDone => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_active_date')
  String? get lastActiveDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String? userId,
    int xp,
    int level,
    int streak,
    @JsonKey(name: 'total_xp') int totalXp,
    @JsonKey(name: 'max_streak') int maxStreak,
    @JsonKey(name: 'daily_xp') int dailyXp,
    @JsonKey(name: 'weekly_xp') int weeklyXp,
    @JsonKey(name: 'current_streak') int currentStreak,
    @JsonKey(name: 'quizzes_completed') int quizzesDone,
    @JsonKey(name: 'last_active_date') String? lastActiveDate,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? xp = null,
    Object? level = null,
    Object? streak = null,
    Object? totalXp = null,
    Object? maxStreak = null,
    Object? dailyXp = null,
    Object? weeklyXp = null,
    Object? currentStreak = null,
    Object? quizzesDone = null,
    Object? lastActiveDate = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            xp: null == xp
                ? _value.xp
                : xp // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            streak: null == streak
                ? _value.streak
                : streak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalXp: null == totalXp
                ? _value.totalXp
                : totalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            maxStreak: null == maxStreak
                ? _value.maxStreak
                : maxStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyXp: null == dailyXp
                ? _value.dailyXp
                : dailyXp // ignore: cast_nullable_to_non_nullable
                      as int,
            weeklyXp: null == weeklyXp
                ? _value.weeklyXp
                : weeklyXp // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            quizzesDone: null == quizzesDone
                ? _value.quizzesDone
                : quizzesDone // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActiveDate: freezed == lastActiveDate
                ? _value.lastActiveDate
                : lastActiveDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
    _$UserStatsImpl value,
    $Res Function(_$UserStatsImpl) then,
  ) = __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String? userId,
    int xp,
    int level,
    int streak,
    @JsonKey(name: 'total_xp') int totalXp,
    @JsonKey(name: 'max_streak') int maxStreak,
    @JsonKey(name: 'daily_xp') int dailyXp,
    @JsonKey(name: 'weekly_xp') int weeklyXp,
    @JsonKey(name: 'current_streak') int currentStreak,
    @JsonKey(name: 'quizzes_completed') int quizzesDone,
    @JsonKey(name: 'last_active_date') String? lastActiveDate,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
    _$UserStatsImpl _value,
    $Res Function(_$UserStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? xp = null,
    Object? level = null,
    Object? streak = null,
    Object? totalXp = null,
    Object? maxStreak = null,
    Object? dailyXp = null,
    Object? weeklyXp = null,
    Object? currentStreak = null,
    Object? quizzesDone = null,
    Object? lastActiveDate = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserStatsImpl(
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        xp: null == xp
            ? _value.xp
            : xp // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        streak: null == streak
            ? _value.streak
            : streak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalXp: null == totalXp
            ? _value.totalXp
            : totalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        maxStreak: null == maxStreak
            ? _value.maxStreak
            : maxStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyXp: null == dailyXp
            ? _value.dailyXp
            : dailyXp // ignore: cast_nullable_to_non_nullable
                  as int,
        weeklyXp: null == weeklyXp
            ? _value.weeklyXp
            : weeklyXp // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        quizzesDone: null == quizzesDone
            ? _value.quizzesDone
            : quizzesDone // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActiveDate: freezed == lastActiveDate
            ? _value.lastActiveDate
            : lastActiveDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl({
    @JsonKey(name: 'user_id') this.userId,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    @JsonKey(name: 'total_xp') this.totalXp = 0,
    @JsonKey(name: 'max_streak') this.maxStreak = 0,
    @JsonKey(name: 'daily_xp') this.dailyXp = 0,
    @JsonKey(name: 'weekly_xp') this.weeklyXp = 0,
    @JsonKey(name: 'current_streak') this.currentStreak = 0,
    @JsonKey(name: 'quizzes_completed') this.quizzesDone = 0,
    @JsonKey(name: 'last_active_date') this.lastActiveDate,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey(name: 'total_xp')
  final int totalXp;
  @override
  @JsonKey(name: 'max_streak')
  final int maxStreak;
  @override
  @JsonKey(name: 'daily_xp')
  final int dailyXp;
  @override
  @JsonKey(name: 'weekly_xp')
  final int weeklyXp;
  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  @JsonKey(name: 'quizzes_completed')
  final int quizzesDone;
  @override
  @JsonKey(name: 'last_active_date')
  final String? lastActiveDate;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserStats(userId: $userId, xp: $xp, level: $level, streak: $streak, totalXp: $totalXp, maxStreak: $maxStreak, dailyXp: $dailyXp, weeklyXp: $weeklyXp, currentStreak: $currentStreak, quizzesDone: $quizzesDone, lastActiveDate: $lastActiveDate, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.maxStreak, maxStreak) ||
                other.maxStreak == maxStreak) &&
            (identical(other.dailyXp, dailyXp) || other.dailyXp == dailyXp) &&
            (identical(other.weeklyXp, weeklyXp) ||
                other.weeklyXp == weeklyXp) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.quizzesDone, quizzesDone) ||
                other.quizzesDone == quizzesDone) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    xp,
    level,
    streak,
    totalXp,
    maxStreak,
    dailyXp,
    weeklyXp,
    currentStreak,
    quizzesDone,
    lastActiveDate,
    updatedAt,
  );

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(this);
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats({
    @JsonKey(name: 'user_id') final String? userId,
    final int xp,
    final int level,
    final int streak,
    @JsonKey(name: 'total_xp') final int totalXp,
    @JsonKey(name: 'max_streak') final int maxStreak,
    @JsonKey(name: 'daily_xp') final int dailyXp,
    @JsonKey(name: 'weekly_xp') final int weeklyXp,
    @JsonKey(name: 'current_streak') final int currentStreak,
    @JsonKey(name: 'quizzes_completed') final int quizzesDone,
    @JsonKey(name: 'last_active_date') final String? lastActiveDate,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  int get xp;
  @override
  int get level;
  @override
  int get streak;
  @override
  @JsonKey(name: 'total_xp')
  int get totalXp;
  @override
  @JsonKey(name: 'max_streak')
  int get maxStreak;
  @override
  @JsonKey(name: 'daily_xp')
  int get dailyXp;
  @override
  @JsonKey(name: 'weekly_xp')
  int get weeklyXp;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  @JsonKey(name: 'quizzes_completed')
  int get quizzesDone;
  @override
  @JsonKey(name: 'last_active_date')
  String? get lastActiveDate;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'requirement_type')
  String? get requirementType => throw _privateConstructorUsedError;
  @JsonKey(name: 'requirement_value')
  int? get requirementValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'earned_at')
  DateTime? get earnedAt => throw _privateConstructorUsedError;

  /// Serializes this Achievement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
    Achievement value,
    $Res Function(Achievement) then,
  ) = _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'name') String title,
    String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? category,
    @JsonKey(name: 'requirement_type') String? requirementType,
    @JsonKey(name: 'requirement_value') int? requirementValue,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  });
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconUrl = freezed,
    Object? category = freezed,
    Object? requirementType = freezed,
    Object? requirementValue = freezed,
    Object? earnedAt = freezed,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            requirementType: freezed == requirementType
                ? _value.requirementType
                : requirementType // ignore: cast_nullable_to_non_nullable
                      as String?,
            requirementValue: freezed == requirementValue
                ? _value.requirementValue
                : requirementValue // ignore: cast_nullable_to_non_nullable
                      as int?,
            earnedAt: freezed == earnedAt
                ? _value.earnedAt
                : earnedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
    _$AchievementImpl value,
    $Res Function(_$AchievementImpl) then,
  ) = __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'name') String title,
    String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? category,
    @JsonKey(name: 'requirement_type') String? requirementType,
    @JsonKey(name: 'requirement_value') int? requirementValue,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  });
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
    _$AchievementImpl _value,
    $Res Function(_$AchievementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconUrl = freezed,
    Object? category = freezed,
    Object? requirementType = freezed,
    Object? requirementValue = freezed,
    Object? earnedAt = freezed,
  }) {
    return _then(
      _$AchievementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        requirementType: freezed == requirementType
            ? _value.requirementType
            : requirementType // ignore: cast_nullable_to_non_nullable
                  as String?,
        requirementValue: freezed == requirementValue
            ? _value.requirementValue
            : requirementValue // ignore: cast_nullable_to_non_nullable
                  as int?,
        earnedAt: freezed == earnedAt
            ? _value.earnedAt
            : earnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl({
    required this.id,
    @JsonKey(name: 'name') required this.title,
    required this.description,
    @JsonKey(name: 'icon_url') this.iconUrl,
    this.category,
    @JsonKey(name: 'requirement_type') this.requirementType,
    @JsonKey(name: 'requirement_value') this.requirementValue,
    @JsonKey(name: 'earned_at') this.earnedAt,
  });

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'name')
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? category;
  @override
  @JsonKey(name: 'requirement_type')
  final String? requirementType;
  @override
  @JsonKey(name: 'requirement_value')
  final int? requirementValue;
  @override
  @JsonKey(name: 'earned_at')
  final DateTime? earnedAt;

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, iconUrl: $iconUrl, category: $category, requirementType: $requirementType, requirementValue: $requirementValue, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.requirementType, requirementType) ||
                other.requirementType == requirementType) &&
            (identical(other.requirementValue, requirementValue) ||
                other.requirementValue == requirementValue) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    iconUrl,
    category,
    requirementType,
    requirementValue,
    earnedAt,
  );

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(this);
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement({
    required final String id,
    @JsonKey(name: 'name') required final String title,
    required final String description,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final String? category,
    @JsonKey(name: 'requirement_type') final String? requirementType,
    @JsonKey(name: 'requirement_value') final int? requirementValue,
    @JsonKey(name: 'earned_at') final DateTime? earnedAt,
  }) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'name')
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get category;
  @override
  @JsonKey(name: 'requirement_type')
  String? get requirementType;
  @override
  @JsonKey(name: 'requirement_value')
  int? get requirementValue;
  @override
  @JsonKey(name: 'earned_at')
  DateTime? get earnedAt;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreakHistory _$StreakHistoryFromJson(Map<String, dynamic> json) {
  return _StreakHistory.fromJson(json);
}

/// @nodoc
mixin _$StreakHistory {
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_earned')
  int get xpEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'quizzes_completed')
  int get quizzesCompleted => throw _privateConstructorUsedError;

  /// Serializes this StreakHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StreakHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreakHistoryCopyWith<StreakHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakHistoryCopyWith<$Res> {
  factory $StreakHistoryCopyWith(
    StreakHistory value,
    $Res Function(StreakHistory) then,
  ) = _$StreakHistoryCopyWithImpl<$Res, StreakHistory>;
  @useResult
  $Res call({
    String date,
    @JsonKey(name: 'xp_earned') int xpEarned,
    @JsonKey(name: 'quizzes_completed') int quizzesCompleted,
  });
}

/// @nodoc
class _$StreakHistoryCopyWithImpl<$Res, $Val extends StreakHistory>
    implements $StreakHistoryCopyWith<$Res> {
  _$StreakHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreakHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? xpEarned = null,
    Object? quizzesCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            xpEarned: null == xpEarned
                ? _value.xpEarned
                : xpEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            quizzesCompleted: null == quizzesCompleted
                ? _value.quizzesCompleted
                : quizzesCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StreakHistoryImplCopyWith<$Res>
    implements $StreakHistoryCopyWith<$Res> {
  factory _$$StreakHistoryImplCopyWith(
    _$StreakHistoryImpl value,
    $Res Function(_$StreakHistoryImpl) then,
  ) = __$$StreakHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    @JsonKey(name: 'xp_earned') int xpEarned,
    @JsonKey(name: 'quizzes_completed') int quizzesCompleted,
  });
}

/// @nodoc
class __$$StreakHistoryImplCopyWithImpl<$Res>
    extends _$StreakHistoryCopyWithImpl<$Res, _$StreakHistoryImpl>
    implements _$$StreakHistoryImplCopyWith<$Res> {
  __$$StreakHistoryImplCopyWithImpl(
    _$StreakHistoryImpl _value,
    $Res Function(_$StreakHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StreakHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? xpEarned = null,
    Object? quizzesCompleted = null,
  }) {
    return _then(
      _$StreakHistoryImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        xpEarned: null == xpEarned
            ? _value.xpEarned
            : xpEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        quizzesCompleted: null == quizzesCompleted
            ? _value.quizzesCompleted
            : quizzesCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakHistoryImpl implements _StreakHistory {
  const _$StreakHistoryImpl({
    required this.date,
    @JsonKey(name: 'xp_earned') this.xpEarned = 0,
    @JsonKey(name: 'quizzes_completed') this.quizzesCompleted = 0,
  });

  factory _$StreakHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakHistoryImplFromJson(json);

  @override
  final String date;
  @override
  @JsonKey(name: 'xp_earned')
  final int xpEarned;
  @override
  @JsonKey(name: 'quizzes_completed')
  final int quizzesCompleted;

  @override
  String toString() {
    return 'StreakHistory(date: $date, xpEarned: $xpEarned, quizzesCompleted: $quizzesCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakHistoryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.quizzesCompleted, quizzesCompleted) ||
                other.quizzesCompleted == quizzesCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, xpEarned, quizzesCompleted);

  /// Create a copy of StreakHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakHistoryImplCopyWith<_$StreakHistoryImpl> get copyWith =>
      __$$StreakHistoryImplCopyWithImpl<_$StreakHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakHistoryImplToJson(this);
  }
}

abstract class _StreakHistory implements StreakHistory {
  const factory _StreakHistory({
    required final String date,
    @JsonKey(name: 'xp_earned') final int xpEarned,
    @JsonKey(name: 'quizzes_completed') final int quizzesCompleted,
  }) = _$StreakHistoryImpl;

  factory _StreakHistory.fromJson(Map<String, dynamic> json) =
      _$StreakHistoryImpl.fromJson;

  @override
  String get date;
  @override
  @JsonKey(name: 'xp_earned')
  int get xpEarned;
  @override
  @JsonKey(name: 'quizzes_completed')
  int get quizzesCompleted;

  /// Create a copy of StreakHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreakHistoryImplCopyWith<_$StreakHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
