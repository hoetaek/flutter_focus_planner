import 'package:flutter/cupertino.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  HiveList<Goal> goals;
  @HiveField(2)
  int priority;

  Category({@required this.name});

  void addGoal(Goal goal) {
    goals.add(goal);
    save();
  }

  @override
  String toString() {
    // TODO: implement toString
    return name + ": " + priority.toString();
  }
}
