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
      imagesUrls: json["imagesUrls"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "commentID": commentID,
      "text": text,
      "imagesUrls" : imagesUrls,
    };
  }
}
