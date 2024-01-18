import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/nav%20bar/nav_bar.dart';
import 'package:x_clone/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/core.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool theme = ref.watch(themeNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      home: Sizer(
        builder: (context, _, __) {
          return ref.watch(authChangesProvider).when(
                data: (user) {
                  if (user != null) {
                    return const XBottomNavBar();
                  } else {
                     return const Authenticate();
                  }
                 
                },
                error: (_, __) => const Authenticate(),
                loading: () => const XLoader(),
              );
        },
      ),
    );
  }
}
