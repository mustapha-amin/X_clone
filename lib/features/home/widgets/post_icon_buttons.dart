import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/utils/textstyle.dart';

class PostIconButton extends ConsumerWidget {
  IconData? iconData;
  int? count;
  VoidCallback? callback;
  Color? color;
  PostIconButton(
      {super.key, this.iconData, this.count, this.color, this.callback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 3,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
            onTap: callback,
            child: Icon(iconData, size: 18, color: color ?? Colors.grey[600])),
        count != null
            ? Text(
                '$count',
                style: kTextStyle(13, ref, color: Colors.grey[600]),
              )
            : const SizedBox(),
      ],
    );
  }
}
