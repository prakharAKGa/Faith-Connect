import 'package:faithconnect/app/core/utils/snackbar.dart';
import 'package:faithconnect/app/data/model/notification_model.dart';
import 'package:faithconnect/app/data/repo/notification_repository.dart';
import 'package:get/get.dart';

class NotificationViewForLeadersController extends GetxController {
  final NotificationRepository _repo = NotificationRepository();

  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final result = await _repo.getNotifications();
      notifications.assignAll(result);
    } catch (e) {
      CustomSnackbar.error("Failed to load notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Refresh on pull-to-refresh
  Future<void> refresh() async {
    await fetchNotifications();
  }

  // Optional: Mark as read when user taps (you can add later)
  Future<void> markAsRead(int id) async {
    try {
      await _repo.markAsRead(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          userId: notifications[index].userId,
          type: notifications[index].type,
          referenceId: notifications[index].referenceId,
          isRead: true,
          createdAt: notifications[index].createdAt,
        );
        notifications.refresh();
      }
    } catch (e) {
      CustomSnackbar.error("Failed to mark as read");
    }
  }
}