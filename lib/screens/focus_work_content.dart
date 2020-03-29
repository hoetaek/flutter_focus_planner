import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';

import '../constants.dart';

class FocusWorkContent extends StatefulWidget {
  final List<Goal> focusGoals;
  final Function onChecked;

  FocusWorkContent({this.focusGoals, this.onChecked});
  @override
  _FocusWorkContentState createState() => _FocusWorkContentState();
}

class _FocusWorkContentState extends State<FocusWorkContent> {
  @override
  Widget build(BuildContext context) {
    return widget.focusGoals != null
        ? ListView.builder(
            itemCount: widget.focusGoals.length,
            itemBuilder: (context, index) {
              Goal goal = widget.focusGoals[index];
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.15,
                actions: <Widget>[
                  if (goal.difficulty != 5)
                    IconSlideAction(
                      caption: 'Level',
                      color: Colors.blue,
                      icon: Icons.arrow_upward,
                      onTap: () {
                        setState(() {
                          goal.levelUp();
                        });
                      },
                    ),
                  if (goal.difficulty != 1)
                    IconSlideAction(
                      caption: 'Level',
                      color: Colors.redAccent,
                      icon: Icons.arrow_downward,
                      onTap: () {
                        setState(() {
                          goal.levelDown();
                        });
                      },
                    ),
                ],
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoalEditPage(
                                  goal: goal,
                                  goalStatus: GoalStatus.onWork,
                                )));
                  },
                  child: CheckboxListTile(
                    title: Text('${goal.name}'),
                    value: goal.checked,
                    onChanged: (change) {
                      setState(() {
                        goal.checked = change;
                        goal.save();
                      });
                      widget.onChecked();
                    },
                  ),
                ),
              );
            },
          )
        : Container();
  }
}
