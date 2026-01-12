import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../controllers/notification_view_for_leaders_controller.dart';

class NotificationViewForLeadersView
    extends GetView<NotificationViewForLeadersController> {
  const NotificationViewForLeadersView({super.key});

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return DateFormat('MMM d, yyyy').format(date);
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'NEW_MESSAGE':
        return Iconsax.message_2;
      case 'NEW_POST':
        return Iconsax.document_text;
      case 'NEW_REEL':
        return Iconsax.video_play;
      default:
        return Iconsax.notification;
    }
  }

  Color _getColorForType(String type, ColorScheme scheme) {
    switch (type) {
      case 'NEW_MESSAGE':
        return scheme.primary;
      case 'NEW_POST':
        return Colors.green;
      case 'NEW_REEL':
        return Colors.purple;
      default:
        return scheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.notification_bing,
                  size: 80,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  "No notifications yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We'll notify you when something new arrives",
                  style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              final isRead = notification.isRead;

              return Dismissible(
                key: Key(notification.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  // Optional: Delete notification from backend
                  controller.notifications.removeAt(index);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: _getColorForType(notification.type, scheme)
                        .withOpacity(0.15),
                    child: Icon(
                      _getIconForType(notification.type),
                      color: _getColorForType(notification.type, scheme),
                      size: 28,
                    ),
                  ),
                  title: Text(
                    notification.type.replaceAll('_', ' '),
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 15,
                      color: scheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: isRead
                      ? null
                      : Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                  onTap: () {
                    // Optional: Mark as read on tap
                    // if (!isRead) {
                    //   controller.markAsRead(notification.id);
                    // }

                    // // Navigate based on type (you can expand this)
                    // switch (notification.type) {
                    //   case 'NEW_MESSAGE':
                    //     Get.toNamed('/chat', arguments: {
                    //       'conversationId': notification.referenceId
                    //     });
                    //     break;
                    //   case 'NEW_POST':
                    //     Get.toNamed('/post', arguments: {
                    //       'postId': notification.referenceId
                    //     });
                    //     break;
                    //   case 'NEW_REEL':
                    //     Get.toNamed('/reel', arguments: {
                    //       'reelId': notification.referenceId
                    //     });
                    //     break;
                    // }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}