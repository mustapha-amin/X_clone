import 'package:flutter/material.dart';
import 'package:x_clone/theme/app_theme.dart';

import 'features/auth/view/authenticate.dart';

void main() {
  runApp(const MyApp(
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme(),
      home: const Authentication(),
    );
  }
}