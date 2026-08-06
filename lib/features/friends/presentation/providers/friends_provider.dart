import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/friends/data/friends_repository.dart';
import 'package:pracby_mobile/features/friends/data/models/friendship_model.dart';

final friendsProvider = FutureProvider.autoDispose<List<FriendshipModel>>((ref) {
  return ref.watch(friendsRepositoryProvider).getFriends();
});

final friendRequestsProvider =
    FutureProvider.autoDispose<List<FriendshipModel>>((ref) {
  return ref.watch(friendsRepositoryProvider).getRequests();
});
