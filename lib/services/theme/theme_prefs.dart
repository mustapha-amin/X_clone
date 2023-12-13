import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/core.dart';

final themeSettingsProvider = Provider((ref) {
  return ThemeSettings();
});


class ThemeSettings {
  static late SharedPreferences sharedPreferences;

  static FutureVoid initThemPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  FutureVoid toggleTheme(bool newValue) async {
    await sharedPreferences.setBool('isDark', newValue);
  }

  bool isDark() {
    bool isDark = sharedPreferences.getBool('isDark') ?? true;
    return isDark;
  }
}
