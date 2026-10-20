import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
class UserStats with _$UserStats {
  const UserStats._();

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

  /// The streak to show. The server only resets `current_streak` at the
  /// next rewarded quiz, so a streak whose last active day is before
  /// yesterday (UTC) is already broken and shows 0 (docs 16.4).
  int get displayStreak {
    final last = utcDay(lastActiveDate);
    if (last == null) return 0;
    final now = DateTime.now().toUtc();
    final yesterday = DateTime.utc(now.year, now.month, now.day - 1);
    return last.isBefore(yesterday) ? 0 : currentStreak;
  }

  /// The UTC calendar day of a `last_active_date`. The API sends the DATE
  /// column as a timestamp at midnight in the server's time zone (UTC in
  /// production, e.g. "…T21:00:00.000Z" for the next day on a UTC+3 dev
  /// machine); adding 12 hours before taking the UTC date recovers the day
  /// for any server zone within ±12h.
  @visibleForTesting
  static DateTime? utcDay(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;
    if (!value.contains('T')) {
      return DateTime.utc(parsed.year, parsed.month, parsed.day);
    }
    final shifted = parsed.toUtc().add(const Duration(hours: 12));
    return DateTime.utc(shifted.year, shifted.month, shifted.day);
  }
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
