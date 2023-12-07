import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/firebase_constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/post_model.dart';

class UnableToPostException implements Exception {}

class UnableToDeletePostException implements Exception {}

final postServiceProvider = Provider((ref) {
  return PostService(
    firebaseFirestore: ref.watch(firestoreProvider),
    firebaseStorage: ref.watch(firebaseStorageProvider),
  ) ;
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
      post.imagesUrl!.forEach((url) async {
        int index = post.imagesUrl!.indexOf(url);
        final task = await ref.putFile(File(url));
        post.imagesUrl![index] = await task.ref.getDownloadURL();
      });
      await firebaseFirestore!
          .collection(FirebaseConstants.postsCollection)
          .doc(post.uid)
          .collection("posts")
          .doc(post.postID)
          .set(post.toJson());
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
    final posts = firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => PostModel.fromJson(doc.data())).toList());
    return posts;
  }

  Future<List<PostModel>> fetchUserPosts(String? uid) async {
    final snaps = await firebaseFirestore!
        .collection(FirebaseConstants.postsCollection)
        .doc(uid)
        .collection("posts")
        .get();

    final posts =
        snaps.docs.map((post) => PostModel.fromJson(post.data())).toList();
    return posts;
  }
}
