import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import '../constants.dart';
import 'category_content.dart';
import 'category_header.dart';

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
          color: widget.category.getColor(),
        ),
      ),
      child: Column(
        children: <Widget>[
          CategoryHeader(
              category: widget.category,
              buttonState: _buttonState,
              onActionDone: () {
                setState(() {
                  _buttonState = ButtonState.add;
                });
              }),
          CategoryContent(
              category: widget.category,
              onChecked: () {
                //todo archive만 표시하도록 하기
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
