import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import 'daily_goal.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  HiveList<Goal> _goals;
  @HiveField(2)
  int priority;
  @HiveField(3)
  int colorIndex;

  Category({@required this.name, colorIndex = 0});

  List<Goal> get goals => List.unmodifiable(_goals);

  init(int selectedColorIndex) {
    _goals = HiveList(Hive.box(Boxes.goalBox));
    priority = Hive.box(Boxes.categoryBox).length;
    colorIndex = selectedColorIndex;
    Hive.box(Boxes.categoryBox).add(this);
  }

  void changePriority(int index) {
    priority = index;
  }

  void priorityUp() {
    if (priority > 0) {
      Category category = Hive.box(Boxes.categoryBox)
          .values
          .cast<Category>()
          .where((category) => category.priority == priority - 1)
          ?.elementAt(0);
      print(category);
      priority--;
      if (category != null) {
        category.priority++;
        category.save();
      }
      save();
    }
  }

  void priorityDown() {
    if (priority < Hive.box(Boxes.categoryBox).length - 1) {
      Category category = Hive.box(Boxes.categoryBox)
          .values
          .cast<Category>()
          .where((category) => category.priority == priority + 1)
          ?.elementAt(0);
      print(category);
      priority++;
      if (category != null) {
        category.priority--;
        category.save();
      }
      save();
    }
  }

  void addGoal(Goal goal) {
    _goals.add(goal);
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
  Future<void> delete() {
    Hive.box(Boxes.dailyGoalBox).values.cast<DailyGoal>().forEach((dailyGoal) {
      if (this == dailyGoal.category) dailyGoal.delete();
    });
    _goals.forEach((goal) {
      if (goal.status == GoalStatus.onWork) goal.delete();
    });
    Hive.box(Boxes.workBox)
        .values
        .cast<Work>()
        .where((work) => work.category == this)
        .forEach((work) {
      work.delete();
    });
    return super.delete();
  }

  @override
  String toString() {
    return name + ": " + priority.toString();
  }
}
