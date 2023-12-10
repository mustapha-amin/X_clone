import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

class XFab extends ConsumerWidget {
  VoidCallback? onTap;
  IconData? iconData;
  String? label;
  Color? fgColor;
  Color? bgColor;
  bool? isMain;
  XFab({
    this.onTap,
    this.iconData,
    this.label,
    this.bgColor = Colors.white,
    this.fgColor = AppColors.blueColor,
    this.isMain = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        label == null
            ? const SizedBox()
            : Text(
                label!,
                style: kTextStyle(
                  15,
                   ref,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
        HorizontalSpacing(size: 15),
        isMain!
            ? FloatingActionButton(
                backgroundColor: bgColor,
                onPressed: onTap,
                shape: const CircleBorder(),
                child: Icon(
                  iconData!,
                  color: fgColor,
                ),
              )
            : FloatingActionButton.small(
                backgroundColor: bgColor,
                onPressed: onTap,
                shape: const CircleBorder(),
                child: Icon(
                  iconData!,
                  color: fgColor,
                ),
              )
      ],
    );
  }
}
