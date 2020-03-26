import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class Work extends HiveObject {
  @HiveField(1)
  HiveList<Category> _categoryList;
  @HiveField(2)
  HiveList<Goal> goals;
  @HiveField(3)
  int difficulty;

  Work(Category category, Goal goal)
      : _categoryList = HiveList<Category>(Hive.box(Boxes.categoryBox),
            objects: [category]),
        goals = HiveList<Goal>(Hive.box(Boxes.goalBox), objects: [goal]),
        difficulty = goal.difficulty;
}
