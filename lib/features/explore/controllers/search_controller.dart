import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/explore/repository/explore_repository.dart';
import 'package:x_clone/models/recent_search_model.dart';
import 'package:x_clone/models/user_model.dart';
import '../../auth/repository/user_data_service.dart';

final searchUsersProvider =
    StreamProvider.autoDispose.family<List<XUser>, String>((ref, name) {
  return ref.read(userDataServiceProvider).searchUser(name);
});

final saveSearchProvider =
    FutureProvider.family<void, RecentSearch>((ref, recentSearch) async {
  final exploreProvider = ref.watch(exploreRepositoryProvider);
  await exploreProvider.saveSearch(recentSearch);
});

final fetchSearchesProvider = StreamProvider((ref) {
  final exploreProvider = ref.watch(exploreRepositoryProvider);
  return exploreProvider.fetchSearches();
});

final deleteSearchProvider =
    FutureProvider.family<void, String>((ref, id) async {
  final exploreProvider = ref.watch(exploreRepositoryProvider);
  await exploreProvider.deleteSearch(id);
});

final clearSearchesProvider = FutureProvider((ref) async {
  final exploreProvider = ref.watch(exploreRepositoryProvider);
  await exploreProvider.clearSearches();
});
