import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';

import 'focus_view.dart';

class FocusContent extends StatefulWidget {
  final List<Goal> goals;
  final Function onChecked;
  final Function toggleAll;
  final FocusMode focusMode;

  FocusContent({this.goals, this.onChecked, this.focusMode, this.toggleAll});
  @override
  _FocusContentState createState() => _FocusContentState();
}

class _FocusContentState extends State<FocusContent> {
  @override
  Widget build(BuildContext context) {
    return widget.goals != null
        ? ListView.builder(
            itemCount: widget.goals.length,
            itemBuilder: (context, index) {
              Goal goal = widget.goals[index];
              return Slidable(
                key: UniqueKey(),
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
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption:
                        widget.focusMode == FocusMode.Work ? '대기작업' : '몰입작업',
                    color: widget.focusMode == FocusMode.Work
                        ? Colors.indigo
                        : kPrimaryColor.withGreen(150),
                    foregroundColor: Colors.white,
                    icon: widget.focusMode == FocusMode.Work
                        ? Icons.watch_later
                        : Icons.center_focus_strong,
                    onTap: () {
                      setState(() {
                        goal.toggleInProgress();
                        bool inProgressExists = widget.goals
                            .any((goal) => goal.inProgress != false);
                        if (!inProgressExists) widget.toggleAll();
                      });
                    },
                  ),
                ],
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    if (actionType == SlideActionType.secondary) {
                      setState(() {
                        goal.toggleInProgress();
                        bool inProgressExists = widget.goals
                            .any((goal) => goal.inProgress != false);
                        if (!inProgressExists) widget.toggleAll();
                      });
                    }
                  },
                  dismissThresholds: <SlideActionType, double>{
                    SlideActionType.primary: 1.0
                  },
                ),
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoalEditPage(
                                  goal: goal,
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
