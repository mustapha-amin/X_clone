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

// final deleteNotificationProvider =
//     FutureProvider.family<void, List<String>>((ref, args) async {
//   final notificationService = ref.watch(notificationProvider);
//   await notificationService.deleteNotification(args[0], args[1], args[2]);
// });

final readNotificationProvider = FutureProvider.family<void, String>(
  (ref, id) => ref.read(notificationProvider).readNotification(id),
);
