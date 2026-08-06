// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      dailyGoalXp: (json['daily_goal_xp'] as num?)?.toInt() ?? 50,
      energy: (json['energy'] as num?)?.toInt() ?? 25,
      energyRefreshedAt: json['energy_refreshed_at'] == null
          ? null
          : DateTime.parse(json['energy_refreshed_at'] as String),
      nextEnergyAt: json['next_energy_at'] == null
          ? null
          : DateTime.parse(json['next_energy_at'] as String),
      acorns: (json['acorn_balance'] as num?)?.toInt() ?? 0,
      activeExamId: json['active_exam_type_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      role: json['role'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'daily_goal_xp': instance.dailyGoalXp,
      'energy': instance.energy,
      'energy_refreshed_at': instance.energyRefreshedAt?.toIso8601String(),
      'next_energy_at': instance.nextEnergyAt?.toIso8601String(),
      'acorn_balance': instance.acorns,
      'active_exam_type_id': instance.activeExamId,
      'created_at': instance.createdAt?.toIso8601String(),
      'role': instance.role,
      'permissions': instance.permissions,
    };
