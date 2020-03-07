import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'category.dart';

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
  Category category;

  Goal(
      {@required this.category,
      @required this.name,
      @required this.difficulty,
      @required this.status}) {
    this.checked = false;
  }
}
