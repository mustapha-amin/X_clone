import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class AuthButton extends ConsumerWidget {
  VoidCallback? onPressed;
  String? label;
  bool? isGoogle;
  Color? bgColor;
  Color? fgColor;

  AuthButton({
    this.label,
    this.onPressed,
    this.bgColor,
    this.fgColor,
    this.isGoogle = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 7.h,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.white,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment:
                isGoogle! ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              isGoogle!
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        ImagesPaths.google,
                      ),
                    )
                  : const SizedBox(),
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
          ),
        ),
      ),
    );
  }
}
