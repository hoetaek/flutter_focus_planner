import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Column(
        children: <Widget>[
          CategoryHeader(
              category: widget.category,
              buttonState: _buttonState,
              actionDone: () {
                setState(() {
                  _buttonState = ButtonState.add;
                });
              }),
          CategoryContent(
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

class CategoryHeader extends StatelessWidget {
  final Category category;
  final ButtonState buttonState;
  final Function actionDone;

  const CategoryHeader(
      {@required this.category, @required this.buttonState, this.actionDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: kCardRadius, topRight: kCardRadius),
          color: Theme.of(context).primaryColor),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0),
          FittedBox(child: Text('${category.name}')),
          Expanded(
            child: Container(),
          ),
          FittedBox(
            child: ActionsIconButton(
              buttonState: buttonState,
              addWidget: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoalAddPage(
                                category: category,
                                goalStatus: GoalStatus.archive,
                              )));
                },
              ),
              modifyWidgets: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    List<Goal> goalCheckedList = category.goals.where((goal) {
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
                  icon: Icon(Icons.work),
                  onPressed: () {
                    List<Goal> goalCheckedList = category.goals.where((goal) {
                      return goal.checked;
                    }).toList();
                    goalCheckedList.forEach((Goal goal) {
                      goal.status = GoalStatus.current;
                      goal.checked = false;
                      goal.save();
                    });
                    actionDone();
                    Box settingBox = Hive.box(Boxes.settingBox);
                    settingBox.put(Boxes.currentCategory, category.key);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryContent extends StatefulWidget {
  final Category category;
  final Function onChecked;

  const CategoryContent({@required this.category, @required this.onChecked});

  @override
  _CategoryContentState createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  //todo 난이도 표시하는 방법
  //todo 난이도 순서대로 표시하기
  @override
  Widget build(BuildContext context) {
    List<Goal> archivedGoals = widget.category.goals
        .where((Goal goal) => goal.status == GoalStatus.archive)
        .toList();
    return widget.category.goals != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: archivedGoals.length,
            itemBuilder: (context, index) {
              Goal goal = archivedGoals[index];
              //todo 길게 눌렀을 때 정보 수정하기
              return CheckboxListTile(
                title: Text('${goal.name}'),
                value: goal.checked,
                onChanged: (checkChanged) {
                  setState(() {
                    goal.checked = checkChanged;
                    goal.save();
                  });
                  widget.onChecked();
                },
              );
            },
          )
        : Container();
  }
}
