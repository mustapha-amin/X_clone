import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/messaging/views/message_user.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/features/user_profile/views/edit_profile.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/utils/enums.dart';

import '../../../models/user_model.dart';
import '../../../utils/utils.dart';
import '../../auth/repository/user_data_service.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo({
    super.key,
    required this.user,
  });

  final XUser? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(userProvider)!.uid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40.w,
              child: Text(
                user!.name!,
                style: kTextStyle(25, ref, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                IconButton.outlined(
                  onPressed: () {
                    navigateTo(
                      context,
                      MessageUser(
                        xUser: user!,
                      ),
                    );
                  },
                  icon: Icon(Icons.local_post_office_outlined),
                ),
                SizedBox(
                  height: 30,
                  child: OutlinedButton(
                    onPressed: () {
                      user!.uid == uid
                          ? navigateTo(
                              context,
                              EditProfile(
                                user: user,
                              ))
                          : {
                              if (user!.followers!.contains(uid))
                                {
                                  ref
                                      .read(userDataServiceProvider)
                                      .unfollowUser(user!, uid),
                                  ref.read(
                                      deleteFollowNotificationProvider(uid)),
                                }
                              else
                                {
                                  ref
                                      .read(userDataServiceProvider)
                                      .followUser(user!, uid),
                                  ref.read(
                                    createNotificationProvider(
                                      NotificationModel(
                                        senderID: uid,
                                        recipientID: user!.uid,
                                        message: "followed you",
                                        targetID: uid,
                                        notificationType:
                                            NotificationType.follow,
                                      ),
                                    ),
                                  ),
                                }
                            };
                    },
                    child: Text(
                      user!.uid == uid
                          ? "Edit profile"
                          : user!.followers!.contains(uid)
                              ? "Unfollow"
                              : "Follow",
                      style: kTextStyle(17, ref),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Text(
          '@${user!.username!}',
          style: kTextStyle(15, ref, color: Colors.grey),
        ),
        VerticalSpacing(size: 5),
        Text(
          user!.bio!,
          style: kTextStyle(16, ref),
        ),
        VerticalSpacing(size: 5),
        Row(
          children: [
            user!.location!.isEmpty
                ? const SizedBox()
                : Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        user!.location!,
                        style: kTextStyle(15, ref, color: Colors.grey),
                      ),
                      HorizontalSpacing(size: 5),
                    ],
                  ),
            user!.website!.isEmpty
                ? const SizedBox()
                : Row(
                    children: [
                      const Icon(
                        FeatherIcons.link,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        user!.website!,
                        style: kTextStyle(15, ref, color: Colors.blue),
                      )
                    ],
                  )
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.calendar_month,
              size: 15,
              color: Colors.grey,
            ),
            Text(
              "Joined ${user!.joined!.formatDate}",
              style: kTextStyle(
                15,
                ref,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            text: "${user!.following!.length} ",
            style: kTextStyle(15, ref, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Following  ",
                style: kTextStyle(12, ref, color: Colors.grey),
              ),
              TextSpan(
                text: "${user!.followers!.length} ",
                style: kTextStyle(15, ref, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "Followers",
                style: kTextStyle(12, ref, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
