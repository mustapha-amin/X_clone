import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/typedefs.dart';

final themeSettingsProvider = Provider((ref) {
  return ThemeSettings();
});

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(
    themeSettings: ref.watch(themeSettingsProvider),
  );
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeSettings? themeSettings;

  ThemeNotifier({this.themeSettings}) : super(themeSettings!.isDark());

  FutureVoid toggleTheme(bool newValue) async {
    await themeSettings!.toggleTheme(newValue);
    state = newValue;
  }
}

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
