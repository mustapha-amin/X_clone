import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/home/home.dart';
import 'package:x_clone/services/auth_service.dart';
import 'package:x_clone/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: user.when(
        data: (userData) =>
            userData != null ? const HomeScreen() : const Authenticate(),
        error: (_, __) => const ErrorScreen(),
        loading: () => const XLoader(),
      ),
    );
  }
}
