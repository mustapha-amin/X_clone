import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/core.dart';

final themeSettingsProvider = Provider((ref) {
  return ThemeSettings(
    sharedPreferences: ref.watch(sharedPrefsProvider)
  );
});

class ThemeSettings {
  SharedPreferences? sharedPreferences;

  ThemeSettings({this.sharedPreferences});

  FutureVoid toggleTheme(bool newValue) async {
    await sharedPreferences!.setBool('isDark', newValue);
  }

  bool isDark() {
    bool isDark = sharedPreferences!.getBool('isDark') ?? true;
    return isDark;
  }
}
