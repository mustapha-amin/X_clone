import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/nav%20bar/nav_bar.dart';
import 'package:x_clone/services/services.dart';
import 'package:x_clone/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/core.dart';
import 'firebase_options.dart';

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
    AsyncValue<User?> authChanges = ref.watch(authChangesProvider);
    var theme = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme == true ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      home: authChanges.when(
        data: (user) {
          if (user != null) {
            return const Wrapper();
          } else {
            return const Authenticate();
          }
        },
        error: (_, __) => const ErrorScreen(),
        loading: () => const XLoader(),
      ),
    );
  }
}

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(xUserDetailExistsProvider);
    return userDetail.when(
      data: (data) =>
          data == true ? const XBottomNavBar() : const UserDetails(),
      error: (_, __) => const ErrorScreen(),
      loading: () => const XLoader(),
    );
  }
}
