import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/firebase_constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/notification_model.dart';

import '../../auth/repository/user_data_service.dart';

final notificationProvider = Provider((ref) {
  return NotificationService(
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class NotificationService {
  FirebaseFirestore? firebaseFirestore;
  UserDataService? userDataService;

  NotificationService({this.firebaseFirestore, this.userDataService});

  FutureVoid createNotification(NotificationModel? notificationModel) async {
    try {
      await firebaseFirestore!
          .collection(FirebaseConstants.notificationsCollection)
          .doc(notificationModel!.recipientID)
          .collection('notifications').doc(notificationModel.id)
          .set(notificationModel.toJson());

      await firebaseFirestore!
          .collection(FirebaseConstants.usersCollection)
          .doc(notificationModel.recipientID)
          .update({'notificationCount': FieldValue.increment(1)});
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<NotificationModel>?> fetchNotifications() {
    final snaps = firebaseFirestore!
        .collection(FirebaseConstants.notificationsCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .orderBy('timeCreated', descending: true)
        .snapshots();
    return snaps.map((snap) => snap.docs
        .map((doc) => NotificationModel.fromJson(doc.data()))
        .toList());
  }

  // FutureVoid deleteNotification(String? id) async {
  //   try {
  //     final querySnapshot = await firebaseFirestore!
  //         .collection(FirebaseConstants.notificationsCollection)
  //         .doc(recipientID)
  //         .collection('notifications')
  //         .where('targetID', isEqualTo: '$targetID')
  //         .where('senderID', isEqualTo: senderID)
  //         .get();
  //     for (final doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }
  //     await firebaseFirestore!
  //         .collection(FirebaseConstants.usersCollection)
  //         .doc(recipientID)
  //         .update({'notificationCount': FieldValue.increment(-1)});
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  FutureVoid resetNotificationCount() async {
    await firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'notificationCount': 0});
  }

  FutureVoid readNotification(String? id) async {
    final doc = firebaseFirestore!
        .collection(FirebaseConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .doc(id);

    await doc.update({
      'isRead': true,
    });
  }
}
