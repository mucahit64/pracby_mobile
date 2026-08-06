import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/notifications/data/notification_repository.dart';
import 'package:pracby_mobile/features/notifications/presentation/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(notificationRepositoryProvider)
                  .markAllAsRead();
              ref
                ..invalidate(notificationsProvider)
                ..invalidate(unreadCountProvider);
            },
            child: const Text('Tümünü Oku'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const PbLoading(),
        error: (error, _) => Center(child: Text('Hata: $error')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: AppColors.grey300),
                  SizedBox(height: 16),
                  Text('Henüz bildirim yok'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                leading: CircleAvatar(
                  backgroundColor: notification.isRead
                      ? AppColors.grey100
                      : AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.notifications,
                    color: notification.isRead
                        ? AppColors.grey400
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight:
                        notification.isRead ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: !notification.isRead
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
                onTap: () async {
                  if (!notification.isRead) {
                    await ref
                        .read(notificationRepositoryProvider)
                        .markAsRead(notification.id);
                    ref
                      ..invalidate(notificationsProvider)
                      ..invalidate(unreadCountProvider);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
