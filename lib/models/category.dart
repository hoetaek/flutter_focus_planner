import 'package:flutter/cupertino.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  HiveList<Goal> goals;

  Category({@required this.name}) {
    this.goals = HiveList(Hive.box(Boxes.goalBox));
  }

  void addGoal(Goal goal) {
    goals.add(goal);
  }
}
