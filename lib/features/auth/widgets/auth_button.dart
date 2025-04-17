import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/utils/textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:x_clone/utils/utils.dart';

class AuthButton extends ConsumerWidget {
  VoidCallback? onPressed;
  String? label;
  Widget? icon;
  Color? bgColor;
  Color? fgColor;

  AuthButton({
    this.label,
    this.onPressed,
    this.bgColor,
    this.fgColor,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.white,
            side: label == "Sign in"
                ? BorderSide(color: Colors.grey[700]!)
                : null,
          ),
          onPressed: onPressed,
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              Text(
                label!,
                style: kTextStyle(
                  16,
                  ref,
                  color: fgColor ?? Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).padY(10),
        ),
      ),
    );
  }
}
