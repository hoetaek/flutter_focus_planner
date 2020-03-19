import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class CurrentListView extends StatefulWidget {
  final Category category;

  CurrentListView({this.category});
  @override
  _CurrentListViewState createState() => _CurrentListViewState();
}

class _CurrentListViewState extends State<CurrentListView> {
  ButtonState _buttonState;

  bool goalIsChecked() {
    return widget.category.goals.where((Goal goal) => goal.checked).isNotEmpty;
  }

  @override
  void initState() {
    if (goalIsChecked())
      _buttonState = ButtonState.modify;
    else
      _buttonState = ButtonState.add;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CurrentSliverAppBar(
          category: widget.category,
          buttonState: _buttonState,
          actionDone: () {
            setState(() {
              //바뀌었던 상태를 다시 add할 수 있는 상태로 변경 해 준다.
              _buttonState = ButtonState.add;
            });
          },
        ),
//        Container(),
        //todo 난이도 순서대로 표시하기
        CurrentContent(
          category: widget.category,
          onChecked: () {
            setState(() {
              if (goalIsChecked()) {
                _buttonState = ButtonState.modify;
              } else {
                _buttonState = ButtonState.add;
              }
            });
          },
        ),
      ],
    );
  }
}

class CurrentSliverAppBar extends StatelessWidget {
  final Category category;
  final ButtonState buttonState;
  final Function actionDone;

  const CurrentSliverAppBar({this.category, this.buttonState, this.actionDone});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('${category.name}'),
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
                              category: category,
                              goalStatus: GoalStatus.current,
                            )));
              }),
          modifyWidgets: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                List<Goal> goalCheckedList = category.goals.where((goal) {
                  //checked가 된 골만 return 한다.
                  return goal.checked;
                }).toList();
                goalCheckedList.forEach((Goal goal) {
                  goal.status = GoalStatus.archive;
                  goal.checked = false;
                  goal.save();
                });
                actionDone();
                Box settingBox = Hive.box(Boxes.settingBox);
                settingBox.put('archiveCategory', category.key);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                List<Goal> goalCheckedList = category.goals.where((goal) {
                  //checked가 된 골만 return 한다.
                  return goal.checked;
                }).toList();
                goalCheckedList.forEach((Goal goal) {
                  category.goals.remove(goal);
                  category.save();
                  goal.delete();
                });
                actionDone();
              },
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                List<Goal> goalCheckedList = category.goals.where((goal) {
                  //checked가 된 골만 return 한다.
                  return goal.checked;
                }).toList();
                goalCheckedList.forEach((Goal goal) {
                  goal.status = GoalStatus.complete;
                  goal.checked = false;
                  goal.setDate(DateTime.now());
                  goal.save();
                });
                actionDone();
              },
              //todo 완료 했을 때 comeplete page로 넘어 가게 한다.
            ),
          ],
        )
      ],
    );
  }
}

/*
            FittedBox(
                child: )

 */
class CurrentContent extends StatefulWidget {
  final Category category;
  final Function onChecked;

  CurrentContent({this.category, this.onChecked});
  @override
  _CurrentContentState createState() => _CurrentContentState();
}

class _CurrentContentState extends State<CurrentContent> {
  @override
  Widget build(BuildContext context) {
    List<Goal> currentGoals = widget.category.goals
        .where((Goal goal) => goal.status == GoalStatus.current)
        .toList();
    return widget.category.goals != null
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Goal goal = currentGoals[index];
                return CheckboxListTile(
                  title: Text('${goal.name}'),
                  value: goal.checked,
                  onChanged: (change) {
                    setState(() {
                      goal.checked = change;
                      goal.save();
                    });
                    widget.onChecked();
                  },
                );
              },
              childCount: currentGoals.length,
            ),
          )
        : Container();
  }
}