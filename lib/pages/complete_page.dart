import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/complete_calendar.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:focusplanner/widgets/date_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum CompleteMode {
  List,
  Calendar,
}

class CompletePage extends StatefulWidget {
  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  CompleteMode _completeMode = CompleteMode.List;
  Map<DateTime, List<Goal>> _events = Map<DateTime, List<Goal>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('완료', style: TextFont.titleFont()),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box(Boxes.goalBox).listenable(),
          builder: (context, Box goalBox, widget) {
            if (_completeMode == CompleteMode.List) {
              return _buildDateGoalsColumn(goalBox);
            } else
              return Container(
                child: CompleteCalendar(
                  events: _events,
                ),
              );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.swap_horiz),
        onPressed: () {
          setState(() {
            _completeMode = _completeMode == CompleteMode.List
                ? CompleteMode.Calendar
                : CompleteMode.List;
          });
        },
      ),
    );
  }

  Widget _buildDateGoalsColumn(Box goalBox) {
    List<Widget> _children = [];

    List<DateTime> uniqueGoalDateList;
    uniqueGoalDateList = goalBox.values
        .cast<Goal>()
        .where((goal) => goal.date != null)
        .map((goal) => goal.getDay())
        .toSet()
        .toList();
    uniqueGoalDateList.sort((b, a) => a.compareTo(b));
    uniqueGoalDateList.forEach((date) {
      List<Goal> goalsOnDate = goalBox.values
          .cast<Goal>()
          .where((goal) => goal.isOnDate(date))
          .toList();

      _events.putIfAbsent(date, () => goalsOnDate);

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
    return SingleChildScrollView(
      child: Column(
        children: _children,
      ),
    );
  }
}
