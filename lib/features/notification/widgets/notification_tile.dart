import 'dart:developer';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/views/for%20you/post_detail_screen.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/features/post/repository/post_service.dart';
import 'package:x_clone/utils/enums.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/textstyle.dart';

class NotificationTile extends ConsumerStatefulWidget {
  NotificationModel? notificationModel;
  NotificationTile({
    this.notificationModel,
    super.key,
  });

  @override
  ConsumerState<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends ConsumerState<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(userProviderWithID(widget.notificationModel!.senderID!))
        .when(
          data: (user) => ListTile(
            tileColor: widget.notificationModel!.isRead!
                ? Theme.of(context).scaffoldBackgroundColor
                : const Color(0xFF051D2B),
            onTap: switch (widget.notificationModel!.notificationType) {
              NotificationType.follow => () => navigateTo(
                    context,
                    UserProfileScreen(
                      user: user,
                    ),
                  ),
              _ => () {
                  AsyncValue<PostModel> fetchedPost = ref.watch(
                      fetchPostByID(widget.notificationModel!.targetID!));
                  fetchedPost.when(
                    data: (post) => {
                      log(widget.notificationModel.toString()),
                      navigateTo(
                        context,
                        PostDetailsScreen(post: post, xUser: user),
                      ),
                    },
                    error: (_, __) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error loading post"),
                      ),
                    ),
                    loading: () => null,
                  );
                }
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user!.profilePicUrl!.isEmpty
                    ? CircleAvatar(
                        radius: 10,
                        child: SvgPicture.asset(ImagesPaths.person),
                      )
                    : CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(user.profilePicUrl!),
                      ),
                RichText(
                  text: TextSpan(
                    text: '${user.name!} ',
                    style: kTextStyle(14, ref, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: widget.notificationModel!.message,
                        style: kTextStyle(13, ref),
                      )
                    ],
                  ),
                )
              ],
            ),
            leading: switch (widget.notificationModel!.notificationType) {
              NotificationType.like => const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              NotificationType.comment =>
                const Icon(FeatherIcons.messageCircle),
              _ => const Icon(Icons.person)
            },
            subtitle: switch (widget.notificationModel!.notificationType) {
              NotificationType.like || NotificationType.comment => ref
                  .watch(fetchPostByID(widget.notificationModel!.targetID!))
                  .when(
                    data: (post) => Text(
                      post.text!,
                      style:
                          kTextStyle(15, ref, color: Colors.grey[600]).copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    error: (_, __) => const Text("An error occured"),
                    loading: () => const Text("Loading..."),
                  ),
              _ => ref
                  .read(userProviderWithID(widget.notificationModel!.senderID!))
                  .when(
                    data: (user) => Text(user!.bio!),
                    error: (_, __) => const Text("An error occured"),
                    loading: () => const Text("Loading..."),
                  ),
            },
          ),
          error: (_, __) => const Text("An error occured"),
          loading: () => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
        );
  }
}
