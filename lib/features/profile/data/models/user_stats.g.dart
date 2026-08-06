// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      userId: json['user_id'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      maxStreak: (json['max_streak'] as num?)?.toInt() ?? 0,
      dailyXp: (json['daily_xp'] as num?)?.toInt() ?? 0,
      weeklyXp: (json['weekly_xp'] as num?)?.toInt() ?? 0,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      quizzesDone: (json['quizzes_completed'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['last_active_date'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'xp': instance.xp,
      'level': instance.level,
      'streak': instance.streak,
      'total_xp': instance.totalXp,
      'max_streak': instance.maxStreak,
      'daily_xp': instance.dailyXp,
      'weekly_xp': instance.weeklyXp,
      'current_streak': instance.currentStreak,
      'quizzes_completed': instance.quizzesDone,
      'last_active_date': instance.lastActiveDate,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      title: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      category: json['category'] as String?,
      requirementType: json['requirement_type'] as String?,
      requirementValue: (json['requirement_value'] as num?)?.toInt(),
      earnedAt: json['earned_at'] == null
          ? null
          : DateTime.parse(json['earned_at'] as String),
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'category': instance.category,
      'requirement_type': instance.requirementType,
      'requirement_value': instance.requirementValue,
      'earned_at': instance.earnedAt?.toIso8601String(),
    };

_$StreakHistoryImpl _$$StreakHistoryImplFromJson(Map<String, dynamic> json) =>
    _$StreakHistoryImpl(
      date: json['date'] as String,
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
      quizzesCompleted: (json['quizzes_completed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$StreakHistoryImplToJson(_$StreakHistoryImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'xp_earned': instance.xpEarned,
      'quizzes_completed': instance.quizzesCompleted,
    };
