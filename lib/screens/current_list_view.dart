import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';

import '../constants.dart';

class CurrentListView extends StatefulWidget {
  final Category category;

  CurrentListView({this.category});
  @override
  _CurrentListViewState createState() => _CurrentListViewState();
}

class _CurrentListViewState extends State<CurrentListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(),
          //todo 난이도 순서대로 표시하기
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
