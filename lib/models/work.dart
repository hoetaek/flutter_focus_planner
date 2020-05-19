import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

import 'category.dart';

part 'work.g.dart';

@HiveType(typeId: 3)
class Work extends HiveObject {
  @HiveField(0)
  HiveList<Category> _categoryList;
  @HiveField(1)
  HiveList<Goal> _goals;
  @HiveField(2)
  int difficulty;

  Work({this.difficulty})
      : this._categoryList = HiveList(Hive.box(Boxes.categoryBox)),
        this._goals = HiveList(Hive.box(Boxes.goalBox));

  List<Goal> get goals => List.unmodifiable(_goals);
  List<Goal> get difficultyGoals => Hive.box(Boxes.goalBox)
      .values
      .cast<Goal>()
      .where((goal) =>
          goal.difficulty == difficulty && goal.status == GoalStatus.onWork)
      .toList();

  init(Goal goal, Category category) {
    _goals = HiveList(Hive.box(Boxes.goalBox));
    difficulty = goal.difficulty;
    _categoryList = HiveList(Hive.box(Boxes.categoryBox));
    _categoryList.add(category);
    Hive.box(Boxes.workBox).add(this);
  }

  Category get category => _categoryList[0];
  int get compareId => difficulty * 100 + category.priority;

  bool isWorkGoal(Goal goal) {
    return _goals.contains(goal);
  }

  addGoal(Goal goal) {
    _goals.add(goal);
    save();
  }

  removeGoal(Goal goal) {
    _goals.remove(goal);
    save();
  }

  removeCompleteGoals() {
    _goals.removeWhere((goal) => goal.status == GoalStatus.complete);
    save();
  }

  @override
  String toString() {
    return "work: categoryInfo $category difficultyInfo $difficulty goalListInfo ${_goals.toString()}";
  }
}
