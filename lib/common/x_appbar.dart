import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/svg_paths.dart';

class XWidgets {
  static AppBar appBar({required Widget leading}) {
    return AppBar(
      title: SvgPicture.asset(
        SvgPaths.x_icon,
        color: Colors.white,
        width: 28,
      ),
      centerTitle: true,
      leading: leading,
    );
  }
}
