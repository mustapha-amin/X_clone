import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/utils/utils.dart';

class XAvatar extends ConsumerWidget {
  bool? forDrawer;
  XAvatar({this.forDrawer = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(currentUserProvider);
    return GestureDetector(
      onTap: () => Scaffold.of(context).openEndDrawer(),
      child: CircleAvatar(
        radius: forDrawer! ? 23 : 20,
        backgroundImage: user.when(
          data: (user) => NetworkImage(user!.profilePicUrl!),
          error: (_, __) => null,
          loading: () => null,
        ),
        child: user.when(
          data: (_) => null,
          error: (_, __) => const Icon(Icons.error),
          loading: () => const CircularProgressIndicator(),
        ),
      ).padAll(10),
    );
  }
}
