import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/firebase_constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/comment_model.dart';
import 'package:x_clone/models/post_model.dart';

class UnableToPostException implements Exception {
  @override
  String toString() {
    return "Unable to post";
  }
}

class UnableToDeletePostException implements Exception {
  @override
  String toString() {
    return "Unable to delete post";
  }
}

class UnableToFetchPostException implements Exception {
  @override
  String toString() {
    return "Unable to fetch posts";
  }
}

final postServiceProvider = Provider((ref) {
  return PostService(
    firebaseFirestore: ref.watch(firestoreProvider),
    firebaseStorage: ref.watch(firebaseStorageProvider),
  );
});

final fetchPostByID =
    FutureProvider.family<PostModel, String>((ref, pid) async {
  final fetchedPost = await ref.read(postServiceProvider).fetchPostByID(pid);
  return fetchedPost;
});

class PostService {
  FirebaseFirestore? firebaseFirestore;
  FirebaseStorage? firebaseStorage;

  PostService({this.firebaseFirestore, this.firebaseStorage});

  FutureVoid createPost(PostModel post) async {
    try {
      final storagePath =
          "${FirebaseConstants.uploadedMedia}/${post.uid}/${post.postID}/";
      List<String> imageUrls = [];
      if (post.imagesUrl!.isNotEmpty) {
        for (String url in post.imagesUrl!) {
          final ref = firebaseStorage!.ref().child('$storagePath/$url');
          final task = await ref.putFile(File(url));
          String downloadUrl = await task.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      }
      PostModel updatedPost = post.copyWith(imagesUrl: imageUrls);
      await firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .doc(updatedPost.postID)
          .set(updatedPost.toJson());
    } catch (e) {
      throw UnableToPostException();
    }
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      await firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .doc(post.postID)
          .delete();
      final storagePath =
          "${FirebaseConstants.uploadedMedia}/${post.uid}/${post.postID}/";
      await firebaseStorage!.ref(storagePath).delete();
    } catch (e) {
      throw UnableToDeletePostException();
    }
  }

  Stream<List<PostModel>> fetchFeedPosts() {
    return firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .snapshots()
        .map((snap) =>
            snap.docs.map((e) => PostModel.fromJson(e.data())).toList());
  }

  Future<List<PostModel>> fetchUserPosts(String? uid) async {
    try {
      final querySnap = await firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .where('uid', isEqualTo: uid)
          .get();

      final posts = querySnap.docs
          .map((post) => PostModel.fromJson(post.data()))
          .toList();
      return posts;
    } catch (e) {
      throw UnableToPostException();
    }
  }

  FutureVoid likePost(PostModel? post) async {
    await firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .doc(post!.postID)
        .update({
      'likesIDs': post.likesIDs,
    });
  }

  FutureVoid commentOnPost(CommentModel? comment, PostModel? post) async {
    final storagePath =
        "${FirebaseConstants.uploadedMedia}/${post!.uid}/${post.postID}/comments/${comment!.uid}/";
    List<String> imageUrls = [];
    if (comment.imagesUrls!.isNotEmpty) {
      for (String url in comment.imagesUrls!) {
        final ref = firebaseStorage!.ref().child('$storagePath/$url');
        final task = await ref.putFile(File(url));
        String downloadUrl = await task.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    }
    CommentModel newComment = comment.copyWith(imagesUrls: imageUrls);
    List<CommentModel> comments = [...post.comments!, newComment];
    PostModel newPost = post.copyWith(comments: comments);
    await firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .doc(newPost.postID)
        .update(
            {'comments': newPost.comments!.map((comment) => comment.toJson())});
  }

  Future<PostModel> fetchPostByID(String? postID) async {
    final doc = await firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .doc(postID)
        .get();
    return PostModel.fromJson(doc.data()!);
  }
}
