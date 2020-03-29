import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';

class GoalEditPage extends StatefulWidget {
  final Goal goal;

  const GoalEditPage({Key key, this.goal}) : super(key: key);

  @override
  _GoalEditPageState createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  int _difficulty;
  TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.goal.name);
    _difficulty = widget.goal.difficulty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일 수정'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            title: "할 일",
            textController: _textController,
            iconData: Icons.add,
            hintText: widget.goal.name,
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
            onPressed: () {
              if (_textController.text.isNotEmpty)
                widget.goal.name = _textController.text;
              widget.goal.difficulty = _difficulty;
              widget.goal.save();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
