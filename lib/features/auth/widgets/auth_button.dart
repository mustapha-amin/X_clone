import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/constants/svg_paths.dart';
import 'package:x_clone/utils/textstyle.dart';

class AuthButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.white,
          ),
          onPressed:  onPressed,
          child: Row(
            mainAxisAlignment:
                isGoogle! ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              isGoogle!
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        SvgPaths.google,
                      ),
                    )
                  : const SizedBox(),
              Text(
                label!,
                style: kTextStyle(
                  16,
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
