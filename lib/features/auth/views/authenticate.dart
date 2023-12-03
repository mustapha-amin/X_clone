import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/auth/widgets/auth_button.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_one.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_two.dart';
import 'package:x_clone/services/google_auth.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/textstyle.dart';
import '../../../constants/svg_paths.dart';
import '../../../utils/spacing.dart';
import '../widgets/divider.dart';

class Authenticate extends ConsumerStatefulWidget {
  const Authenticate({super.key});

  @override
  ConsumerState<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends ConsumerState<Authenticate> {
  void signInGoogle(BuildContext context) {
    ref.read(googleAuthProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    bool isLoadingGoogle = ref.watch(googleAuthProvider);
    return Scaffold(
      body: isLoading || isLoadingGoogle
          ? const XLoader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerticalSpacing(size: context.screenHeight * .05),
                    Center(
                      child: SvgPicture.asset(
                        SvgPaths.x_icon,
                        color: Colors.white,
                        width: 25,
                      ),
                    ),
                    VerticalSpacing(size: context.screenHeight * .15),
                    Text(
                      "See what's\nhappening in the\nworld right now.",
                      style: kTextStyle(28, fontWeight: FontWeight.bold),
                    ),
                    VerticalSpacing(size: context.screenHeight * .15),
                    AuthButton(
                      label: "Continue with google",
                      isGoogle: true,
                      onPressed: () => signInGoogle(context),
                    ),
                    const AuthDivider(),
                    AuthButton(
                      label: "Create account",
                      onPressed: () {
                        navigateTo(context, const SignUp());
                      },
                    ),
                    VerticalSpacing(size: 15),
                    const SignUpTermsOne(),
                    VerticalSpacing(size: context.screenWidth * .15),
                    RichText(
                      text: TextSpan(
                        style: kTextStyle(13, color: Colors.grey[700]),
                        text: "Have an account already? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => navigateTo(
                                    context,
                                    const LogIn(),
                                  ),
                            text: "Log in",
                            style: kTextStyle(13, color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
