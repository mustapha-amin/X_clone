import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/services/services.dart';

TextStyle kTextStyle(
  double size,
  WidgetRef? ref, {
  FontWeight? fontWeight,
  Color? color,
}) {
  bool isDark = ref!.watch(themeNotifierProvider);
  Color defaultColor = isDark ? Colors.white : Colors.black;
  return TextStyle(
    fontSize: size,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? defaultColor,
    fontFamily: 'Roboto',
  );
}
