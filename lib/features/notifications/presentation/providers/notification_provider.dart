import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/notifications/data/models/notification_model.dart';
import 'package:pracby_mobile/features/notifications/data/notification_repository.dart';

final notificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  return ref.watch(notificationRepositoryProvider).getNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(notificationRepositoryProvider).getUnreadCount();
});
