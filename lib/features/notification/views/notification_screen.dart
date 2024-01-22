import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/features/notification/widgets/notification_tile.dart';
import 'package:x_clone/features/notification/repository/notification_service.dart';
import 'package:x_clone/utils/utils.dart';

import '../../auth/repository/user_data_service.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: XAvatar(),
        title: Text(
          "Notifications",
          style: kTextStyle(25, ref),
        ),
        actions: const [
          Icon(Icons.settings),
        ],
      ),
      body: ref.watch(notificationsStreamProvider).when(
            data: (notifications) => notifications!.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return NotificationTile(
                              notificationModel: notifications[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            error: (_, __) => const Center(
              child: Text("An error occured"),
            ),
            loading: () => const XLoader(),
          ),
    );
  }
}
