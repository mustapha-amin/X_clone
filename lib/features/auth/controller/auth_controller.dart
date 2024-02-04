import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/services/signin_method/sign_in_method.dart';
import '../repository/auth_service.dart';
import '../repository/google_auth.dart';
import '/../utils/utils.dart';
import 'package:x_clone/features/nav bar/nav_bar.dart';

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
      (r) => {
        navigateAndReplace(context, const XBottomNavBar()),
        log("success"),
      },
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
      (r) => {
        navigateAndReplace(context, const XBottomNavBar()),
        log("successfully logged in"),
      },
    );
  }

  void signOut(BuildContext context) async {
    state = true;
    final res = await authService!.signOut();
    res.fold(
      (l) => showErrorDialog(context: context, message: l.message),
      (r) => {
        navigateAndReplace(context, const Authenticate()),
        log(r),
      },
    );
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

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    state = true;
    final res = await googleAuthService!.googleLogin(context);
    res.fold(
      (l) => showErrorDialog(context: context, message: l.message),
      (r) => {
        navigateAndReplace(context, const XBottomNavBar()),
        ref.read(signInMethodProvider).saveAsGoogle(),
      },
    );
  }

  void signOutWithGoogle(BuildContext context, WidgetRef ref) async {
    state = true;
    final res = await googleAuthService!.googleSignOut();
    res.fold(
      (l) => showErrorDialog(context: context, message: l.message),
      (r) => {
        log(r),
        navigateAndReplace(context, const Authenticate()),
      },
    );
    state = false;
  }
}
