import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import 'daily_goal.dart';

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
      return kPrimaryColor.withGreen(150);
  }

  Color getTextColor() {
    Color color = getColor();
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Future<void> delete() {
    Hive.box(Boxes.dailyGoalBox).values.cast<DailyGoal>().forEach((dailyGoal) {
      if (this == dailyGoal.category) dailyGoal.delete();
    });
    goals.forEach((goal) {
      if (goal.status == GoalStatus.onWork) goal.delete();
    });
    return super.delete();
  }

  @override
  String toString() {
    return name + ": " + priority.toString();
  }
}
