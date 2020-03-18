import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/utils/work_list.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import '../constants.dart';

class CurrentView extends StatefulWidget {
  final Category category;

  CurrentView({this.category});
  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> {
  ButtonState _buttonState;
  WorkList workList;

  bool goalIsChecked(List<Goal> goalList) {
    return goalList.where((Goal goal) => goal.checked).isNotEmpty;
  }

  @override
  void initState() {
    workList = WorkList();
    workList.generateWorkOrder();
    Work focusWork = workList.workOrder.first;
    if (goalIsChecked(focusWork.goalList))
      _buttonState = ButtonState.modify;
    else
      _buttonState = ButtonState.add;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    workList.generateWorkOrder();
    Work focusWork = workList.workOrder.first;
    return CustomScrollView(
      slivers: <Widget>[
        CurrentSliverAppBar(
          category: focusWork.category,
          difficulty: focusWork.difficulty,
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
          focusGoals: focusWork.goalList,
          onChecked: () {
            setState(() {
              if (goalIsChecked(focusWork.goalList)) {
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
  final int difficulty;

  const CurrentSliverAppBar(
      {this.category, this.buttonState, this.actionDone, this.difficulty});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('${category.name} - Lv.$difficulty'),
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
                              difficulty: difficulty,
                            )));
              }),
          modifyWidgets: <Widget>[
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
  final List<Goal> focusGoals;
  final Function onChecked;

  CurrentContent({this.focusGoals, this.onChecked});
  @override
  _CurrentContentState createState() => _CurrentContentState();
}

class _CurrentContentState extends State<CurrentContent> {
  @override
  Widget build(BuildContext context) {
    return widget.focusGoals != null
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Goal goal = widget.focusGoals[index];
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
              childCount: widget.focusGoals.length,
            ),
          )
        : Container();
  }
}