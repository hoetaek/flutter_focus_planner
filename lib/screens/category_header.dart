import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/category_edit_page.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:focusplanner/widgets/combine_goals_bottomsheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class CategoryHeader extends StatefulWidget {
  final Category category;
  final ButtonState buttonState;
  final Function onActionDone;

  const CategoryHeader(
      {@required this.category, @required this.buttonState, this.onActionDone});

  @override
  _CategoryHeaderState createState() => _CategoryHeaderState();
}

class _CategoryHeaderState extends State<CategoryHeader> {
  final tileKey = GlobalKey();
  var _tapPosition;

  RelativeRect tileMenuPosition(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
        _tapPosition & Size(40, 40), Offset.zero & overlay.size);
    return position;
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: tileKey,
      onTapDown: _storePosition,
      onLongPress: () async {
        final position = tileMenuPosition(tileKey.currentContext);
        var result = await showMenu(
          context: context,
          position: position,
          items: <PopupMenuItem>[
            const PopupMenuItem<String>(
              child: Text('카테고리 수정'),
              value: 'modify',
            ),
            const PopupMenuItem<String>(
              child: Text('작업 추가'),
              value: 'add',
            ),
          ],
        );
        if (result == 'modify')
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryEditPage(category: widget.category)));
        else if (result == 'add')
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GoalAddPage(
                        category: widget.category,
                        goalStatus: GoalStatus.onWork,
                      )));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: widget.category.goals
                    .where((goal) =>
                        goal.status == GoalStatus.onWork && !goal.isImportant)
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
                  onPressed: () async {
                    List<Goal> goalCheckedList =
                        widget.category.goals.where((goal) {
                      return goal.checked;
                    }).toList();
                    await alertReallyDelete(
                        context: context,
                        name: '작업',
                        onAction: () {
                          goalCheckedList.forEach((Goal goal) {
                            goal.delete();
                          });
                        });
                    // uncheck not deleted and checked goals
                    widget.category.goals.where((goal) {
                      return goal.checked;
                    }).forEach((Goal goal) {
                      goal.check(false);
                    });
                    widget.onActionDone();
                  },
                ),
                if (widget.category.goals.where((goal) {
                      //checked가 된 골만 return 한다.
                      return goal.checked;
                    }).length >
                    1)
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.layerGroup,
                      color: widget.category.getTextColor(),
                    ),
                    onPressed: () async {
                      List<Goal> goalCheckedList =
                          widget.category.goals.where((goal) {
                        //checked가 된 골만 return 한다.
                        return goal.checked;
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
                          category: widget.category,
                          difficulty: initialDifficulty,
                          goalCheckedList: goalCheckedList,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      );
                      widget.category.goals
                          .where((goal) => goal.checked)
                          .forEach((goal) {
                        goal.check(false);
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
      ),
    );
  }
}
