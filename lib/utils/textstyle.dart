import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/core.dart';
import 'package:sizer/sizer.dart';

TextStyle kTextStyle(
  double size,
  WidgetRef? ref, {
  FontWeight? fontWeight,
  Color? color,
}) {
  bool isDark = ref!.watch(themeNotifierProvider);
  Color defaultColor = isDark ? Colors.white : Colors.black;
  return TextStyle(
    fontSize: size.sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? defaultColor,
    fontFamily: 'Roboto',
  );
}
