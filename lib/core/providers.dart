import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final googleSignInProvider = Provider((ref) => GoogleSignIn());
final authChangesProvider =
    StreamProvider((ref) => ref.watch(firebaseAuthProvider).authStateChanges());
final userProvider =
    Provider((ref) => ref.watch(firebaseAuthProvider).currentUser);
final scaffoldKeyProvider = Provider((ref) {
  return GlobalKey<ScaffoldState>();
});
