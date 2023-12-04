import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/widgets/auth_button.dart';
import 'package:x_clone/features/auth/widgets/signup_terms_two.dart';
import 'package:x_clone/features/home/home.dart';
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
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ValueNotifier<bool> emailFieldTapped = ValueNotifier(false);
  ValueNotifier<bool> usernameFieldTapped = ValueNotifier(false);
  ValueNotifier<bool> passwordFieldTapped = ValueNotifier(false);
  ValueNotifier<String?> emailErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> passwordErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> usernameErrorText = ValueNotifier<String?>(null);
  bool isObscure = true;

  void displayEmailError() {
    if (isValidEmail(emailController.text)) {
      emailErrorText.value = null;
    } else if (emailController.text.isEmpty) {
      emailErrorText.value = "email cannot be empty";
    } else if (!isValidEmail(emailController.text)) {
      emailErrorText.value = "Not a valid email";
    }
  }

  toggleFieldsTapped() {
    emailFieldTapped.value = true;
    passwordFieldTapped.value = true;
    usernameFieldTapped.value = true;
  }

  void displayPasswordError() {
    if (isValidPassword(passwordController.text)) {
      passwordErrorText.value = null;
    } else if (passwordController.text.isEmpty) {
      passwordErrorText.value = "password cannot be empty";
    } else if (!isValidPassword(passwordController.text)) {
      passwordErrorText.value =
          'password must be 8 charcters long and must contain at least one lowercase letter, one uppercase letter, one digit and one symbol';
    }
  }

  void displayUsernameError() {
    if (usernameController.text.isEmpty) {
      usernameErrorText.value = "username cannot be empty";
    } else {
      usernameErrorText.value = null;
    }
  }

  void signUp() {
    ref.read(authControllerProvider.notifier).signUp(
        context: context,
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return isLoading
        ? const XLoader()
        : Scaffold(
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      VerticalSpacing(size: 10),
                      Text(
                        "Create an account",
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
                              "Email",
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
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
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
                        valueListenable: usernameErrorText,
                        builder: (context, error, _) => TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            label: Text(
                              "Username",
                              style: kTextStyle(15, color: Colors.grey),
                            ),
                            errorText: error,
                            labelStyle:
                                kTextStyle(15, color: AppColors.blueColor),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 46, 88, 116),
                                width: 2,
                              ),
                            ),
                            focusColor: AppColors.blueColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (_) {
                            if (usernameFieldTapped.value) {
                              displayUsernameError();
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
                            errorText: error,
                            errorMaxLines: 4,
                            label: Text(
                              "Password",
                              style: kTextStyle(15, color: Colors.grey),
                            ),
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
                      VerticalSpacing(size: context.screenWidth * .2),
                      const SignUpTermsTwo(),
                      AuthButton(
                        label: "Sign up",
                        onPressed: () {
                          if (isValidEmail(emailController.text) &&
                              isValidPassword(passwordController.text) &&
                              usernameController.text.isNotEmpty) {
                            try {
                              signUp();
                              navigateAndReplace(context, const UserDetails());
                            } catch (e) {}
                          } else {
                            toggleFieldsTapped();
                            displayEmailError();
                            displayPasswordError();
                            displayUsernameError();
                          }
                        },
                        bgColor: AppColors.blueColor,
                        fgColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
