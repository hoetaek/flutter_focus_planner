import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String difficulty;
  @HiveField(2)
  String status;

  Goal({@required this.name, @required this.difficulty, @required this.status});
}
