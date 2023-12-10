import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/user_profile/views/edit_profile.dart';

import '../../../models/user_model.dart';
import '../../../utils/utils.dart';

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
            Text(
              user!.name!,
              style: kTextStyle(30, ref, fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
              onPressed: () {
                user!.uid == uid
                    ? navigateTo(
                        context,
                        EditProfile(
                          user: user,
                        ))
                    : null;
              },
              child: Text(user!.uid == uid ? "Edit profile" : "Follow"),
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
            const Icon(
              Icons.calendar_month,
              size: 15,
              color: Colors.grey,
            ),
            HorizontalSpacing(size: 5),
            Text(
              "Joined ${user!.joined!.formatJoinTime}",
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
