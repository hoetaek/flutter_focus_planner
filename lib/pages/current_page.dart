import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/current_view.dart';
import 'package:focusplanner/screens/default_current_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.goalBox).listenable(),
        builder: (context, Box box, widget) {
          return box.values
                  .where((goal) => (goal as Goal).status != GoalStatus.complete)
                  .isEmpty
              ? DefaultCurrentView()
              : CurrentView();
        });
  }
}
