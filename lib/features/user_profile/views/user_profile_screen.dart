import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/extensions.dart';

import '../widgets/user_info.dart';

class UserProfileScreen extends ConsumerWidget {
  XUser? user;
  UserProfileScreen({this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, val) {
            return [
              SliverAppBar(
                expandedHeight: context.screenHeight * .2,
                floating: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: user!.coverPicUrl!.isEmpty
                            ? Container(
                                color: AppColors.blueColor,
                              )
                            : Image.network(
                                user!.coverPicUrl!,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: -5,
                        left: 5,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user!.profilePicUrl!),
                          radius: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      UserInfo(user: user),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Container(),
        ),
      ),
    );
  }
}
