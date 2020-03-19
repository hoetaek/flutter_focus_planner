import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

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

  Goal(
      {@required this.name, @required this.difficulty, @required this.status}) {
    this.checked = false;
  }

  void setDate(DateTime today) {
    date = today;
    save();
  }

  DateTime getDay() {
    return date;
  }

  bool isOnDate(DateTime compareDate) {
    if (compareDate == date) return true;
    return false;
  }

  @override
  String toString() {
    return name;
  }
}
