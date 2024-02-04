import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/widgets/auth_button.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_two.dart';
import 'package:x_clone/services/signin_method/sign_in_method.dart';
import 'package:x_clone/utils/utils.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/common/x_appbar.dart';
import '../../../theme/theme.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isObscure = true;

  void signUp(BuildContext context) {
    ref.read(authControllerProvider.notifier).signUp(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return isLoading
        ? const XLoader()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: XWidgets.appBar(
              leading: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Form(
                key: _formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VerticalSpacing(size: 10),
                    Text(
                      "Create an account",
                      style: kTextStyle(35, ref, fontWeight: FontWeight.bold)
                          .copyWith(
                        letterSpacing: 1,
                      ),
                    ),
                    VerticalSpacing(size: 25),
                    Column(
                      children: [
                        TextFormField(
                          focusNode: focusNode1,
                          controller: emailController,
                          decoration: InputDecoration(
                            label: Text(
                              "Email",
                              style: kTextStyle(15, ref, color: Colors.grey),
                            ),
                            labelStyle:
                                kTextStyle(15, ref, color: AppColors.blueColor),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.blueColor,
                                width: 2,
                              ),
                            ),
                            focusColor: AppColors.blueColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            border: const OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            focusNode1.unfocus();
                            FocusScope.of(context).requestFocus(focusNode2);
                          },
                          validator: (email) {
                            if (email!.isEmpty) {
                              return "email cannot be empty";
                            } else if (!isValidEmail(emailController.text)) {
                              return "Not a valid email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        VerticalSpacing(size: 20),
                        TextFormField(
                          focusNode: focusNode2,
                          obscureText: isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            errorMaxLines: 4,
                            label: Text(
                              "Password",
                              style: kTextStyle(15, ref, color: Colors.grey),
                            ),
                            labelStyle:
                                kTextStyle(15, ref, color: AppColors.blueColor),
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
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            focusNode2.unfocus();
                          },
                          validator: (password) {
                            if (passwordController.text.isEmpty) {
                              return "password cannot be empty";
                            } else if (!isValidPassword(
                                passwordController.text)) {
                              return 'password must be 8 charcters long and must contain at least one lowercase letter, one uppercase letter, one digit and one symbol';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                    VerticalSpacing(size: context.screenWidth * .2),
                    const SignUpTermsTwo(),
                    ListenableBuilder(
                      listenable: Listenable.merge(
                        [
                          emailController,
                          passwordController,
                        ],
                      ),
                      builder: (_, __) {
                        bool isEnabled = isValidEmail(emailController.text) &&
                            isValidPassword(passwordController.text);
                        return AuthButton(
                          label: "Sign up",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                signUp(context);
                                ref.read(signInMethodProvider).saveAsDefault();
                              } catch (e) {
                                log(e.toString());
                              }
                            } else {
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
                              });
                            }
                          },
                          bgColor:
                              isEnabled ? AppColors.blueColor : Colors.grey,
                          fgColor: Colors.white,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
