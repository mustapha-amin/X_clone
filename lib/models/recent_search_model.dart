import 'package:uuid/uuid.dart';

class RecentSearch {
  String? id;
  String? query;

  RecentSearch._({this.id, this.query});

  factory RecentSearch({String? query}) {
    return RecentSearch._(
      id: const Uuid().v4(),
      query: query,
    );
  }

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch._(
      id: json['id'],
      query: json['query'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
    };
  }
}
