import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/utils/textstyle.dart';
import '../constants/images_paths.dart';

class DrawerTile extends StatelessWidget {
  String? title;
  double? titleSize;
  IconData? iconData;
  VoidCallback? onTap;
  bool? _isX = false;

  DrawerTile(
      {this.title, this.iconData, this.onTap, this.titleSize, super.key});

  DrawerTile.withX({super.key, this.title, this.onTap, this.titleSize})
      : _isX = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        leading: _isX!
            ? SvgPicture.asset(
                ImagesPaths.x_icon,
                width: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            : Icon(iconData),
        title: Text(
          title!,
          style: kTextStyle(titleSize ?? 20, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
