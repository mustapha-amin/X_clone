import 'package:flutter/material.dart';
import 'package:x_clone/utils/extensions.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          width: context.screenWidth * .38,
          height: 1,
          color: Colors.grey[800],
        ),
        const Text("or"),
        Container(
          margin: const EdgeInsets.only(left: 5),
          width: context.screenWidth * .38,
          height: 1,
          color: Colors.grey[800],
        ),
      ],
    );
  }
}
