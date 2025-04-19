import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_clone/models/comment_model.dart';

class PostModel {
  String? uid;
  String? postID;
  String? text;
  List<String>? imagesUrl;
  List<CommentModel>? comments;
  List<String>? repostIDs;
  List<String>? likesIDs;
  DateTime? timeCreated;
  bool? isRetweet = false;
  String? primaryPostID;

  PostModel({
    this.uid,
    this.postID,
    this.text,
    this.imagesUrl,
    this.comments,
    this.likesIDs,
    this.repostIDs,
    this.timeCreated,
    this.isRetweet,
    this.primaryPostID = "",
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json["uid"],
      postID: json["postID"],
      text: json["text"],
      imagesUrl: List.from(json["imagesUrl"] ?? []),
      comments: (json["comments"] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      likesIDs: List.from(json["likesIDs"] ?? []),
      timeCreated: (json["timeCreated"] as Timestamp).toDate(),
      isRetweet: json["isRetweet"] ?? false,
      primaryPostID: json["primaryPostID"] ?? '',
      repostIDs: List.from(json["repostIDs"] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "postID": postID,
      "text": text,
      "imagesUrl": imagesUrl,
      "comments": comments!.map((e) => e.toJson()),
      "likesIDs": likesIDs,
      "repostIDs": repostIDs,
      "timeCreated": timeCreated,
      "isRetweet": isRetweet,
      "primaryPostID": primaryPostID,
    };
  }

  PostModel copyWith({
    String? uid,
    String? postID,
    String? text,
    List<String>? imagesUrl,
    List<CommentModel>? comments,
    List<String>? likesIDs,
    List<String>? repostIDs,
    DateTime? timeCreated,
    bool? isRetweet,
    String? primaryPostID,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      postID: postID ?? this.postID,
      text: text ?? this.text,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      comments: comments ?? this.comments,
      likesIDs: likesIDs ?? this.likesIDs,
      repostIDs: repostIDs ?? this.repostIDs,
      timeCreated: timeCreated ?? this.timeCreated,
      isRetweet: isRetweet ?? this.isRetweet,
      primaryPostID: primaryPostID ?? this.primaryPostID,
    );
  }
}
