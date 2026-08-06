// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendshipModelImpl _$$FriendshipModelImplFromJson(
  Map<String, dynamic> json,
) => _$FriendshipModelImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  friendId: json['friend_id'] as String,
  status: (json['status'] as num).toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  username: json['username'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$$FriendshipModelImplToJson(
  _$FriendshipModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'friend_id': instance.friendId,
  'status': instance.status,
  'created_at': instance.createdAt?.toIso8601String(),
  'username': instance.username,
  'avatar_url': instance.avatarUrl,
};
