import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

DatePickerTheme datePickerTheme = DatePickerTheme(
  cancelStyle: TextStyle(color: Colors.white, fontSize: 20),
  doneStyle: TextStyle(color: kSecondColor, fontSize: 20.0),
  backgroundColor: kPrimaryColor,
  itemStyle: TextStyle(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
);

Color kBlackColor = Color(0xff000000);
Color kPrimaryColor = Color(0xff1A1A2C);
Color kSecondColor = Color(0xffC327AB);
Color kPurpleColor = Color(0xff6B5DD3);
Color kDarkPurpleColor = Color(0xff49458F);

class Utils {
  static String toDateTime(DateTime dateTime) {
    final f = DateFormat('d MMM. y, HH:mm');
    final date = f.format(dateTime);

    return '$date';
  }

  static String toDate(DateTime dateTime) {
    final f = DateFormat('d MMM. y');
    final date = f.format(dateTime);

    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);

    return '$time';
  }
}
