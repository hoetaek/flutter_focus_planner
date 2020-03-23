import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  HiveList<Goal> goals;
  @HiveField(2)
  int priority;
  @HiveField(3)
  int colorIndex;

  Category({@required this.name, colorIndex = 0});

  void addGoal(Goal goal) {
    goals.add(goal);
    save();
  }

  Color getColor() {
    if (colorIndex != null)
      return kColors[colorIndex];
    else
      return kPrimaryColor;
  }

  Color getTextColor() {
    Color color = getColor();
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  String toString() {
    return name + ": " + priority.toString();
  }
}
