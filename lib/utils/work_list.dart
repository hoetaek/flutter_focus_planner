import 'dart:collection';

import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

class WorkList {
  List<Work> _workOrder = [];
  List<Category> _categoryList;

  Box categoryBox = Hive.box(Boxes.categoryBox);

  WorkList() {
    _categoryList = categoryBox.values.cast<Category>().toList();
    _categoryList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  List<Work> get workOrder => UnmodifiableListView(_workOrder);

  generateWorkOrder() {
    _workOrder.clear();
    for (int i in List<int>.generate(5, (i) => i + 1)) {
      for (var category in _categoryList) {
        _workOrder.add(Work(category, i));
      }
    }
    _workOrder.removeWhere((value) => value.goalList.isEmpty);
  }
}

class Work {
  Category _category;
  int _difficulty;
  List<Goal> goalList = [];

  Work(this._category, this._difficulty) {
    for (var goal in _category.goals
        .where((goal) => goal.status != GoalStatus.complete)) {
      if (goal.difficulty == _difficulty) {
        goalList.add(goal);
      }
    }
  }

  Category get category => _category;
  int get difficulty => _difficulty;

  @override
  String toString() {
    // TODO: implement toString
    return goalList.toString();
  }
}
