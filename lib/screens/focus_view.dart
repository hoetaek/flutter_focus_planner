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
            return _focusMode == FocusMode.Work
                ? FocusContent(
                    focusMode: _focusMode,
                    goals: widget.focusWork.goals
                        .where((goal) => goal.inProgress != false)
                        .toList(),
                    onChecked: () {
                      setState(() {
                        if (goalIsChecked(widget.focusWork.goals)) {
                          _buttonState = ButtonState.modify;
                        } else {
                          _buttonState = ButtonState.add;
                        }
                      });
                    },
                    toggleAll: () {
                      setState(() {
                        widget.focusWork.goals
                            .forEach((goal) => goal.toggleInProgress());
                      });
                    })
                : FocusContent(
                    focusMode: _focusMode,
                    goals: widget.focusWork.goals
                        .where((goal) => goal.inProgress == false)
                        .toList(),
                    onChecked: () {
                      setState(() {
                        if (goalIsChecked(widget.focusWork.difficultyGoals)) {
                          _buttonState = ButtonState.modify;
                        } else {
                          _buttonState = ButtonState.add;
                        }
                      });
                    },
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.swap_horiz),
        onPressed: () {
          setState(() {
            _focusMode = _focusMode == FocusMode.Waiting
                ? FocusMode.Work
                : FocusMode.Waiting;
          });
        },
      ),
    );
  }
}
