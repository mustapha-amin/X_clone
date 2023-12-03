import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x_clone/core/failure.dart';
import 'package:x_clone/core/providers.dart';
import 'package:x_clone/core/typedefs.dart';
import 'package:x_clone/services/base_auth_service.dart';

final authServiceProvider = Provider((ref) {
  final authProvider = ref.watch(firebaseAuthProvider);
  return AuthService(firebaseAuth: authProvider);
});

class AuthService extends BaseAuthService {
  final FirebaseAuth firebaseAuth;

  AuthService({required this.firebaseAuth});

  @override
  FutureEither<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(userCredential);
    } on FirebaseException catch (e, stackTrace) {
      String? error;
      if (e.code == 'user-not-found') {
        error = "User not found";
      } else if (e.code == "wrong-password") {
        error = "Incorrect password";
      } else if (e.code == "network-request-failed") {
        error = "A network error occured, check your internet settings";
      } else {
        error = e.message;
      }
      return left(Failure(message: error!, stackTrace: stackTrace));
    }
  }

  @override
  FutureEither<UserCredential> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCredential.user!.updateDisplayName(username);
      return right(userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      String? error;
      if (e.code == 'email-already-in-use') {
        error = "email already in use";
      } else if (e.code == "network-request-failed") {
        error = "A network occured, check your internet settings";
      } else {
        error = e.message.toString();
      }
      return left(Failure(message: error, stackTrace: stackTrace));
    }
  }

  @override
  FutureVoid signOut() async {
    await firebaseAuth.signOut();
  }
}
