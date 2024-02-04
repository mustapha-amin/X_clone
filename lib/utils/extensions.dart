import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension BuildContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

extension WidgetExtensions on Widget {
  Widget padX(double? size) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size!),
        child: this,
      );

  Widget padY(double? size) => Padding(
        padding: EdgeInsets.symmetric(vertical: size!),
        child: this,
      );

  Widget padAll(double? size) => Padding(
        padding: EdgeInsets.all(size!),
        child: this,
      );

  Widget centralize() => Center(
        child: this,
      );
}

extension JoinTimeFormatting on DateTime {
  String get formatDate {
    final dateFormat = intl.DateFormat.yMMM();
    return "$day, ${dateFormat.format(this)}";
  }

  String get formatTime {
    final timeFormat = intl.DateFormat(intl.DateFormat.HOUR_MINUTE_TZ);
    return timeFormat.format(this);
  }

  String get when {
    if (day.compareTo(DateTime.now().day) == 0) {
      return "Today";
    } else if (DateTime.now().difference(this).inDays == 1) {
      return "Yesterday";
    } else {
      return formatDate;
    }
  }
}
