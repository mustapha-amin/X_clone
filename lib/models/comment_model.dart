class CommentModel {
  String? uid;
  String? commentID;
  String? text;

  CommentModel({this.uid, this.commentID, this.text});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      uid: json["uid"],
      commentID: json["commentID"],
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "commentID": commentID,
      "text": text,
    };
  }
}
