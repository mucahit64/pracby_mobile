import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'daily_goal_xp') @Default(50) int dailyGoalXp,
    @Default(25) int energy,
    @JsonKey(name: 'energy_refreshed_at') DateTime? energyRefreshedAt,
    @JsonKey(name: 'next_energy_at') DateTime? nextEnergyAt,
    @JsonKey(name: 'acorn_balance') @Default(0) int acorns,
    @JsonKey(name: 'active_exam_type_id') String? activeExamId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? role,
    @Default([]) List<String> permissions,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
