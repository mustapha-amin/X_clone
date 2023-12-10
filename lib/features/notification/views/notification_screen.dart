import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/utils/utils.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = ref.watch(userProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: context.screenWidth * .2,
          leading: XAvatar(),
          title: Text(
            "Notifications",
            style: kTextStyle(
              25,
               ref,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                FeatherIcons.settings,
                size: 20,
              ),
            )
          ],
        )
      ],
    );
  }
}
