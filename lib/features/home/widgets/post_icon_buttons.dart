import 'package:flutter/material.dart';
import 'package:x_clone/utils/textstyle.dart';

class PostIconButton extends StatelessWidget {
  IconData? iconData;
  int? count;
  VoidCallback? callback;
  PostIconButton({super.key, this.iconData, this.count, this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(iconData),
          iconSize: 20,
          color: Colors.grey,
          onPressed: callback,
        ),
        count != null
            ? Text(
                '$count',
                style: kTextStyle(18),
              )
            : const SizedBox(),
      ],
    );
  }
}
