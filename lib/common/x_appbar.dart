import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/images_paths.dart';

class XWidgets {
  static AppBar appBar({required Widget leading}) {
    return AppBar(
      title: SvgPicture.asset(
        ImagesPaths.x_icon,
        colorFilter: const ColorFilter.mode( Colors.white, BlendMode.srcIn),
        width: 28,
      ),
      centerTitle: true,
      leading: leading,
    );
  }
}
