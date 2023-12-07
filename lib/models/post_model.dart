import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_clone/models/comment_model.dart';

class PostModel {
  String? uid;
  String? postID;
  String? text;
  List<String>? imagesUrl;
  List<CommentModel>? comments;
  List<String>? likesIDs;
  int? repostCount;
  DateTime? timeCreated;

  PostModel({
    this.uid,
    this.postID,
    this.text,
    this.imagesUrl,
    this.comments,
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
      comments: List.from(json["comments"].map((comment) => CommentModel.fromJson(comment))),
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
      "comments": comments!.map((e) => e.toJson()),
      "likesID": likesIDs,
      "repostCount": repostCount,
      "timeCreated": timeCreated,
    };
  }

  PostModel copyWith({
    String? uid,
    String? postID,
    String? text,
    List<String>? imagesUrl,
    List<CommentModel>? comments,
    List<String>? likesIDs,
    int? repostCount,
    DateTime? timeCreated,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      postID: postID ?? this.postID,
      text: text ?? this.text,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      comments: comments ?? this.comments,
      likesIDs: likesIDs ?? this.likesIDs,
      repostCount: repostCount ?? this.repostCount,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

}
