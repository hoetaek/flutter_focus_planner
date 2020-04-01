import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_split_page.dart';

class GoalCheckBoxListTile extends StatelessWidget {
  final Widget secondary;
  final bool value;
  final Function onChanged;
  final Goal goal;

  const GoalCheckBoxListTile(
      {Key key,
      this.secondary,
      @required this.value,
      @required this.onChanged,
      @required this.goal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalSplitPage(
                      goal: goal,
                    )));
      },
      child: CheckboxListTile(
        secondary: secondary,
        title: Text(goal.name),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
