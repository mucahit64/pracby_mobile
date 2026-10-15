// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  userId: json['userId'] as String,
  username: json['username'] as String,
  rank: (json['rank'] as num).toInt(),
  xp: (json['xp'] as num).toInt(),
  avatarUrl: json['avatarUrl'] as String?,
  isCurrentUser: json['isCurrentUser'] as bool? ?? false,
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'rank': instance.rank,
  'xp': instance.xp,
  'avatarUrl': instance.avatarUrl,
  'isCurrentUser': instance.isCurrentUser,
};
