import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:x_clone/core/core.dart';

final googleAuthServiceProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return GoogleAuthService(
    googleSignIn: googleSignIn,
    firebaseAuth: auth,
  );
});

class GoogleAuthService {
  GoogleSignIn googleSignIn;
  FirebaseAuth? firebaseAuth;

  GoogleAuthService({
    required this.googleSignIn,
    required this.firebaseAuth,
  });

  FutureVoid googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await firebaseAuth!.signInWithCredential(credential);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  FutureVoid googleSignOut() async {
    try {
      await firebaseAuth!.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
