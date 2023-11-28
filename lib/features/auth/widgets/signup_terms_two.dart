import 'package:flutter/material.dart';

import '../../../utils/textstyle.dart';

class SignUpTermsTwo extends StatelessWidget {
  const SignUpTermsTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "By signing up, you agree to our ",
        style: kTextStyle(12, color: Colors.grey[500]),
        children: [
          TextSpan(
            text: "Terms",
            style: kTextStyle(12, color: Colors.blue),
          ),
          const TextSpan(text: ", "),
          TextSpan(
            text: "Privacy Policy, ",
            style: kTextStyle(12, color: Colors.blue),
          ),
          const TextSpan(text: "and "),
          TextSpan(
            text: "Cookie Use",
            style: kTextStyle(12, color: Colors.blue),
          ),
          const TextSpan(text: "."),
          const TextSpan(
            text:
                "X may use your contact address and phone number for purposes outlined in our Privacy Policy, like keeping"
                "your account secure and personalizing our services, including ads.",
          ),
          TextSpan(
            text: "Learn more.",
            style: kTextStyle(12, color: Colors.blue),
          ),
          const TextSpan(
            text:
                "Others will be able to find you by email or phone number, when provided,"
                "unless otherwise ",
          ),
          TextSpan(
            text: "here",
            style: kTextStyle(12, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
