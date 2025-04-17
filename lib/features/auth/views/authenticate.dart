import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/auth/widgets/auth_button.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_one.dart';
import 'package:x_clone/services/signin_method/sign_in_method.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/textstyle.dart';
import '../../../constants/images_paths.dart';
import '../../../utils/spacing.dart';
import '../widgets/divider.dart';

class Authenticate extends ConsumerStatefulWidget {
  const Authenticate({super.key});

  @override
  ConsumerState<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends ConsumerState<Authenticate> {
  void signInGoogle(BuildContext context, WidgetRef ref) {
    ref.read(googleAuthProvider.notifier).signInWithGoogle(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    bool isLoadingGoogle = ref.watch(googleAuthProvider);
    return Scaffold(
      appBar: AppBar(),
      body: isLoading || isLoadingGoogle
          ? const XLoader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagesPaths.x_icon,
                          width: 50,
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ],
                    ),
                    VerticalSpacing(size: 50),
                    Text("Happening\nnow",
                        style:
                            kTextStyle(50, ref, fontWeight: FontWeight.bold)),
                    VerticalSpacing(size: context.screenHeight * .05),
                    Text(
                      "Join today.",
                      style: kTextStyle(30, ref, fontWeight: FontWeight.bold),
                    ),
                    AuthButton(
                      label: "Sign up with Google",
                      icon: SvgPicture.asset(
                        ImagesPaths.google,
                        width: 30,
                      ),
                      onPressed: () {
                        signInGoogle(context, ref);
                      },
                    ),
                    AuthButton(
                      label: "Sign up with Apple",
                      icon: Icon(
                        Icons.apple,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    const AuthDivider(),
                    AuthButton(
                      label: "Create account",
                      bgColor: Colors.blue,
                      fgColor: Colors.white,
                      onPressed: () {
                        navigateTo(context, const SignUp());
                      },
                    ),
                    VerticalSpacing(size: 15),
                    const SignUpTermsOne(),
                    VerticalSpacing(size: context.screenWidth * .15),
                    Text(
                      "Already have an account?",
                      style: kTextStyle(20, ref, fontWeight: FontWeight.bold),
                    ),
                    AuthButton(
                      label: "Sign in",
                      bgColor: Colors.black,
                      fgColor: Colors.blue,
                      onPressed: () {
                        navigateAndReplace(context, LogIn());
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
