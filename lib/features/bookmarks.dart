import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/features/home/widgets/post_skeleton.dart';
import 'package:x_clone/features/post/repository/post_service.dart';

class Bookmarks extends ConsumerWidget {
  const Bookmarks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
      ),
      body: ref.watch(currentUserProvider).when(
            data: (user) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ...user!.bookmarkedPosts!.map((post) {
                      return ref.watch(fetchPostByID(post)).when(data: (post) {
                        return PostCard(
                          post: post,
                        );
                      }, error: (_, __) {
                        return SizedBox();
                      }, loading: () {
                        return PostSkeleton();
                      });
                    })
                  ],
                ),
              );
            },
            error: (_, __) {
              return Center(
                child: Text("An error occured"),
              );
            },
            loading: () => Center(
              child: XLoader(),
            ),
          ),
    );
  }
}
