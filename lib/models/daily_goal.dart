import 'package:flutter/cupertino.dart';
import 'package:focusplanner/constants.dart';
import 'package:hive/hive.dart';

import 'category.dart';
import 'goal.dart';

part 'daily_goal.g.dart';

extension DateTimeExtension on DateTime {
  static DateTime getDateDay(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  static DateTime getTodayDay() {
    DateTime now = DateTime.now();
    return getDateDay(now);
  }
}

@HiveType(typeId: 2)
class DailyGoal extends HiveObject {
  @HiveField(0)
  //todo check if connecting directly to category is possible
  HiveList<Category> _categoryList;
  @HiveField(1)
  int difficulty;
  @HiveField(2)
  String name;
  @HiveField(3)
  HiveList<Goal> goals;
  @HiveField(4)
  List<DateTime> generatedDates;
  DailyGoal({
    @required this.name,
    @required this.difficulty,
  })  : this._categoryList = HiveList(Hive.box(Boxes.categoryBox)),
        this.goals = HiveList(Hive.box(Boxes.goalBox)),
        this.generatedDates = List<DateTime>();

  Category get category => _categoryList[0];
  set category(Category category) {
    _categoryList[0] = category;
  }

  addCategory(Category category) {
    _categoryList.add(category);
  }

  int countComplete() {
    return goals.where((goal) => goal.status == GoalStatus.complete).length;
  }

  makeGoal() {
    if (goals.length != countComplete() || _checkTodayDate()) return;
    _generateTodayDate();
    Goal goal =
        Goal(name: name, difficulty: difficulty, status: GoalStatus.onWork);
    Hive.box(Boxes.goalBox).add(goal);
    goals.add(goal);

    category.goals.add(goal);
    save();
  }

  bool _checkTodayDate() {
    return generatedDates.contains(DateTimeExtension.getTodayDay());
  }

  _generateTodayDate() {
    generatedDates.add(DateTimeExtension.getTodayDay());
  }
}
