import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/providers.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/utils/extensions.dart';

class ForYou extends ConsumerStatefulWidget {
  const ForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForYouState();
}

class _ForYouState extends ConsumerState<ForYou> {
  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(uidProvider);

    return ref.watch(postsStreamProvider).when(
          data: (posts) {
            final filteredPosts = posts.where((post) {
              final isRetweet = post.isRetweet ?? false;
              final repostIDs = post.repostIDs ?? [];
              return !(isRetweet && repostIDs.contains(uid));
            }).toList();

            return ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                return PostCard(post: filteredPosts[index]).padAll(8);
              },
            );
          },
          error: (_, __) => const Center(child: Text("Error fetching posts")),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
