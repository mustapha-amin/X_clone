import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/extensions.dart';

import '../../../auth/repository/user_data_service.dart';

class Following extends ConsumerStatefulWidget {
  const Following({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowingState();
}

class _FollowingState extends ConsumerState<Following> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<XUser?> user =
        ref.watch(xUserStreamProvider(ref.watch(uidProvider)));
    return user.hasValue
        ? ref.watch(postsStreamProvider).when(
              data: (posts) => ListView.builder(
                itemCount: posts
                    .where(
                      (post) => user
                          .when(
                            data: (user) => user!.following,
                            error: (_, __) => null,
                            loading: () => null,
                          )!
                          .contains(post.uid),
                    )
                    .length,
                itemBuilder: (context, index) {
                  return PostCard(
                    post: posts[index],
                  ).padAll(8);
                },
              ),
              error: (_, __) =>
                  const Center(child: Text("Error fetching posts")),
              loading: () => const XLoader(),
            )
        : const XLoader();
  }
}
