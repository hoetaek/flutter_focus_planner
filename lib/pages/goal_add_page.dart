import 'package:flutter/material.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';

class GoalAddPage extends StatefulWidget {
  @override
  _GoalAddPageState createState() => _GoalAddPageState();
}

class _GoalAddPageState extends State<GoalAddPage> {
  int _difficulty = 1;
  final TextEditingController _textController = TextEditingController();
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
            onPressed: () {
              print("${_textController.text} $_difficulty");
            },
          )
        ],
      ),
    );
  }
}
