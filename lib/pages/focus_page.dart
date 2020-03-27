import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/screens/default_focus_view.dart';
import 'package:focusplanner/screens/focus_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FocusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.workBox).listenable(),
        builder: (context, Box workBox, widget) {
          List<Work> workList = workBox.values.cast<Work>().toList();

          workList.sort((a, b) => a.compareId.compareTo(b.compareId));

          return workBox.values.isEmpty
              ? DefaultFocusView()
              : FocusView(focusWork: workList[0]);
        });
  }
}
