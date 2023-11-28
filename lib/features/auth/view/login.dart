import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

import '../../../constants/svg_paths.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ListView(
                children: [
                  VerticalSpacing(size: 10),
                  Text(
                    "Log In",
                    style: kTextStyle(35, fontWeight: FontWeight.bold).copyWith(
                      letterSpacing: 1,
                    ),
                  ),
                  VerticalSpacing(size: 25),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      label: Text(
                        "Phone, email or username",
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
                ],
              ),
            ),
          ),
          SizedBox(
            height: context.screenHeight * .12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.5, color: Colors.white),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Forgot password?",
                          style: kTextStyle(15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: Text(
                          "Next",
                          style: kTextStyle(15,
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
