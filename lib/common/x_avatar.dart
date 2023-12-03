import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/utils/utils.dart';

class XAvatar extends ConsumerWidget {
  const XAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(userProvider);
    return InkWell(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Text(
          user!.displayName![0],
          style: kTextStyle(20),
        )),
      ).padAll(10),
    );
  }
}
