import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:focusplanner/widgets/goal_checkbox_list_tile.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class ImportantCategoryCard extends StatefulWidget {
  final Category category;
  final List<Work> workList;

  ImportantCategoryCard({this.category, this.workList});

  @override
  _ImportantCategoryCardState createState() => _ImportantCategoryCardState();
}

class _ImportantCategoryCardState extends State<ImportantCategoryCard> {
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
    return Container(
      decoration: kCardDecoration.copyWith(
        border: Border.all(
          width: 1.0,
          color: widget.category.getColor(),
        ),
      ),
      child: Column(
        children: <Widget>[
          ImportantCategoryHeader(
              category: widget.category,
              buttonState: _buttonState,
              onActionDone: () {
                setState(() {
                  _buttonState = ButtonState.add;
                });
              }),
          ImportantCardContent(
              focusWork:
                  widget.workList.isNotEmpty ? widget.workList.first : null,
              category: widget.category,
              onChecked: () {
                setState(() {
                  if (goalIsChecked())
                    _buttonState = ButtonState.modify;
                  else
                    _buttonState = ButtonState.add;
                });
              }),
        ],
      ),
    );
  }
}

class ImportantCategoryHeader extends StatefulWidget {
  final Category category;
  final ButtonState buttonState;
  final Function onActionDone;

  const ImportantCategoryHeader(
      {Key key, this.category, this.buttonState, this.onActionDone})
      : super(key: key);
  @override
  _ImportantCategoryHeaderState createState() =>
      _ImportantCategoryHeaderState();
}

class _ImportantCategoryHeaderState extends State<ImportantCategoryHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: widget.category.goals
                  .where((goal) =>
                      goal.status == GoalStatus.onWork && goal.isImportant)
                  .isNotEmpty
              ? BorderRadius.only(topLeft: kCardRadius, topRight: kCardRadius)
              : BorderRadius.only(
                  topLeft: kCardRadius,
                  topRight: kCardRadius,
                  bottomLeft: kCardRadius,
                  bottomRight: kCardRadius),
          color: widget.category.getColor()),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0),
          Row(
            children: <Widget>[
              Text(
                '${widget.category.name}',
                style: TextStyle(
                    color: widget.category.getTextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    letterSpacing: 1.2),
              ),
              SizedBox(width: 10),
              if (widget.category.priority != null)
                if (widget.category.priority <
                    Hive.box(Boxes.categoryBox).length - 1)
                  GestureDetector(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.category.getTextColor(),
                    ),
                    onTap: () {
                      widget.category.priorityDown();
                    },
                  ),
              if (widget.category.priority != null)
                if (widget.category.priority > 0)
                  GestureDetector(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: widget.category.getTextColor(),
                    ),
                    onTap: () {
                      widget.category.priorityUp();
                    },
                  ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          ActionsIconButton(
            buttonState: widget.buttonState,
            addWidget: Container(
              height: 48.0,
            ),
            modifyWidgets: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: widget.category.getTextColor(),
                ),
                onPressed: () {
                  List<Goal> goalCheckedList =
                      widget.category.goals.where((goal) {
                    return goal.checked;
                  }).toList();
                  goalCheckedList.forEach((Goal goal) {
                    goal.delete();
                  });
                  widget.onActionDone();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.done,
                  color: widget.category.getTextColor(),
                ),
                onPressed: () {
                  List<Goal> goalCheckedList =
                      widget.category.goals.where((goal) {
                    //checked가 된 골만 return 한다.
                    return goal.checked;
                  }).toList();
                  goalCheckedList.forEach((Goal goal) {
                    goal.complete();
                  });
                  widget.onActionDone();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImportantCardContent extends StatefulWidget {
  final Category category;
  final Function onChecked;
  final Work focusWork;

  const ImportantCardContent(
      {Key key, this.category, this.onChecked, this.focusWork})
      : super(key: key);
  @override
  _ImportantCardContentState createState() => _ImportantCardContentState();
}

class _ImportantCardContentState extends State<ImportantCardContent> {
  @override
  Widget build(BuildContext context) {
    List<Goal> onWorkGoals = widget.category.goals.where((Goal goal) {
      return goal.status == GoalStatus.onWork && goal.isImportant;
    }).toList();

    onWorkGoals.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    return widget.category.goals != null
        ? ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: onWorkGoals.length,
            itemBuilder: (context, index) {
              Goal goal = onWorkGoals[index];

              return Slidable(
                actionExtentRatio: 0.15,
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '중요 취소',
                    icon: Icons.star,
                    color: kPrimaryColor.withRed(200),
                    foregroundColor: Colors.white,
                    onTap: () {
                      setState(() {
                        goal.setImportance(false);
                      });
                    },
                  ),
                ],
                actions: <Widget>[
                  if (goal.difficulty < 5)
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
                  if (goal.difficulty > 1)
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
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.focusWork?.isWorkGoal(goal) ?? false
                        ? Colors.grey[300]
                        : null,
                    borderRadius: index + 1 == onWorkGoals.length
                        ? BorderRadius.only(
                            bottomLeft: kCardRadius,
                            bottomRight: kCardRadius,
                          )
                        : null,
                  ),
                  child: GoalCheckBoxListTile(
                    goal: goal,
                    onChanged: (checkChanged) {
                      setState(() {
                        goal.check(checkChanged);
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
