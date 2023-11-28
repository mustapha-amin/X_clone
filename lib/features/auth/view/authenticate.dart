import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/widgets/auth_button.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_one.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_two.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/textstyle.dart';
import '../../../constants/svg_paths.dart';
import '../../../utils/spacing.dart';
import '../widgets/divider.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                onPressed: () {},
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
