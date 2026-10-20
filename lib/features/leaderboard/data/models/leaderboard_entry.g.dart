// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  username: json['username'] as String,
  avatarUrl: json['avatar_url'] as String?,
  xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
  rank: (json['rank'] as num?)?.toInt(),
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'username': instance.username,
  'avatar_url': instance.avatarUrl,
  'xp_earned': instance.xpEarned,
  'rank': instance.rank,
};
