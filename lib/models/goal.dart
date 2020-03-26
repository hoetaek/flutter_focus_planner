import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/work.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import 'category.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  int difficulty;
  @HiveField(2)
  String status;
  @HiveField(3)
  bool checked;
  @HiveField(4)
  DateTime date;
  @HiveField(5)
  HiveList<Category> categoryList;
  @HiveField(6)
  HiveList<Work> workList;

  Goal(
      {@required this.name, @required this.difficulty, @required this.status}) {
    this.checked = false;
  }

  static IconData getIconData(difficulty) {
    switch (difficulty) {
      case 1:
        {
          return Icons.looks_one;
        }
        break;

      case 2:
        {
          return Icons.looks_two;
        }
        break;
      case 3:
        {
          return Icons.looks_3;
        }
        break;
      case 4:
        {
          return Icons.looks_4;
        }
        break;
      case 5:
        {
          return Icons.looks_5;
        }
        break;
      default:
        {
          return Icons.looks_one;
        }
        break;
    }
  }

  Color getColor() {
    return kPrimaryColor.withGreen(difficulty * 50);
  }

  void levelUp() {
    difficulty += 1;
    save();
  }

  void levelDown() {
    difficulty -= 1;
    save();
  }

  void setDate(DateTime today) {
    date = today;
    save();
  }

  DateTime getDay() {
    return date;
  }

  bool isOnDate(DateTime compareDate) {
    if (compareDate == date) return true;
    return false;
  }

  @override
  String toString() {
    return name;
  }
}
