import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @JsonKey(name: 'user_id') String? userId,
    @Default(0) int xp,
    @Default(1) int level,
    @Default(0) int streak,
    @JsonKey(name: 'total_xp') @Default(0) int totalXp,
    @JsonKey(name: 'max_streak') @Default(0) int maxStreak,
    @JsonKey(name: 'daily_xp') @Default(0) int dailyXp,
    @JsonKey(name: 'weekly_xp') @Default(0) int weeklyXp,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'quizzes_completed') @Default(0) int quizzesDone,
    @JsonKey(name: 'last_active_date') String? lastActiveDate,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    @JsonKey(name: 'name') required String title,
    required String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? category,
    @JsonKey(name: 'requirement_type') String? requirementType,
    @JsonKey(name: 'requirement_value') int? requirementValue,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}
