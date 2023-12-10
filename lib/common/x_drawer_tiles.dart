import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/services/services.dart';
import 'package:x_clone/utils/textstyle.dart';
import '../constants/images_paths.dart';

class DrawerTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(themeNotifierProvider);
    return SizedBox(
      child: ListTile(
        leading: _isX!
            ? SvgPicture.asset(
                ImagesPaths.x_icon,
                width: 20,
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              )
            : Icon(iconData),
        title: Text(
          title!,
          style: kTextStyle(titleSize ?? 20, ref, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
