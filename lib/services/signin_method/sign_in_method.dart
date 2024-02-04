import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_clone/core/core.dart';

final signInMethodProvider = Provider((ref) {
  return SignInMethod(sharedprefs: ref.watch(sharedPrefsProvider));
});

class SignInMethod {
  SharedPreferences? sharedprefs;
  final String _signInKey = 'sign_in_method';

  SignInMethod({this.sharedprefs});

  bool? signInMethodIsGoogle() {
    return sharedprefs!.getString(_signInKey) == 'google';
  }

  FutureVoid saveAsGoogle() async {
    await sharedprefs!.setString(_signInKey, 'google');
    log("google sign in");
  }

  Future saveAsDefault() async {
    await sharedprefs!.setString(_signInKey, 'default');
    log("default sign in");
  }
}
