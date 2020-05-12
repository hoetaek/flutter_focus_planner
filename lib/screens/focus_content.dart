import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/widgets/goal_checkbox_list_tile.dart';

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
            shrinkWrap: true,
            itemCount: widget.goals.length,
            itemBuilder: (context, index) {
              Goal goal = widget.goals[index];
              return Slidable(
                key: UniqueKey(),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.15,
                actions: <Widget>[
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
                        ? Colors.teal[600]
                        : kPrimaryColor,
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
                child: GoalCheckBoxListTile(
                  goal: goal,
                  secondary: false,
                  onChanged: (change) {
                    setState(() {
                      goal.check(change);
                    });
                    widget.onChecked();
                  },
                ),
              );
            },
          )
        : Container();
  }
}
