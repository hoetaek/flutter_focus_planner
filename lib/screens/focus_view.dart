import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import '../constants.dart';

class FocusView extends StatefulWidget {
  final Work focusWork;

  FocusView({this.focusWork});
  @override
  _FocusViewState createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView> {
  ButtonState _buttonState;

  bool goalIsChecked(List<Goal> goalList) {
    return goalList.where((Goal goal) => goal.checked).isNotEmpty;
  }

  @override
  void initState() {
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
        focusWork: widget.focusWork,
        buttonState: _buttonState,
        actionDone: () {
          setState(() {
            //바뀌었던 상태를 다시 add할 수 있는 상태로 변경 해 준다.
            _buttonState = ButtonState.add;
          });
        },
      ),
      body: FocusContent(
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
      ),
    );
  }
}

class FocusAppBar extends StatelessWidget implements PreferredSize {
  final ButtonState buttonState;
  final Function actionDone;
  final Work focusWork;

  FocusAppBar(
      {Key key,
      @required this.focusWork,
      @required this.buttonState,
      @required this.actionDone})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${focusWork.category.name} - Lv.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                List<Goal> goalCheckedList = focusWork.goals.where((goal) {
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
                List<Goal> goalCheckedList = focusWork.goals.where((goal) {
                  //checked가 된 골만 return 한다.
                  return goal.checked;
                }).toList();
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

class FocusContent extends StatefulWidget {
  final List<Goal> focusGoals;
  final Function onChecked;

  FocusContent({this.focusGoals, this.onChecked});
  @override
  _FocusContentState createState() => _FocusContentState();
}

class _FocusContentState extends State<FocusContent> {
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
