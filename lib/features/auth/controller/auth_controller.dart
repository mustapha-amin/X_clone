import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/services/auth/google_auth.dart';
import '/../services/services.dart';
import '/../utils/utils.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authService: ref.watch(authServiceProvider),
  );
});

final googleAuthProvider =
    StateNotifierProvider<GoogleAuthContoller, bool>((ref) {
  return GoogleAuthContoller(
    googleAuthService: ref.watch(googleAuthServiceProvider),
    authService: ref.watch(authServiceProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  AuthService? authService;

  AuthController({required this.authService}) : super(false);

  void signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await authService!
        .signIn(email: email.trim(), password: password.trim());
    state = false;
    res.fold(
      (l) => showErrorDialog(context: context, message: l.message),
      (r) => print(r.user!.displayName),
    );
  }

  void signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await authService!.signUp(
      email: email.trim(),
      password: password.trim(),
    );
    state = false;
    res.fold(
      (l) => showErrorDialog(context: context, message: l.message),
      (r) => print(r.user!.displayName),
    );
  }

  void signOut() async {
    state = true;
    await authService!.signOut();
    state = false;
  }
}

class GoogleAuthContoller extends StateNotifier<bool> {
  GoogleAuthService? googleAuthService;
  AuthService? authService;

  GoogleAuthContoller({
    this.googleAuthService,
    this.authService,
  }) : super(false);

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final res = await googleAuthService!.googleLogin();
    state = false;
  }

  void signOutWithGoogle() async {
    state = true;
    await googleAuthService!.googleSignOut();
    await authService!.signOut();
    state = false;
  }
}
