import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/utils/dialog.dart';

final googleAuthServiceProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return GoogleAuthService(
    googleSignIn: googleSignIn,
    firebaseAuth: firebaseAuth,
  );
});

class GoogleAuthService {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  GoogleAuthService({
    required this.googleSignIn,
    required this.firebaseAuth,
  });

  FutureVoid googleLogin(BuildContext? context) async {
    try {
      final googleAcct = await googleSignIn.signIn();

      final googleAuth = await googleAcct!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showErrorDialog(context: context, message: e.message);
    }
  }

  FutureVoid googleSignOut() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
