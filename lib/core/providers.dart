import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/theme/theme_prefs.dart';
import 'core.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final googleSignInProvider = Provider((ref) => GoogleSignIn());
final authChangesProvider =
    StreamProvider((ref) => ref.watch(firebaseAuthProvider).authStateChanges());
final userProvider =
    Provider((ref) => ref.watch(firebaseAuthProvider).currentUser);

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);
final uidProvider =  Provider((ref) {
  return FirebaseAuth.instance.currentUser!.uid;
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(
    themeSettings: ref.watch(themeSettingsProvider),
  );
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeSettings? themeSettings;

  ThemeNotifier({this.themeSettings}) : super(themeSettings!.isDark());

  FutureVoid toggleTheme() async {
    state = !state;
    await themeSettings!.toggleTheme(state);
  }
}
