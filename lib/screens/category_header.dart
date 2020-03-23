import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/category_edit_page.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/utils/work_list.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CategoryHeader extends StatelessWidget {
  final Category category;
  final ButtonState buttonState;
  final Function onActionDone;

  const CategoryHeader(
      {@required this.category, @required this.buttonState, this.onActionDone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryEditPage(category: category)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: category.goals
                    .where((goal) => Provider.of<WorkList>(context)
                        .workOrder
                        .first
                        .isWorkGoal(goal))
                    .isNotEmpty
                ? BorderRadius.only(topLeft: kCardRadius, topRight: kCardRadius)
                : BorderRadius.only(
                    topLeft: kCardRadius,
                    topRight: kCardRadius,
                    bottomLeft: kCardRadius,
                    bottomRight: kCardRadius),
            color: category.getColor()),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10.0),
            Text(
              '${category.name}',
              style: TextStyle(
                  color: category.getTextColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  letterSpacing: 1.2),
            ),
            Expanded(
              child: Container(),
            ),
            FittedBox(
              child: ActionsIconButton(
                buttonState: buttonState,
                addWidget: IconButton(
                  icon: Icon(Icons.add),
                  color: category.getTextColor(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoalAddPage(
                                  category: category,
                                  goalStatus: GoalStatus.onWork,
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
                      onActionDone();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
