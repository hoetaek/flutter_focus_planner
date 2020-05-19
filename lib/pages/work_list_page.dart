import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:focusplanner/widgets/combine_goals_bottomsheet.dart';
import 'package:focusplanner/widgets/goal_checkbox_list_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import 'category_edit_page.dart';
import 'goal_add_page.dart';

class WorkListPage extends StatefulWidget {
  @override
  _WorkListPageState createState() => _WorkListPageState();
}

class _WorkListPageState extends State<WorkListPage> {
  ButtonState _workListModeButtonState = ButtonState.add;
  Box goalBox = Hive.box(Boxes.goalBox);

  onWorklistActionDone() {
    setState(() {
      _workListModeButtonState = ButtonState.add;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('작업 순서',
            style: TextFont.titleFont(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          ActionsIconButton(
            buttonState: _workListModeButtonState,
            addWidget: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                if (Hive.box(Boxes.categoryBox).isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoalAddPage(
                                category: null,
                                goalStatus: GoalStatus.onWork,
                              )));
                else {
                  if (Platform.isAndroid) {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('알림'),
                          content: Text('카테고리가 존재하지 않습니다.'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('확인'),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ));
                  } else if (Platform.isIOS) {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('알림'),
                            content: Text('카테고리가 존재하지 않습니다.'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text('확인'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          );
                        });
                  }
                }
              },
            ),
            modifyWidgets: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.delete,
//                    color: category.getTextColor(),
                ),
                onPressed: () async {
                  List<Goal> goalCheckedList =
                      goalBox.values.cast<Goal>().where((goal) {
                    return goal.status == GoalStatus.onWork && goal.checked;
                  }).toList();
                  await alertReallyDelete(
                      context: context,
                      name: '작업',
                      onAction: () {
                        goalCheckedList.forEach((Goal goal) {
                          goal.delete();
                        });
                      });
                  goalBox.values.cast<Goal>().where((goal) {
                    return goal.status == GoalStatus.onWork && goal.checked;
                  }).forEach((goal) {
                    goal.check(false);
                  });
                  onWorklistActionDone();
                },
              ),
              if (goalBox.values.cast<Goal>().where((goal) {
                    //checked가 된 골만 return 한다.
                    return goal.status == GoalStatus.onWork && goal.checked;
                  }).length >
                  1)
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.layerGroup,
                  ),
                  onPressed: () async {
                    List<Goal> goalCheckedList =
                        goalBox.values.cast<Goal>().where((goal) {
                      //checked가 된 골만 return 한다.
                      return goal.status == GoalStatus.onWork && goal.checked;
                    }).toList();
//                      goalCheckedList.forEach((Goal goal) {
//                        goal.complete();
//                      });
                    int initialDifficulty =
                        goalCheckedList.elementAt(0).difficulty;
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext _) => CombineGoalsBottomSheet(
                        difficulty: initialDifficulty,
                        goalCheckedList: goalCheckedList,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    );
                    goalBox.values.cast<Goal>().where((goal) {
                      return goal.status == GoalStatus.onWork && goal.checked;
                    }).forEach((goal) {
                      goal.check(false);
                    });
                    onWorklistActionDone();
                  },
                ),
              IconButton(
                icon: Icon(
                  Icons.done,
//                    color: category.getTextColor(),
                ),
                onPressed: () {
                  List<Goal> goalCheckedList =
                      goalBox.values.cast<Goal>().where((goal) {
                    return goal.status == GoalStatus.onWork && goal.checked;
                  }).toList();
                  goalCheckedList.forEach((Goal goal) {
                    goal.complete();
                  });
                  onWorklistActionDone();
                },
              ),
            ],
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box categoryBox, widget) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(Boxes.goalBox).listenable(),
            builder: (context, Box goalBox, widget) {
              List<Work> workList =
                  Hive.box(Boxes.workBox).values.cast<Work>().toList();
              workList.sort((a, b) => a.compareId.compareTo(b.compareId));
              List<Goal> goalList = [];
              workList.forEach((work) {
                goalList.addAll(work.goals);
              });
              return WorkListView(
                  focusWork: workList.isNotEmpty ? workList.first : null,
                  goalList: goalList,
                  onCheckChanged: (bool anyChecked) {
                    setState(() {
                      if (anyChecked == true)
                        _workListModeButtonState = ButtonState.modify;
                      else
                        _workListModeButtonState = ButtonState.add;
                    });
                  });
            },
          );
        },
      ),
    );
  }
}

class WorkListView extends StatefulWidget {
  final List<Goal> goalList;
  final Work focusWork;
  final Function onCheckChanged;

  WorkListView({this.goalList, this.onCheckChanged, this.focusWork});

  @override
  _WorkListViewState createState() => _WorkListViewState();
}

class _WorkListViewState extends State<WorkListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.goalList.length,
        itemBuilder: (context, index) {
          List<Goal> _children = [];
          widget.goalList
              .where((goal) => goal.isImportant)
              .forEach((goal) => _children.add(goal));
          widget.goalList
              .where((goal) => !goal.isImportant)
              .forEach((goal) => _children.add(goal));
          Goal goal = _children[index];
          return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: goal.isImportant ? '중요 취소' : '중요 표시',
                  icon: goal.isImportant ? Icons.star : Icons.star_border,
                  color: goal.isImportant
                      ? kPrimaryColor.withRed(200)
                      : kPrimaryColor,
                  foregroundColor: goal.isImportant ? null : Colors.white,
                  onTap: () {
                    setState(() {
                      goal.setImportance(goal.isImportant ? false : true);
                    });
                  },
                )
              ],
              actions: <Widget>[
                if (goal.difficulty < 5)
                  IconSlideAction(
                    caption: 'Level',
                    color: Colors.blue,
                    icon: Icons.arrow_upward,
                    onTap: () {
                      goal.levelUp();
                    },
                  ),
                if (goal.difficulty > 1)
                  IconSlideAction(
                    caption: 'Level',
                    color: Colors.redAccent,
                    icon: Icons.arrow_downward,
                    onTap: () {
                      goal.levelDown();
                    },
                  ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: widget.focusWork?.isWorkGoal(goal) ?? false
                      ? Colors.grey[300]
                      : null,
                ),
                child: GoalCheckBoxListTile(
                  popupMenuItemList: <PopupMenuItem<String>>[
                    if (goal.category.priority > 0)
                      const PopupMenuItem<String>(
                        child: Text('우선순위 올리기'),
                        value: 'priority up',
                      ),
                    if (goal.category.priority <
                        Hive.box(Boxes.categoryBox).length - 1)
                      const PopupMenuItem<String>(
                        child: Text('우선순위 내리기'),
                        value: 'priority down',
                      ),
                  ],
                  onResultSelected: (result) {
                    if (result == 'priority up') {
                      goal.category.priorityUp();
                    } else if (result == 'priority down') {
                      goal.category.priorityDown();
                    }
                  },
                  goal: goal,
                  onChanged: (checked) {
                    setState(() {
                      goal.check(checked);
                    });
                    widget.onCheckChanged(
                        widget.goalList.any((goal) => goal.checked));
                  },
                ),
              ));
        });
  }
}
