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
  HiveList<Goal> goals;
  @HiveField(2)
  int difficulty;

  Work({this.difficulty})
      : this._categoryList = HiveList(Hive.box(Boxes.categoryBox)),
        this.goals = HiveList(Hive.box(Boxes.goalBox));

  init(Goal goal, Category category) {
    goals = HiveList(Hive.box(Boxes.goalBox));
    difficulty = goal.difficulty;
    _categoryList = HiveList(Hive.box(Boxes.categoryBox));
    _categoryList.add(category);
    Hive.box(Boxes.workBox).add(this);
  }

  Category get category => _categoryList[0];
  int get compareId => difficulty * 100 + category.priority;

  bool isWorkGoal(Goal goal) {
    return goals.contains(goal);
  }

  addGoal(Goal goal) {
    goals.add(goal);
    save();
  }

  @override
  String toString() {
    return "work: categoryInfo $category difficultyInfo $difficulty goalListInfo ${goals.toString()}";
  }
}
