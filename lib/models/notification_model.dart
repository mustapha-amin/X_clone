import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../utils/enums.dart';

class NotificationModel {
  String? id;
  String? senderID;
  String? recipientID;
  String? message;
  String? targetID;
  NotificationType? notificationType;
  DateTime? timeCreated;
  bool? isRead;

  NotificationModel({
    String? id,
    this.senderID,
    this.recipientID,
    this.message,
    this.targetID,
    this.notificationType,
    this.isRead,
    DateTime? timeCreated,
  }) : timeCreated = DateTime.now(), id = const Uuid().v4();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      senderID: json['senderID'],
      recipientID: json['recipientID'],
      message: json['message'],
      targetID: json['targetID'],
      notificationType: parseNotificationType(json['notificationType']),
      timeCreated: (json["timeCreated"] as Timestamp).toDate(),
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderID': senderID,
      'recipientID': recipientID,
      'message': message,
      'targetID': targetID,
      'notificationType': notificationType!.name,
      'timeCreated': timeCreated,
      'isRead': isRead,
    };
  }

  static NotificationType parseNotificationType(String? notificationType) {
    switch (notificationType) {
      case 'like':
        return NotificationType.like;
      case 'follow':
        return NotificationType.follow;
      default:
        return NotificationType.comment;
    }
  }
}
