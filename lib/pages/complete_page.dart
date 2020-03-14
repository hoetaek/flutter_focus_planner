import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:focusplanner/widgets/date_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.goalBox).listenable(),
        builder: (context, Box box, widget) {
          return SingleChildScrollView(
            child: Column(
              children: getDateGoalsColumn(box),
            ),
          );
        });
  }

  List<Widget> getDateGoalsColumn(Box goalBox) {
    List<Widget> _children = [];
    List<DateTime> uniqueGoalDateList;
    uniqueGoalDateList = goalBox.values
        .where((goal) => (goal as Goal).date != null)
        .map((goal) => (goal as Goal).getDay())
        .toSet()
        .toList();
    print(uniqueGoalDateList);
    uniqueGoalDateList.sort((b, a) => a.compareTo(b));
    uniqueGoalDateList.forEach((date) {
      List<Goal> goalsOnDate = goalBox.values
          .where((goal) => (goal as Goal).isOnDate(date))
          .cast<Goal>()
          .toList();

      if (goalsOnDate.length > 0) _children.add(DateListTile(date: date));
      _children.add(ColumnBuilder(
        itemCount: goalsOnDate.length,
        itemBuilder: (context, idx) {
          Goal goal = goalsOnDate[idx];

          // the tile widgets
          return CheckboxListTile(
            title: Text(goal.name),
            value: true,
            onChanged: null,
          );
        },
      ));
    });
    return _children;
  }
}
