import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? content;
  String? senderID;
  String? receiverID;
  DateTime? timeSent;

  Message({
    this.id,
    this.content,
    this.senderID,
    this.receiverID,
    this.timeSent,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        content: json['content'],
        senderID: json['content'],
        receiverID: json['receiverID'],
        timeSent: (json["timeSent"] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderID': senderID,
      'receiverID': receiverID,
      'timeSent': timeSent,
    };
  }
}
