import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
}
