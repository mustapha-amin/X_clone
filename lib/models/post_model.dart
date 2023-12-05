import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? uid;
  String? postID;
  String? text;
  List<String>? imagesUrl;
  List<String>? commentIDs;
  List<String>? likesIDs;
  int? repostCount;
  DateTime? timeCreated;

  PostModel({
    this.uid,
    this.postID,
    this.text,
    this.imagesUrl,
    this.commentIDs,
    this.likesIDs,
    this.repostCount,
    this.timeCreated,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json["uid"],
      postID: json["postID"],
      text: json["text"],
      imagesUrl: List.from(json["imagesUrl"] ?? []),
      commentIDs: json["commentID"],
      likesIDs: List.from(json["likesID"] ?? []),
      repostCount: json["repostCount"],
      timeCreated: (json["timeCreated"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "postID": postID,
      "text": text,
      "imagesUrl": imagesUrl,
      "commentIDs": commentIDs,
      "likesID": likesIDs,
      "repostCount": repostCount,
      "timeCreated": timeCreated,
    };
  }
}
