import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal {
  @HiveField(0)
  String difficulty;
  @HiveField(1)
  String name;
  @HiveField(2)
  String condition;

  Goal(this.difficulty, this.name, this.condition);
}
