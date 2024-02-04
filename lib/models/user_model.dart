import 'package:cloud_firestore/cloud_firestore.dart';

class XUser {
  String? uid;
  String? name;
  String? username;
  String? email;
  String? bio;
  String? location;
  DateTime? joined;
  List<String>? followers;
  List<String>? following;
  String? website;
  String? profilePicUrl;
  String? coverPicUrl;
  List<String>? conversationList;

  XUser({
    this.uid,
    this.name,
    this.username,
    this.email,
    this.bio,
    this.location,
    this.joined,
    this.followers,
    this.following,
    this.website,
    this.profilePicUrl,
    this.coverPicUrl,
    this.conversationList,
  });

  @override
  String toString() {
    return 'XUser{uid: $uid, name: $name, username: $username, email: $email, '
        'bio: $bio, location: $location, joined: $joined, followers: $followers, '
        'following: $following, website: $website, profilePicUrl: $profilePicUrl, '
        'coverPicUrl: $coverPicUrl, conversationList: $conversationList}';
  }

  factory XUser.fromJson(Map<String, dynamic> json) {
    return XUser(
      uid: json['uid'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      bio: json['bio'],
      location: json['location'],
      joined: (json['joined'] as Timestamp).toDate(),
      followers: List.from(json['followers'] ?? []),
      following: List.from(json['following'] ?? []),
      website: json['website'],
      profilePicUrl: json['profilePicUrl'],
      coverPicUrl: json['coverPicUrl'],
      conversationList: List.from(json['conversationList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'location': location,
      'joined': joined,
      'followers': followers,
      'following': following,
      'website': website,
      'profilePicUrl': profilePicUrl,
      'coverPicUrl': coverPicUrl,
      'conversationList': conversationList,
    };
  }

  XUser copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? bio,
    String? location,
    DateTime? joined,
    List<String>? followers,
    List<String>? following,
    String? website,
    String? profilePicUrl,
    String? coverPicUrl,
    List<String>? conversationList,
  }) {
    return XUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      joined: joined ?? this.joined,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      website: website ?? this.website,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      coverPicUrl: coverPicUrl ?? this.coverPicUrl,
      conversationList: conversationList ?? this.conversationList,
    );
  }
}
