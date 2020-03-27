import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';

import '../constants.dart';

class CategoryContent extends StatefulWidget {
  final Category category;
  final Function onChecked;
  final Work focusWork;

  const CategoryContent(
      {@required this.category, @required this.onChecked, this.focusWork});

  @override
  _CategoryContentState createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  @override
  Widget build(BuildContext context) {
    List<Goal> onWorkGoals = widget.category.goals.where((Goal goal) {
      return goal.status == GoalStatus.onWork;
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
                                  goalStatus: GoalStatus.onWork,
                                  goal: goal,
                                )));
                  },
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
                    child: CheckboxListTile(
                      secondary: Icon(
                        Goal.getIconData(goal.difficulty),
                        color: goal.getColor(),
                      ),
                      title: Text('${goal.name}'),
                      value: goal.checked,
                      onChanged: (checkChanged) {
                        setState(() {
                          goal.checked = checkChanged;
                          goal.save();
                        });
                        widget.onChecked();
                      },
                    ),
                  ),
                ),
              );
            },
          )
        : Container();
  }
}
