import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'focus_app_bar.dart';
import 'focus_content.dart';

class FocusView extends StatefulWidget {
  final Work focusWork;

  FocusView({this.focusWork});
  @override
  _FocusViewState createState() => _FocusViewState();
}

enum FocusMode {
  Work,
  Waiting,
}

class _FocusViewState extends State<FocusView> {
  ButtonState _buttonState;
  FocusMode _focusMode;

  bool goalIsChecked(List<Goal> goalList) {
    return goalList.where((Goal goal) => goal.checked).isNotEmpty;
  }

  @override
  void initState() {
    _focusMode = FocusMode.Work;
    if (goalIsChecked(widget.focusWork.goals))
      _buttonState = ButtonState.modify;
    else
      _buttonState = ButtonState.add;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FocusAppBar(
        focusMode: _focusMode,
        focusWork: widget.focusWork,
        progressGoals: progressGoals(true),
        waitingGoals: progressGoals(false),
        buttonState: _buttonState,
        actionDone: () {
          setState(() {
            //바뀌었던 상태를 다시 add할 수 있는 상태로 변경 해 준다.
            _buttonState = ButtonState.add;
          });
        },
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box(Boxes.goalBox).listenable(),
          builder: (context, Box box, child) {
            return Column(
              children: <Widget>[
                focusContent(),
//                if (_focusMode == FocusMode.Work)
//                  CustomButton(
//                    title: '시작',
//                    onPressed: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (_) => FocusStopWatchPage(
//                              focusWorkOnProgress: widget.focusWork.goals
//                                  .where((goal) => goal.inProgress != false)
//                                  .toList())));
//                    },
//                  )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: _focusMode == FocusMode.Waiting
            ? Icon(Icons.center_focus_strong)
            : Icon(Icons.watch_later),
        onPressed: () {
          setState(() {
            _focusMode = _focusMode == FocusMode.Waiting
                ? FocusMode.Work
                : FocusMode.Waiting;
            if (_focusMode == FocusMode.Work) {
              bool isProgressGoalsChecked =
                  progressGoals(true).any((goal) => goal.checked == true);
              if (isProgressGoalsChecked)
                _buttonState = ButtonState.modify;
              else
                _buttonState = ButtonState.add;
            } else {
              bool isProgressGoalsChecked =
                  progressGoals(false).any((goal) => goal.checked == true);
              if (isProgressGoalsChecked)
                _buttonState = ButtonState.modify;
              else
                _buttonState = ButtonState.add;
            }
          });
        },
      ),
    );
  }

  FocusContent focusContent() {
    return _focusMode == FocusMode.Work
        ? FocusContent(
            focusMode: _focusMode,
            goals: progressGoals(true),
            onChecked: () {
              setState(() {
                if (goalIsChecked(progressGoals(true))) {
                  _buttonState = ButtonState.modify;
                } else {
                  _buttonState = ButtonState.add;
                }
              });
            },
            toggleAll: () {
              setState(() {
                progressGoals(false).forEach((goal) => goal.toggleInProgress());
              });
            })
        : FocusContent(
            focusMode: _focusMode,
            goals: progressGoals(false),
            onChecked: () {
              setState(() {
                if (goalIsChecked(progressGoals(false))) {
                  _buttonState = ButtonState.modify;
                } else {
                  _buttonState = ButtonState.add;
                }
              });
            },
          );
  }

  List<Goal> progressGoals(bool isInProgress) {
    List<Goal> goalsOnWork = [];
    List<Goal> importantGoals =
        Hive.box(Boxes.goalBox).values.cast<Goal>().where((goal) {
      if (goal.inProgress == null) goal.setProgress = true;
      return goal.status == GoalStatus.onWork &&
          goal.isImportant &&
          (goal.inProgress == isInProgress);
    }).toList();

    goalsOnWork.addAll(widget.focusWork.goals.where((goal) {
      if (goal.inProgress == null) goal.setProgress = true;
      return goal.status == GoalStatus.onWork &&
          goal.inProgress == isInProgress;
    }));
    importantGoals.reversed
        .where((goal) => !goalsOnWork.contains(goal))
        .forEach((goal) {
      goalsOnWork.insert(0, goal);
    });

    return goalsOnWork;
  }
}
