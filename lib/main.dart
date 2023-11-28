import 'package:flutter/material.dart';
import 'package:x_clone/features/auth/view/login.dart';
import 'package:x_clone/theme/app_theme.dart';

import 'features/auth/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: const LogIn(),
    );
  }
}
