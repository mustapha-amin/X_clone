import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
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
    return ref.watch(postsStreamProvider).when(
          data: (posts) => ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: posts[index],
              ).padAll(8);
            },
          ),
          error: (_, __) => const Center(child: Text("Error fetching posts")),
          loading: () => const XLoader(),
        );
  }
}
