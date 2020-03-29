import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import 'focus_app_bar.dart';
import 'focus_difficulty_content.dart';
import 'focus_work_content.dart';

class FocusView extends StatefulWidget {
  final Work focusWork;

  FocusView({this.focusWork});
  @override
  _FocusViewState createState() => _FocusViewState();
}

enum FocusMode {
  Work,
  Difficulty,
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
      body: _focusMode == FocusMode.Work
          ? FocusWorkContent(
              focusGoals: widget.focusWork.goals,
              onChecked: () {
                setState(() {
                  if (goalIsChecked(widget.focusWork.goals)) {
                    _buttonState = ButtonState.modify;
                  } else {
                    _buttonState = ButtonState.add;
                  }
                });
              },
            )
          : FocusDifficultyContent(
              focusDifficultyGoals: widget.focusWork.difficultyGoals,
              onChecked: () {
                setState(() {
                  if (goalIsChecked(widget.focusWork.difficultyGoals)) {
                    _buttonState = ButtonState.modify;
                  } else {
                    _buttonState = ButtonState.add;
                  }
                });
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.swap_horiz),
        onPressed: () {
          setState(() {
            _focusMode = _focusMode == FocusMode.Difficulty
                ? FocusMode.Work
                : FocusMode.Difficulty;
          });
        },
      ),
    );
  }
}
