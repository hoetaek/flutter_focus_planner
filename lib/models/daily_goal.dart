import 'package:flutter/cupertino.dart';
import 'package:focusplanner/constants.dart';
import 'package:hive/hive.dart';

import 'category.dart';
import 'goal.dart';

part 'daily_goal.g.dart';

extension DateTimeExtension on DateTime {
  DateTime getDateDay() {
    return DateTime(this.year, this.month, this.day);
  }

  static DateTime getTodayDay() {
    DateTime now = DateTime.now();
    return now.getDateDay();
  }
}

@HiveType(typeId: 2)
class DailyGoal extends HiveObject {
  @HiveField(0)
  HiveList<Category> _categoryList;
  @HiveField(1)
  int difficulty;
  @HiveField(2)
  String name;
  @HiveField(3)
  HiveList<Goal> _goals;
  @HiveField(4)
  List<DateTime> generatedDates;
  DailyGoal({
    @required this.name,
    @required this.difficulty,
  })  : this._categoryList = HiveList(Hive.box(Boxes.categoryBox)),
        this._goals = HiveList(Hive.box(Boxes.goalBox)),
        this.generatedDates = List<DateTime>();

  Category get category => _categoryList[0];
  List<Goal> get goals => List.unmodifiable(_goals);

  set category(Category category) {
    _categoryList[0] = category;
  }

  addCategory(Category category) {
    _categoryList.add(category);
  }

  int countComplete() {
    return _goals.where((goal) => goal.status == GoalStatus.complete).length;
  }

  makeGoal() {
    if (_goals.length != countComplete() || _checkTodayDate()) return;
    _generateTodayDate();
    Goal goal =
        Goal(name: name, difficulty: difficulty, status: GoalStatus.onWork);

    goal.init(categoryToBeAdded: category);
    category.addGoal(goal);
    _goals.add(goal);
    save();
  }

  bool _checkTodayDate() {
    return _goals
        .where((goal) => goal.date == DateTimeExtension.getTodayDay())
        .isNotEmpty;
  }

  _generateTodayDate() {
    generatedDates.add(DateTimeExtension.getTodayDay());
  }
}
