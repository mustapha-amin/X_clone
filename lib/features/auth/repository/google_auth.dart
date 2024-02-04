import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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

  FutureEither<UserCredential> googleLogin(BuildContext? context) async {
    try {
      final googleAcct = await googleSignIn.signIn();

      final googleAuth = await googleAcct!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await firebaseAuth.signInWithCredential(credential);
      await firebaseAuth.currentUser!.updateEmail(userCred.user!.email!);
      return right(userCred);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(Failure(message: e.message!, stackTrace: stackTrace));
    }
  }

  FutureEither<String> googleSignOut() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
      return right("success");
    } catch (e, stackTrace) {
      log(e.toString());
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }
}
