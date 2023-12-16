import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_clone/core/core.dart';

final savedSearchesProvider = Provider((ref) {
  return SavedSearches(sharedprefs: ref.watch(sharedPrefsProvider));
});

class SavedSearches {
  SharedPreferences? sharedprefs;
  final String _recentSearchesKey = 'recent_searches';

  SavedSearches({this.sharedprefs});

  List<String> getRecentSearches() {
    return sharedprefs!.getStringList(_recentSearchesKey) ?? [];
  }

  FutureVoid addToRecentSearches(String query) async {
    List<String> recentSearches = getRecentSearches();
    if (!recentSearches.contains(query)) {
      recentSearches.add(query);
      await sharedprefs!.setStringList(_recentSearchesKey, recentSearches);
    }
  }

  FutureVoid clearRecentSearches() async {
    await sharedprefs!.setStringList(_recentSearchesKey, []);
  }
}
