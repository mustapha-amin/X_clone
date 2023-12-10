import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/utils/textstyle.dart';

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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostCard(
                  post: posts[index],
                ),
              );
            },
          ),
          error: (_, __) => Center(child: Text("Error fetching postss")),
          loading: () => XLoader(),
        );
  }
}
