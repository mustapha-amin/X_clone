import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/services/user_data_db/saved_searches.dart';
import 'package:x_clone/services/user_data_db/user_data_service.dart';

import '../../../core/typedefs.dart';

final searchUsersProvider =
    StreamProvider.family<List<XUser>, String>((ref, name) {
  return ref.read(userDataServiceProvider).searchUser(name);
});

final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier(savedSearches: ref.watch(savedSearchesProvider));
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  SavedSearches? savedSearches;
  RecentSearchesNotifier({this.savedSearches}) : super([]) {
    state = savedSearches!.getRecentSearches();
  }

  void saveSearch(String query) async {
    await savedSearches!.addToRecentSearches(query);
    state = savedSearches!.getRecentSearches();
  }

  List<String> getRecentSearches() {
    return state;
  }

  FutureVoid clearSearches() async {
    await savedSearches!.clearRecentSearches();
    state = [];
  }
}
