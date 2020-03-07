import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

import '../constants.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  ButtonState _buttonState = ButtonState.add;

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
          ),
          CategoryContent(
              category: widget.category,
              onChecked: (checked) {
                setState(() {
                  if (checked)
                    _buttonState = ButtonState.modify;
                  else
                    _buttonState = ButtonState.add;
                });
                print(checked);
              }),
        ],
      ),
    );
  }
}

class CategoryHeader extends StatelessWidget {
  final Category category;
  final ButtonState buttonState;

  const CategoryHeader({@required this.category, @required this.buttonState});

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
          Text('${category.name}'),
          Expanded(
            child: Container(),
          ),
          ActionsIconButton(
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
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.work),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryContent extends StatefulWidget {
  final Category category;
  final ValueChanged<bool> onChecked;

  const CategoryContent({@required this.category, @required this.onChecked});

  @override
  _CategoryContentState createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  int countChecked = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.category.goals.length,
      itemBuilder: (context, index) {
        Goal goal = widget.category.goals[index];
        return CheckboxListTile(
          title: Text('${goal.name}'),
          value: goal.checked,
          onChanged: (checkChanged) {
            setState(() {
              goal.checked = checkChanged;
              goal.save();
            });
            if (checkChanged)
              countChecked += 1;
            else
              countChecked -= 1;
            if (countChecked > 0)
              widget.onChecked(true);
            else
              widget.onChecked(false);
          },
        );
      },
    );
  }
}
