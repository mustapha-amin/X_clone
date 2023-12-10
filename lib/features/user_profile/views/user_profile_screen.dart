import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
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
            return ref.watch(userProviderWithID(user!.uid!)).when(
                  data: (user) => [
                    SliverAppBar(
                      expandedHeight: context.screenHeight * .2,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: user!.coverPicUrl!.isEmpty
                                ? Container(
                                    color: AppColors.blueColor,
                                  )
                                : Image.network(
                                    user.coverPicUrl!,
                                    fit: BoxFit.fitWidth,
                                    errorBuilder: (context, _, __) {
                                      return const Icon(
                                        Icons.error,
                                        size: 40,
                                      );
                                    },
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 5,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profilePicUrl!),
                              radius: 35,
                            ),
                          ),
                        ],
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
                  ],
                  error: (_, __) => [const Text("Error fetching user data")],
                  loading: () => [const XLoader()],
                );
          },
          body: ref.watch(userPostsProvider(user!.uid!)).when(
                data: (posts) => posts!.isEmpty
                    ? const Center(child: Text("No posts yet"))
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PostCard(post: posts[index]),
                          );
                        },
                      ),
                error: (_, __) => const Text("Error loading posts"),
                loading: () => const XLoader(),
              ),
        ),
      ),
    );
  }
}
