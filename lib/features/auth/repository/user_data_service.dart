import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import '../../../constants/firebase_constants.dart';
import 'base_user_data_service.dart';
import 'package:x_clone/models/user_model.dart';

final userDataServiceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final firebaseStorage = ref.watch(firebaseStorageProvider);
  return UserDataService(
    firebaseFirestore: firestore,
    firebaseStorage: firebaseStorage,
  );
});

final xUserStreamProvider = StreamProvider.family<XUser?, String>((ref, uid) {
  return ref.read(userDataServiceProvider).fetchUserData(uid);
});

class UserDataService implements BaseUserDataService {
  FirebaseFirestore? firebaseFirestore;
  FirebaseStorage? firebaseStorage;
  UserDataService({this.firebaseFirestore, this.firebaseStorage});

  @override
  FutureVoid saveUserData(XUser user) async {
    try {
      await firebaseFirestore!
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> updateImageUrl(
    String uid,
    String imgPath, {
    bool isProfilePic = true,
  }) async {
    String? imgUrl;
    File? file;
    Reference? ref;
    final storagePathProfile = '${FirebaseConstants.usersProfilePics}/$uid/}';
    final storagePathCover = '${FirebaseConstants.usersCoverPics}/$uid/}';
    try {
      if (isProfilePic) {
        file = File(imgPath);
        ref = firebaseStorage!.ref().child(storagePathProfile);
        await ref.putFile(file);
      } else {
        file = File(imgPath);
        ref = firebaseStorage!.ref().child(storagePathCover);
        await ref.putFile(file);
      }
      imgUrl = await ref.getDownloadURL();
      return imgUrl;
    } catch (e) {
      log(e.toString());
      throw Exception("An error occured");
    }
  }

  Stream<XUser?> fetchUserData(String? uid) {
    return firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(uid!)
        .snapshots()
        .map((user) => XUser.fromJson(user.data()!));
  }

  Future<bool> userDetailsInDB(String? uid) async {
    final data = await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .get();
    return data.exists;
  }

  FutureVoid followUser(XUser user, String? uid) async {
    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid!)
        .update({
      'followers': FieldValue.arrayUnion([uid]),
    });

    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .update({
      'following': FieldValue.arrayUnion([user.uid]),
    });
  }

  FutureVoid unfollowUser(XUser user, String uid) async {
    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid!)
        .update({
      'followers': FieldValue.arrayRemove([uid]),
    });

    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .update({
      'following': FieldValue.arrayRemove([user.uid]),
    });
  }

  Future<bool> isFollowing(String? uid) async {
    final doc = await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .get();
    List<String> followers = doc.data()!['followers'];

    return followers.contains(FirebaseAuth.instance.currentUser!.uid);
  }

  Stream<List<XUser>> searchUser(String? name) {
    final snaps = firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .snapshots()
        .map((snap) => snap.docs.map((e) => XUser.fromJson(e.data())).toList());

    return snaps;
  }
}
