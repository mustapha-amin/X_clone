import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/recent_search_model.dart';

final exploreRepositoryProvider = Provider((ref) {
  return ExploreRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class ExploreRepository {
  final FirebaseFirestore firebaseFirestore;
  String recentSearchesCollection = 'recentSearchesCollection';

  ExploreRepository({required this.firebaseFirestore});

  FutureVoid saveSearch(RecentSearch recentSearch) async {
    await firebaseFirestore
        .collection(recentSearchesCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentSearches')
        .doc(recentSearch.id)
        .set(recentSearch.toJson());
  }

  Stream<List<RecentSearch>> fetchSearches() {
    return firebaseFirestore
        .collection(recentSearchesCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentSearches')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => RecentSearch.fromJson(doc.data())).toList());
  }

  FutureVoid deleteSearch(String id) async {
    await firebaseFirestore
        .collection(recentSearchesCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentSearches')
        .doc(id)
        .delete();
  }

  FutureVoid clearSearches() async {
    final snaps = await firebaseFirestore
        .collection(recentSearchesCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentSearches')
        .get();

    for (final snap in snaps.docs) {
      await snap.reference.delete();
    }
  }
}
