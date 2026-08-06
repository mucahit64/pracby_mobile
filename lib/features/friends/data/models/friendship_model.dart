import 'package:freezed_annotation/freezed_annotation.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

@freezed
class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'friend_id') required String friendId,
    required int status, // 0=pending, 1=accepted, 2=rejected
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Populated from backend join
    String? username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _FriendshipModel;

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}
