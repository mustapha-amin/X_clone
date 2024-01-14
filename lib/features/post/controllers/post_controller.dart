import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/features/post/repository/post_service.dart';
import 'package:x_clone/utils/enums.dart';
import 'package:x_clone/utils/utils.dart';

final postNotifierProvider =
    StateNotifierProvider<PostController, Status>((ref) {
  return PostController(
    postService: ref.watch(postServiceProvider),
  );
});

final postsStreamProvider = StreamProvider((ref) {
  final posts = ref.watch(postNotifierProvider.notifier);
  return posts.fetchFeedPosts();
});

final userPostsProvider =
    FutureProvider.family<List<PostModel>?, String>((ref, uid) async {
  final posts = ref.watch(postNotifierProvider.notifier);
  return await posts.fetchUserPosts(uid);
});

class PostController extends StateNotifier<Status> {
  PostService? postService;
  PostController({this.postService}) : super(Status.initial);

  FutureVoid createPost(BuildContext context, PostModel post) async {
    try {
      state = Status.loading;
      await postService!.createPost(post);
      state = Status.success;
    } catch (e) {
      state = Status.failure;
      showErrorDialog(context: context, message: e.toString());
    }
  }

  FutureVoid deleteTweet(BuildContext context, PostModel post) async {
    try {
      await postService!.deletePost(post);
    } catch (e) {
      showErrorDialog(context: context, message: e.toString());
    }
  }

  Stream<List<PostModel>> fetchFeedPosts() {
    return postService!.fetchFeedPosts();
  }

  Stream<List<PostModel>> fetchFollowingPosts() {
    return postService!.fetchFeedPosts();
  }

  Future<List<PostModel>?> fetchUserPosts(String? uid) async {
    try {
      return postService!.fetchUserPosts(uid);
    } on UnableToFetchPostException {
      return null;
    }
  }
}
