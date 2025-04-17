import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/textstyle.dart';

class SignUpTermsOne extends ConsumerWidget {
  const SignUpTermsOne({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RichText(
      text: TextSpan(
        text: "By signing up, you agree to our ",
        style: kTextStyle(12, ref, color: Colors.grey[500]),
        children: [
          TextSpan(
            text: "Terms",
            style: kTextStyle(12, ref, color: Colors.blue),
          ),
          const TextSpan(text: ", "),
          TextSpan(
            text: "Privacy Policy, ",
            style: kTextStyle(12, ref, color: Colors.blue),
          ),
          const TextSpan(text: "including "),
          TextSpan(
            text: "Cookie Use",
            style: kTextStyle(12, ref, color: Colors.blue),
          ),
          const TextSpan(text: ".")
        ],
      ),
    );
  }
}
