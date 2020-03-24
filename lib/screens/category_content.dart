import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';
import 'package:focusplanner/utils/work_list.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CategoryContent extends StatefulWidget {
  final Category category;
  final Function onChecked;

  const CategoryContent({@required this.category, @required this.onChecked});

  @override
  _CategoryContentState createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  Work focusWork;

  @override
  Widget build(BuildContext context) {
    focusWork = Provider.of<WorkList>(context).workOrder.isEmpty
        ? null
        : Provider.of<WorkList>(context).workOrder.first;

    List<Goal> archivedGoals = widget.category.goals.where((Goal goal) {
      return focusWork?.isWorkGoal(goal) ?? goal.status != GoalStatus.complete;
    }).toList();

    archivedGoals.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    return widget.category.goals != null
        ? ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: archivedGoals.length,
            itemBuilder: (context, index) {
              Goal goal = archivedGoals[index];
              //todo 길게 눌렀을 때 정보 수정하기
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
                          Provider.of<WorkList>(context, listen: false)
                              .generateWorkOrder();
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
                          Provider.of<WorkList>(context, listen: false)
                              .generateWorkOrder();
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
                  child: CheckboxListTile(
                    secondary: Icon(
                      //todo consider if swiping up(page view) is a better idea
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
              );
            },
          )
        : Container();
  }
}
