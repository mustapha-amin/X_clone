import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import '../../constants/firebase_constants.dart';
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
    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<XUser> updateImageUrl(
    XUser xUser,
    String imgPath, {
    bool isProfilePic = true,
  }) async {
    String? imgUrl;
    File? file;
    Reference ref;
    try {
      if (isProfilePic) {
        final storagePath =
            '${FirebaseConstants.usersProfilePics}/${xUser.uid}/';
        file = File(imgPath);
        ref = firebaseStorage!.ref().child(storagePath);
        await ref.putFile(file);
      } else {
        final storagePath = '${FirebaseConstants.usersCoverPics}/${xUser.uid}/';
        file = File(imgPath);
        ref = firebaseStorage!.ref().child(storagePath);
        await ref.putFile(file);
      }
      imgUrl = await ref.getDownloadURL();
      xUser = isProfilePic
          ? xUser.copyWith(profilePicUrl: imgUrl)
          : xUser.copyWith(coverPicUrl: imgUrl);
      return xUser;
    } catch (e) {
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

  FutureVoid followUser(String uid, {bool isFollowing = false}) async {
    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .update({
      'followers': isFollowing
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
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
        .where('name', isEqualTo: name)
        .snapshots()
        .map((snap) => snap.docs.map((e) => XUser.fromJson(e.data())).toList());
    return snaps;
  }
}
