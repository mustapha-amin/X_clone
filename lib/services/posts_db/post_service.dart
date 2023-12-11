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

class PostService {
  FirebaseFirestore? firebaseFirestore;
  FirebaseStorage? firebaseStorage;

  PostService({this.firebaseFirestore, this.firebaseStorage});

  FutureVoid createPost(PostModel post) async {
    try {
      final storagePath =
          "${FirebaseConstants.uploadedMedia}/${post.uid}/${post.postID}";
      final ref = firebaseStorage!.ref().child(storagePath);
      List<String> imageUrls = [];
      if (post.imagesUrl!.isNotEmpty) {
        for (String url in post.imagesUrl!) {
          int index = post.imagesUrl!.indexOf(url);
          final task = await ref.putFile(File(url));
          String downloadUrl = await task.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      }
      PostModel updatedPost = post.copyWith(imagesUrl: imageUrls);
      await firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .doc(updatedPost.uid)
          .collection("posts")
          .doc(updatedPost.postID)
          .set(updatedPost.toJson());
    } catch (e) {
      throw UnableToPostException();
    }
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      final postDoc = firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .doc(post.uid)
          .collection("posts")
          .doc(post.postID);
      await postDoc.delete();
    } catch (e) {
      throw UnableToDeletePostException();
    }
  }

  Stream<List<PostModel>> fetchFeedPosts() {
    return firebaseFirestore!.collectionGroup('posts').snapshots().map((snap) =>
        snap.docs.map((doc) => PostModel.fromJson(doc.data())).toList());
  }

  Future<List<PostModel>> fetchUserPosts(String? uid) async {
    try {
      final snaps = await firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .doc(uid)
          .collection("posts")
          .get();

      final posts =
          snaps.docs.map((post) => PostModel.fromJson(post.data())).toList();
      return posts;
    } catch (e) {
      throw UnableToPostException();
    }
  }

  FutureVoid likePost(PostModel? post) async {
    await firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .doc(post!.uid)
        .collection('posts')
        .doc(post.postID)
        .update({
      'likesIDs': post.likesIDs,
    });
  }

  // Future<bool> postIsLiked(PostModel? post) async {
  //   final doc = await firebaseFirestore!
  //       .collection(FirebaseConstants.postsCollection)
  //       .doc(post!.uid)
  //       .collection('posts')
  //       .doc(post.postID)
  //       .get();

  //   return PostModel.fromJson(doc.data()!).likesIDs!.contains(uid);
  // }

  FutureVoid commentOnPost(PostModel? post, CommentModel comment) async {
    final doc = await firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .doc(post!.uid)
        .collection('posts')
        .doc(post.postID)
        .update({
      'comments': FieldValue.arrayUnion([comment.toJson()])
    });
  }
}
