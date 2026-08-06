import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/notifications/data/models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(apiClient: ref.watch(apiClientProvider));
});

class NotificationRepository {
  const NotificationRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<NotificationModel>> getNotifications() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.notifications);
    return (response.data ?? [])
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _apiClient
        .get<Map<String, dynamic>>(Endpoints.notificationsUnreadCount);
    return response.data?['count'] as int? ?? 0;
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.patch<Map<String, dynamic>>(
      Endpoints.notificationRead(id),
    );
  }

  Future<void> markAllAsRead() async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.notificationsReadAll,
    );
  }
}
