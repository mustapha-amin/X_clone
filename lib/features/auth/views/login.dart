import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_appbar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/home/home.dart';
import 'package:x_clone/theme/theme.dart';
import 'package:x_clone/utils/utils.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> emailFieldTapped = ValueNotifier(false);
  ValueNotifier<bool> passwordFieldTapped = ValueNotifier(false);
  ValueNotifier<String?> emailErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> passwordErrorText = ValueNotifier<String?>(null);
  bool isObscure = true;

  void displayEmailError() {
    if (emailController.text.isEmpty) {
      emailErrorText.value = "email cannot be empty";
    } else if (!isValidEmail(emailController.text)) {
      emailErrorText.value = "Not a valid email";
    } else if (isValidEmail(emailController.text)) {
      emailErrorText.value = null;
    }
  }

  toggleFieldsTapped() {
    emailFieldTapped.value = true;
    passwordFieldTapped.value = true;
  }

  void displayPasswordError() {
    if (passwordController.text.isEmpty) {
      passwordErrorText.value = "password cannot be empty";
    } else {
      passwordErrorText.value = null;
    }
  }

  void signIn() {
    ref.read(authControllerProvider.notifier).signIn(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  void initState() {
    super.initState();
  }

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
                      key: _formKey,
                      child: ListView(
                        children: [
                          VerticalSpacing(size: 10),
                          Text(
                            "Log In",
                            style: kTextStyle(35, fontWeight: FontWeight.bold)
                                .copyWith(
                              letterSpacing: 1,
                            ),
                          ),
                          VerticalSpacing(size: 25),
                          ValueListenableBuilder(
                            valueListenable: emailErrorText,
                            builder: (context, error, _) => TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                label: Text(
                                  "email",
                                  style: kTextStyle(15, color: Colors.grey),
                                ),
                                errorText: error,
                                labelStyle:
                                    kTextStyle(15, color: AppColors.blueColor),
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
                              onChanged: (_) {
                                if (emailFieldTapped.value) {
                                  displayEmailError();
                                }
                              },
                            ),
                          ),
                          VerticalSpacing(size: 20),
                          ValueListenableBuilder(
                            valueListenable: passwordErrorText,
                            builder: (context, error, _) => TextFormField(
                              obscureText: isObscure,
                              controller: passwordController,
                              decoration: InputDecoration(
                                label: Text(
                                  "password",
                                  style: kTextStyle(15, color: Colors.grey),
                                ),
                                errorText: error,
                                labelStyle:
                                    kTextStyle(15, color: AppColors.blueColor),
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
                              onChanged: (_) {
                                if (passwordFieldTapped.value) {
                                  displayPasswordError();
                                }
                              },
                            ),
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
                                style:
                                    kTextStyle(15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                if (isValidEmail(emailController.text) &&
                                    passwordController.text.isNotEmpty) {
                                  try {
                                    signIn();
                                    navigateAndReplace(context, const HomeScreen());
                                  } catch (e) {}
                                } else {
                                  toggleFieldsTapped();
                                  displayEmailError();
                                  displayPasswordError();
                                }
                              },
                              child: Text(
                                "Next",
                                style: kTextStyle(15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
