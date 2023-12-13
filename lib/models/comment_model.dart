class CommentModel {
  String? uid;
  String? commentID;
  String? text;
  List<String>? imagesUrls;

  CommentModel({this.uid, this.commentID, this.text, this.imagesUrls});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      uid: json["uid"],
      commentID: json["commentID"],
      text: json["text"],
      imagesUrls: List<String>.from(json["imagesUrls"] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "commentID": commentID,
      "text": text,
      "imagesUrls": imagesUrls,
    };
  }

  CommentModel copyWith({
    String? uid,
    String? commentID,
    String? text,
    List<String>? imagesUrls,
  }) {
    return CommentModel(
      uid: uid ?? this.uid,
      commentID: commentID ?? this.commentID,
      text: text ?? this.text,
      imagesUrls: imagesUrls ?? this.imagesUrls,
    );
  }
}
