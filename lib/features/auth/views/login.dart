import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_appbar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/services/signin_method/sign_in_method.dart';
import 'package:x_clone/theme/theme.dart';
import 'package:x_clone/utils/utils.dart';
import 'dart:developer';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return isLoading
        ? const XLoader()
        : Scaffold(
            appBar: XWidgets.appBar(
              leading: BackButton(
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
                    child: Form(
                      autovalidateMode: autovalidateMode,
                      key: _formKey,
                      child: ListView(
                        children: [
                          VerticalSpacing(size: 10),
                          Text(
                            "Log In",
                            style:
                                kTextStyle(35, ref, fontWeight: FontWeight.bold)
                                    .copyWith(
                              letterSpacing: 1,
                            ),
                          ),
                          VerticalSpacing(size: 25),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              label: Text(
                                "email",
                                style: kTextStyle(15, ref, color: Colors.grey),
                              ),
                              labelStyle: kTextStyle(15, ref,
                                  color: AppColors.blueColor),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.blueColor,
                                  width: 2,
                                ),
                              ),
                              focusColor: AppColors.blueColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (email) {
                              if (email!.isEmpty) {
                                return "email cannot be empty";
                              } else if (!isValidEmail(email)) {
                                return "Not a valid email";
                              } else {
                                return null;
                              }
                            },
                          ),
                          VerticalSpacing(size: 20),
                          TextFormField(
                            obscureText: isObscure,
                            controller: passwordController,
                            decoration: InputDecoration(
                              label: Text(
                                "password",
                                style: kTextStyle(15, ref, color: Colors.grey),
                              ),
                              labelStyle: kTextStyle(15, ref,
                                  color: AppColors.blueColor),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.blueColor,
                                  width: 2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                              focusColor: AppColors.blueColor,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (password) {
                              if (password!.isEmpty) {
                                return "password cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.screenHeight * .12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 1.5, color: Colors.white),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Forgot password?",
                                style: kTextStyle(15, ref,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ListenableBuilder(
                              listenable: Listenable.merge(
                                [emailController, passwordController],
                              ),
                              builder: (_, __) {
                                bool? isEnabled =
                                    emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty;
                                return ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        isEnabled ? Colors.white : Colors.grey,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .signIn(
                                              context: context,
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                        ref
                                            .read(signInMethodProvider)
                                            .saveAsDefault();
                                      } catch (e) {
                                        log(e.toString());
                                      }
                                    } else {
                                      setState(() {
                                        autovalidateMode =
                                            AutovalidateMode.always;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Next",
                                    style: kTextStyle(15, ref,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                );
                              },
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
