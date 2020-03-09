import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class ShowCurrent extends StatefulWidget {
  final Category category;

  ShowCurrent({this.category});
  @override
  _ShowCurrentState createState() => _ShowCurrentState();
}

class _ShowCurrentState extends State<ShowCurrent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(),
          CategoryElement(
            category: widget.category,
          )
        ],
      ),
    );
  }
}

class CategoryElement extends StatefulWidget {
  final Category category;

  CategoryElement({this.category});
  @override
  _CategoryElementState createState() => _CategoryElementState();
}

class _CategoryElementState extends State<CategoryElement> {
  @override
  Widget build(BuildContext context) {
    List<Goal> currentGoals = widget.category.goals
        .where((Goal goal) => goal.status == GoalStatus.current)
        .toList();
    return widget.category.goals != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: currentGoals.length,
            itemBuilder: (context, index) {
              Goal goal = currentGoals[index];
              return CheckboxListTile(
                title: Text('${goal.name}'),
                value: goal.checked,
                onChanged: (change) {},
              );
            })
        : Container();
  }
}
