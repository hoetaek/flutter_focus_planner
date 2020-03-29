import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';

class FocusDifficultyContent extends StatefulWidget {
  final List<Goal> focusDifficultyGoals;
  final Function onChecked;

  const FocusDifficultyContent(
      {Key key, this.focusDifficultyGoals, this.onChecked})
      : super(key: key);

  @override
  _FocusDifficultyContentState createState() => _FocusDifficultyContentState();
}

class _FocusDifficultyContentState extends State<FocusDifficultyContent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.focusDifficultyGoals.length,
        itemBuilder: (context, index) {
          Goal goal = widget.focusDifficultyGoals[index];
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.15,
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
                              goal: goal,
                            )));
              },
              child: CheckboxListTile(
                title: Text(goal.name),
                value: goal.checked,
                onChanged: (value) {
                  setState(() {
                    goal.check(value);
                  });
                  widget.onChecked();
                },
              ),
            ),
          );
        });
  }
}
