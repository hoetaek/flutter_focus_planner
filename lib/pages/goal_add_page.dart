import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';

class GoalAddPage extends StatefulWidget {
  final Category category;
  final String goalStatus;
  final int difficulty;

  const GoalAddPage(
      {Key key,
      @required this.category,
      @required this.goalStatus,
      this.difficulty: 1})
      : super(key: key);
  @override
  _GoalAddPageState createState() => _GoalAddPageState();
}

class _GoalAddPageState extends State<GoalAddPage> {
  int _difficulty;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _difficulty = widget.difficulty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일 추가'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            title: "할 일",
            textController: _textController,
            iconData: Icons.add,
          ),
          DifficultySelector(
            currentDifficulty: _difficulty,
            onDifficultyChanged: (selectedDifficulty) {
              setState(() {
                _difficulty = selectedDifficulty;
              });
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          CustomButton(
            onPressed: () async {
              Goal goal = Goal(
                  name: _textController.text,
                  difficulty: _difficulty,
                  status: widget.goalStatus);
              goal.init(categoryToBeAdded: widget.category);
              widget.category.addGoal(goal);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
