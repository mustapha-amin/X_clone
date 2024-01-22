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
    this.id,
    this.senderID,
    this.recipientID,
    this.message,
    this.targetID,
    this.notificationType,
    this.isRead,
    DateTime? timeCreated,
  }) : timeCreated = DateTime.now();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
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
      'id': id,
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

  @override
  String toString() {
    return 'NotificationModel {'
        'id: $id, '
        'senderID: $senderID, '
        'recipientID: $recipientID, '
        'message: $message, '
        'targetID: $targetID, '
        'notificationType: ${notificationType?.name}, '
        'timeCreated: $timeCreated, '
        'isRead: $isRead'
        '}';
  }

  NotificationModel copyWith({
    String? id,
    String? senderID,
    String? recipientID,
    String? message,
    String? targetID,
    NotificationType? notificationType,
    DateTime? timeCreated,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      senderID: senderID ?? this.senderID,
      recipientID: recipientID ?? this.recipientID,
      message: message ?? this.message,
      targetID: targetID ?? this.targetID,
      notificationType: notificationType ?? this.notificationType,
      timeCreated: timeCreated ?? this.timeCreated,
      isRead: isRead ?? this.isRead,
    );
  }
}
