import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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
    NotificationModel? newNotifcation = notificationModel!.copyWith(
      id: const Uuid().v4(),
      isRead: false,
    );
    try {
      await firebaseFirestore!
          .collection(FirebaseConstants.notificationsCollection)
          .doc(newNotifcation.recipientID)
          .collection('notifications')
          .doc(newNotifcation.id)
          .set(newNotifcation.toJson());
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

  FutureVoid deleteLikeNotification(String? pid) async {
    try {
      final querySnapshot = await firebaseFirestore!
          .collectionGroup('notifications')
          .where('targetID', isEqualTo: '$pid')
          .where('notificationType', isEqualTo: 'like')
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  FutureVoid deleteCommentNotification(String? pid) async {
    try {
      final querySnapshot = await firebaseFirestore!
          .collectionGroup('notifications')
          .where('targetID', isEqualTo: '$pid')
          .where('notificationType', isEqualTo: 'comment')
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  FutureVoid deleteFollowNotification(String? uid) async {
    try {
      final querySnapshot = await firebaseFirestore!
          .collectionGroup('notifications')
          .where('targetID', isEqualTo: '$uid')
          .where('notificationType', isEqualTo: 'like')
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  FutureVoid readNotification(String? id) async {
    await firebaseFirestore!
        .collection(FirebaseConstants.notificationsCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .doc(id)
        .update({
      'isRead': true,
    });
  }
}
