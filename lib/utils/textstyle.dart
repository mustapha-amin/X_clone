import 'package:flutter/material.dart';

TextStyle kTextStyle(
  double size, {
  FontWeight? fontWeight,
  Color? color,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? Colors.black,
    fontFamily: 'Roboto',
  );
}
