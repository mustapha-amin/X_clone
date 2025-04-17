import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/core.dart';

TextStyle kTextStyle(
  double size,
  WidgetRef? ref, {
  FontWeight? fontWeight,
  Color? color,
}) {
  bool isDark = ref!.watch(themeNotifierProvider);
  Color defaultColor = isDark ? Colors.white : Colors.black;
  return GoogleFonts.manrope(
    fontSize: size,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? defaultColor,
  );
}
