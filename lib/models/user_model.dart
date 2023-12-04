class XUser {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String bio;
  final int tweetCount;
  final int likesCount;
  final String? location;
  final DateTime joined;
  final List<String> followers;
  final List<String> following;
  final String website;
  final String profilePicUrl;
  final String coverPicUrl;

  XUser({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.tweetCount,
    required this.likesCount,
    required this.location,
    required this.joined,
    required this.followers,
    required this.following,
    required this.website,
    required this.profilePicUrl,
    required this.coverPicUrl,
  });

  factory XUser.fromJson(Map<String, dynamic> json) {
    return XUser(
      uid: json['uid'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      bio: json['bio'],
      tweetCount: json['tweetCount'],
      likesCount: json['likesCount'],
      location: json['location'],
      joined: DateTime.parse(json['joined']),
      followers: List<String>.from(json['followers']),
      following: List<String>.from(json['following']),
      website: json['website'],
      profilePicUrl: json['profilePicUrl'],
      coverPicUrl: json['coverPicUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'tweetCount': tweetCount,
      'likesCount': likesCount,
      'location': location,
      'joined': joined,
      'followers': followers,
      'following': following,
      'website': website,
      'profilePicUrl': profilePicUrl,
      'coverPicUrl': coverPicUrl,
    };
  }

  XUser copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? bio,
    int? tweetCount,
    int? likesCount,
    String? location,
    DateTime? joined,
    List<String>? followers,
    List<String>? following,
    String? website,
    String? profilePicUrl,
    String? coverPicUrl,
  }) {
    return XUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      tweetCount: tweetCount ?? this.tweetCount,
      likesCount: likesCount ?? this.likesCount,
      location: location ?? this.location,
      joined: joined ?? this.joined,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      website: website ?? this.website,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      coverPicUrl: coverPicUrl ?? this.coverPicUrl,
    );
  }
}
