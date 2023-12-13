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
      children: [
        IconButton(
          icon: Icon(iconData),
          iconSize: 18,
          color: color,
          onPressed: callback,
        ),
        count != null
            ? Text(
                '$count',
                style: kTextStyle(
                  18,
                  ref,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
