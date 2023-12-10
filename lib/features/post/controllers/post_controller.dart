import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/services/posts_db/post_service.dart';
import 'package:x_clone/utils/utils.dart';

final postNotifierProvider = StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    postService: ref.watch(postServiceProvider),
  );
});

final postsStreamProvider = StreamProvider((ref) {
  final posts = ref.watch(postNotifierProvider.notifier);
  return posts.fetchFeedPosts();
});

class PostController extends StateNotifier<bool> {
  PostService? postService;
  PostController({this.postService}) : super(false);

  FutureVoid createPost(BuildContext context, PostModel post) async {
    state = true;
    try {
      await postService!.createPost(post);
    } catch (e) {
      if (context.mounted) {
        showErrorDialog(context: context, message: e.toString());
      }
    }
    state = false;
  }

  FutureVoid deleteTweet(BuildContext context, PostModel post) async {
    try {
      await postService!.deletePost(post);
    } catch (e) {
      if (context.mounted) {
        showErrorDialog(context: context, message: e.toString());
      }
    }
  }

  Stream<List<PostModel>> fetchFeedPosts() {
    return postService!.fetchFeedPosts();
  }

  Future<List<PostModel>?> fetchUserPosts(
      BuildContext? context, String? uid) async {
    try {
      return postService!.fetchUserPosts(uid);
    } on UnableToFetchPostException catch (e) {
      if (context!.mounted) {
        showErrorDialog(context: context, message: e.toString());
      }
      return null;
    }
  }
}
