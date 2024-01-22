import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/features/notification/repository/notification_service.dart';

final notificationsStreamProvider = StreamProvider((ref) {
  return ref.read(notificationProvider).fetchNotifications();
});

final createNotificationProvider =
    FutureProvider.family<void, NotificationModel>((ref, notification) async {
  final notificationService = ref.watch(notificationProvider);
  await notificationService.createNotification(notification);
});

final deleteLikeNotificationProvider =
    FutureProvider.family<void, String>((ref, pid) async {
  final notificationService = ref.watch(notificationProvider);
  await notificationService.deleteLikeNotification(pid);
});

final deleteCommentNotificationProvider =
    FutureProvider.family<void, String>((ref, pid) async {
  final notificationService = ref.watch(notificationProvider);
  await notificationService.deleteCommentNotification(pid);
});

final deleteFollowNotificationProvider =
    FutureProvider.family<void, String>((ref, uid) async {
  final notificationService = ref.watch(notificationProvider);
  await notificationService.deleteFollowNotification(uid);
});

final readNotificationProvider =
    FutureProvider.family<void, String>((ref, id) async {
  final notificationService = ref.watch(notificationProvider);
  await notificationService.readNotification(id);
});
