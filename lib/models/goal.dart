import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/work.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import 'daily_goal.dart';

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
  HiveList<Category> _categoryList;
  @HiveField(6)
  HiveList<Work> _workList;
  @HiveField(7)
  bool _inProgress;
  @HiveField(8)
  List<String> _specificGoals;

  Goal({
    @required this.name,
    @required this.difficulty,
    @required this.status,
  }) {
    this.checked = false;
  }

  init({Category categoryToBeAdded}) {
    this._categoryList = HiveList(Hive.box(Boxes.categoryBox));
    this._workList = HiveList(Hive.box(Boxes.workBox));
    if (categoryToBeAdded == null) setCategory();
    _categoryList.add(categoryToBeAdded ?? category);
    // for compatibility
    if (!isInBox) Hive.box(Boxes.goalBox).add(this);
    _setWork();
  }

  // get 0 index or null
  Category get category => _categoryList?.elementAt(0);
  Work get work => _workList?.elementAt(0);
  bool get inProgress => _inProgress;
  List<String> get specificGoals => _specificGoals;
  int get level => difficulty;
  int get specGoalNum => _specificGoals?.length;

  emptySpecGoals() {
    _specificGoals = List();
    save();
  }

  setSpecificGoals(List<String> goalList) {
    _specificGoals = goalList;
    save();
  }

  setDifficulty(int difficultyData) {
    difficulty = difficultyData;
    save();
  }

  toggleInProgress() {
    _inProgress = !(_inProgress ?? true);
    save();
  }

  complete() {
    print('complete pressed');
    status = GoalStatus.complete;
    checked = false;
    setDate(DateTime.now());
    work.removeGoal(this);
    if (work != null && work.goals.every((goal) => goal == this)) work.delete();
    save();
  }

  setCategory() {
    if (_categoryList.isEmpty) {
      Category category = Hive.box(Boxes.categoryBox)
          .values
          .cast<Category>()
          .firstWhere((category) => category.goals.contains(this));
      _categoryList.add(category);
    }
  }

  _setWork() {
    if (_workExists()) {
      Work work = Hive.box(Boxes.workBox).values.cast<Work>().firstWhere(
          (work) => work.difficulty == difficulty && work.category == category);
      if (!work.goals.contains(this)) {
        work.addGoal(this);
      }
      _workList.add(work);
    } else {
      Work work = _makeWork();
      work.addGoal(this);
      _workList.add(work);
    }
  }

  _changeWork() {
    print("change work");
    print("from: $work");
    _removeFromWork();
    _workList.clear();
    _setWork();
    print("to: $work");
  }

  _removeFromWork() {
    work.removeGoal(this);
    work.save();
    if (work.goals.isEmpty) work.delete();
  }

  bool _workExists() {
    return Hive.box(Boxes.workBox).values.cast<Work>().any(
        (work) => work.difficulty == difficulty && work.category == category);
  }

  Work _makeWork() {
    Work work = Work();
    work.init(this, category);
    return work;
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

  check(bool checked) {
    this.checked = checked;
    save();
  }

  uncheck() {
    bool categoryExists = Hive.box(Boxes.categoryBox)
        .values
        .cast<Category>()
        .any((categoryFromBox) => categoryFromBox == category);
    if (categoryExists) {
      checked = false;
      status = GoalStatus.onWork;
      _setWork();
    }
    save();
  }

  Color getColor() {
    return kPrimaryColor.withRed(difficulty * 40);
  }

  static Color getDifficultyColor(difficulty) {
    return kPrimaryColor.withRed(difficulty * 40);
  }

  void levelUp() {
    if (difficulty != 5) {
      difficulty += 1;
      _changeWork();
      save();
    }
  }

  void levelDown() {
    if (difficulty != 1) {
      difficulty -= 1;
      _changeWork();
      save();
    }
  }

  void setDate(DateTime today) {
    date = today;
    save();
  }

  DateTime getDay() {
    return date?.getDateDay();
  }

  bool isOnDate(DateTime compareDate) {
    if (compareDate == getDay()) return true;
    return false;
  }

  @override
  String toString() {
    return name;
  }

  @override
  Future<void> delete() {
    if (work != null && work.goals.every((goal) => goal == this)) work.delete();
    return super.delete();
  }
}
