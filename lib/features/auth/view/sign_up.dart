import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:x_clone/features/auth/widgets/auth_button.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_two.dart';
import 'package:x_clone/utils/extensions.dart';

import '../../../constants/svg_paths.dart';
import '../../../theme/pallete.dart';
import '../../../utils/spacing.dart';
import '../../../utils/textstyle.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          SvgPaths.x_icon,
          color: Colors.white,
          width: 28,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpacing(size: 10),
              Text(
                "Create an account",
                style: kTextStyle(35, fontWeight: FontWeight.bold).copyWith(
                  letterSpacing: 1,
                ),
              ),
              VerticalSpacing(size: 25),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  label: Text(
                    "Email",
                    style: kTextStyle(15, color: Colors.grey),
                  ),
                  labelStyle: kTextStyle(15, color: AppColors.blueColor),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.blueColor,
                      width: 2,
                    ),
                  ),
                  focusColor: AppColors.blueColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: const OutlineInputBorder(),
                ),
              ),
              VerticalSpacing(size: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  label: Text(
                    "Username",
                    style: kTextStyle(15, color: Colors.grey),
                  ),
                  labelStyle: kTextStyle(15, color: AppColors.blueColor),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.blueColor,
                      width: 2,
                    ),
                  ),
                  focusColor: AppColors.blueColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: const OutlineInputBorder(),
                ),
              ),
              VerticalSpacing(size: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  label: Text(
                    "Password",
                    style: kTextStyle(15, color: Colors.grey),
                  ),
                  labelStyle: kTextStyle(15, color: AppColors.blueColor),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.blueColor,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {},
                  ),
                  focusColor: AppColors.blueColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: const OutlineInputBorder(),
                ),
              ),
              VerticalSpacing(size: context.screenWidth * .2),
              const SignUpTermsTwo(),
              AuthButton(
                label: "Sign up",
                onPressed: () {},
                bgColor: AppColors.blueColor,
                fgColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
