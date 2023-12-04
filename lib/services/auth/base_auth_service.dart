import 'package:firebase_auth/firebase_auth.dart';
import 'package:x_clone/core/typedefs.dart';

abstract class BaseAuthService {
  FutureEither<UserCredential> signUp({
    required String email,
    required String password,
  });

  FutureEither<UserCredential> signIn({
    required String email,
    required String password,
  });

  FutureVoid signOut();
}
