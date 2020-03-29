import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/screens/focus_view.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import '../constants.dart';

class FocusAppBar extends StatelessWidget implements PreferredSize {
  final ButtonState buttonState;
  final Function actionDone;
  final Work focusWork;
  final FocusMode focusMode;

  FocusAppBar(
      {Key key,
      @required this.focusWork,
      @required this.buttonState,
      @required this.actionDone,
      @required this.focusMode})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            focusMode == FocusMode.Work
                ? '${focusWork.category.name} - Lv.'
                : 'Lv.${focusWork.difficulty}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (focusMode == FocusMode.Work)
            Icon(Goal.getIconData(focusWork.difficulty)),
        ],
      ),
      actions: <Widget>[
        ActionsIconButton(
          buttonState: buttonState,
          addWidget: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoalAddPage(
                              category: focusWork.category,
                              goalStatus: GoalStatus.onWork,
                              difficulty: focusWork.difficulty,
                            )));
              }),
          modifyWidgets: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                List<Goal> goalCheckedList;
                if (focusMode == FocusMode.Work) {
                  goalCheckedList = focusWork.goals.where((goal) {
                    //checked가 된 골만 return 한다.
                    return goal.checked;
                  }).toList();
                } else {
                  goalCheckedList = focusWork.difficultyGoals
                      .where((goal) => goal.checked == true);
                }

                goalCheckedList.forEach((Goal goal) {
                  goal.delete();
                });
                actionDone();
              },
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                List<Goal> goalCheckedList;
                if (focusMode == FocusMode.Work) {
                  goalCheckedList = focusWork.goals.where((goal) {
                    //checked가 된 골만 return 한다.
                    return goal.checked;
                  }).toList();
                } else {
                  goalCheckedList = focusWork.difficultyGoals
                      .where((goal) => goal.checked == true);
                }

                goalCheckedList.forEach((Goal goal) {
                  goal.complete();
                });
                actionDone();
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  // TODO: implement child
  Widget get child => null;

  @override
  final Size preferredSize;
}
