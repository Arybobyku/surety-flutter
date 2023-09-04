import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:surety/helper/color_palette.dart';

class Constants {
  static const String userName = 'userName';
  static const String role = 'role';
  static const String history = 'history';
  static const String userModel = 'userModel';
  static const String banner = 'https://firebasestorage.googleapis.com/v0/b/surety-3640c.appspot.com/o/banner%2Fbanner.png?alt=media&token=ceb4a2e5-8766-4e9a-b067-775761701fe2';
}

String parseDate(String dateString) {
  var parsedDate = DateTime.parse(dateString);
  return DateFormat.yMMMMd("en_US").format(parsedDate);
}

String getDurationDifference(DateTime startTime, DateTime endTime) {
  final difference = endTime.difference(startTime);

  var sDuration = '';
  sDuration = "${difference.inDays} Hari";
  return sDuration;
}

int getDurationDifferenceInt(DateTime startTime, DateTime endTime) {
  final difference = endTime.difference(startTime);
  return difference.inDays;
}

Color backgroundStatus(int status) {
  switch (status) {
    case 0:
      return ColorPalette.generalSoftOrange;
    case 1:
      return ColorPalette.generalSoftGreen;
    case 2:
      return ColorPalette.generalSoftPurple;
    case 3:
      return ColorPalette.generalSoftYellow;
    case 4:
      return ColorPalette.generalSoftRed;
    default:
      return ColorPalette.generalSoftYellow;
  }
}

final kRoundedContainer = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  border: Border.all(color: ColorPalette.generalPrimaryColor, width: 2),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 7,
      offset: Offset(0, 1), // changes position of shadow
    ),
  ],
);

final List<Map<String, String>> moodStickers = [
  {"smile": "😊"},
  {"sad": "😟"},
  {"tired": "😩"},
  {"happy": "🥳"},
  {"sick": "🤒"},
  {"angry": "😡"},
];

final symptomsList = [
  "Hot Flushes/Flashes",
  "Irregular periods",
  "Vaginal Dryness",
  "Loss of libido",
  "Trouble Sleeping",
  "Reduce Libido",
  "Mood Swings",
];
