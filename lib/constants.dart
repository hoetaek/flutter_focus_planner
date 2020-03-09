import 'package:flutter/material.dart';

class Boxes {
  static String categoryBox = "CategoryBox";
  static String goalBox = "GoalBox";
  static String settingBox = "SettingBox";
}

class GoalStatus {
  static String archive = "Archive";
  static String current = "Current";
  static String complete = "Complete";
}

const Radius kCardRadius = Radius.circular(15.0);
const BoxDecoration kCardDecoration = BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.all(kCardRadius));
