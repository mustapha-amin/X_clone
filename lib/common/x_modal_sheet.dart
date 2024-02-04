import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/services/signin_method/sign_in_method.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/textstyle.dart';
import '../features/auth/controller/auth_controller.dart';

class XBtmModalSheet extends ConsumerStatefulWidget {
  const XBtmModalSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _XBtmModalSheetState();
}

class _XBtmModalSheetState extends ConsumerState<XBtmModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: context.screenWidth,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: context.screenWidth * .1,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ).padAll(10),
          SizedBox(
            width: context.screenWidth * .7,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final bool isGoogleSignIn =
                    ref.watch(signInMethodProvider).signInMethodIsGoogle()!;
                isGoogleSignIn
                    ? ref
                        .read(googleAuthProvider.notifier)
                        .signOutWithGoogle(context, ref)
                    : ref
                        .read(authControllerProvider.notifier)
                        .signOut(context);
              },
              child: Text(
                "Sign out",
                style: kTextStyle(18, ref, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
