import 'package:flutter/material.dart';
import 'package:x_clone/theme/pallete.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkModeColor,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkModeColor),
      iconTheme: const IconThemeData(color: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.blueColor,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blueColor,
        brightness: Brightness.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightModeColor),
      scaffoldBackgroundColor: AppColors.lightModeColor,
      iconTheme: const IconThemeData(color: Colors.black),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.blueColor,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blueColor,
        brightness: Brightness.light,
      ),
    );
  }
}
