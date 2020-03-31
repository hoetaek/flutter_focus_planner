import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import '../constants.dart';
import 'focus_view.dart';

class FocusAppBar extends StatelessWidget implements PreferredSize {
  final ButtonState buttonState;
  final Function actionDone;
  final Work focusWork;
  final FocusMode focusMode;

  FocusAppBar({
    Key key,
    @required this.focusWork,
    @required this.buttonState,
    @required this.actionDone,
    @required this.focusMode,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${focusWork.category.name}',
            style: TextFont.titleFont(),
          ),
          Icon(Goal.getIconData(focusWork.difficulty)),
          if (focusMode == FocusMode.Work)
            Text(
              ' - 진행',
              style: TextFont.titleFont(),
            )
          else
            Text(
              ' - 대기',
              style: TextFont.titleFont(),
            )
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

                goalCheckedList = focusWork.goals.where((goal) {
                  //checked가 된 골만 return 한다.
                  return goal.checked;
                }).toList();

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

                goalCheckedList = focusWork.goals.where((goal) {
                  //checked가 된 골만 return 한다.
                  return goal.checked;
                }).toList();

                goalCheckedList.forEach((Goal goal) {
                  goal.complete();
                });

                bool progressExists =
                    focusWork.goals.any((goal) => goal.inProgress != false);
                if (!progressExists)
                  focusWork.goals.forEach((goal) {
                    goal.toggleInProgress();
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
