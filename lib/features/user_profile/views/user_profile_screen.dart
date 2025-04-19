import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/theme/pallete.dart';
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
                      expandedHeight: 180,
                      leading: BackButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                            (_) => Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          SizedBox(height: 200),
                          user!.coverPicUrl!.isEmpty
                              ? Container(
                                  height: 180,
                                  color: AppColors.blueColor,
                                )
                              : SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: Image.network(
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
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                user.profilePicUrl!.isEmpty
                                    ? ImagesPaths.person
                                    : user.profilePicUrl!,
                              ),
                              radius: 35,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.8),
                          ),
                          onPressed: () {
                            log(user.profilePicUrl!);
                            log(user.coverPicUrl!);
                          },
                          icon: const Icon(Icons.search),
                        ),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.8),
                          ),
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
                  error: (_, __) => [
                    const Text("Error fetching user data"),
                  ],
                  loading: () => [
                    SliverToBoxAdapter(child: const XLoader()),
                  ],
                );
          },
          body: ref.watch(userPostsProvider(user!.uid!)).when(
                data: (posts) => posts!.isEmpty
                    ? const Center(child: Text("No posts yet"))
                    : ListView.builder(
                        itemCount: user!.uid == ref.watch(uidProvider)
                            ? posts.where((post) => !post.isRetweet!).length
                            : posts.length,
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
