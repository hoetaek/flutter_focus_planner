import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/category_edit_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:hive/hive.dart';

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
                    .where((goal) => goal.status == GoalStatus.onWork)
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
            Row(
              children: <Widget>[
                Text(
                  '${category.name}',
                  style: TextStyle(
                      color: category.getTextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 1.2),
                ),
                SizedBox(width: 10),
                if (category.priority < Hive.box(Boxes.categoryBox).length - 1)
                  GestureDetector(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: category.getTextColor(),
                    ),
                    onTap: () {
                      category.priorityDown();
                    },
                  ),
                if (category.priority > 0)
                  GestureDetector(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: category.getTextColor(),
                    ),
                    onTap: () {
                      category.priorityUp();
                    },
                  ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            ActionsIconButton(
              buttonState: buttonState,
              addWidget: Container(
                height: 40.0,
              ),
              modifyWidgets: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: category.getTextColor(),
                  ),
                  onPressed: () {
                    List<Goal> goalCheckedList = category.goals.where((goal) {
                      return goal.checked;
                    }).toList();
                    goalCheckedList.forEach((Goal goal) {
                      goal.delete();
                    });
                    onActionDone();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.done,
                    color: category.getTextColor(),
                  ),
                  onPressed: () {
                    List<Goal> goalCheckedList = category.goals.where((goal) {
                      //checked가 된 골만 return 한다.
                      return goal.checked;
                    }).toList();
                    goalCheckedList.forEach((Goal goal) {
                      goal.complete();
                    });
                    onActionDone();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
