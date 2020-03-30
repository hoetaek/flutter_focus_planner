import 'package:flutter/material.dart';

class Boxes {
  static String categoryBox = "CategoryBox";
  static String goalBox = "GoalBox";
  static String settingBox = "SettingBox";
  static String dailyGoalBox = "DailyGoalBox";
  static String workBox = "WorkBox";
}

class GoalStatus {
  static String onWork = "onWork";
  static String complete = "Complete";
}

class Settings {
  static String currentPage = "currentPage";
  static String archiveMode = "archiveMode";
}

const Radius kCardRadius = Radius.circular(10.0);
const BoxDecoration kCardDecoration = BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(11.0)));

final List<Color> kColors = <Color>[
  Color(0xFFF44336),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFF673AB7),
  Color(0xFF3F51B5),
  Color(0xFF2196F3),
  Color(0xFF03A9F4),
  Color(0xFF00BCD4),
  Color(0xFF009688),
  Color(0xFF4CAF50),
  Color(0xFF8BC34A),
  Color(0xFFCDDC39),
  Color(0xFFFFEB3B),
  Color(0xFFFFC107),
  Color(0xFFFF9800),
  Color(0xFFFF5722),
  Color(0xFF795548),
  Color(0xFF607D8B),
];
const kPrimaryColor = Colors.tealAccent;
