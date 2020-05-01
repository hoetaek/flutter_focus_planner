import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';
import 'package:focusplanner/widgets/multiple_text_field_column.dart';

class GoalEditPage extends StatefulWidget {
  final Goal goal;

  const GoalEditPage({Key key, this.goal}) : super(key: key);

  @override
  _GoalEditPageState createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  int _difficulty;
  TextEditingController _textController;
  int goalNum;
  List<String> goalNameList = [];
  GlobalKey<MultipleTextFieldColumnState> multipleTextFieldColumnKey =
      GlobalKey<MultipleTextFieldColumnState>();

  @override
  void initState() {
    _textController = TextEditingController(text: widget.goal.name);
    _difficulty = widget.goal.difficulty;
    goalNum = widget.goal.specificGoals?.length ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('작업 수정'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            padding: EdgeInsets.all(20),
            title: "작업",
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
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).primaryColor,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      '세부작업 개수: ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        onPressed: countDown,
                      ),
                      Text(
                        '$goalNum',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_up),
                        onPressed: countUp,
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: MultipleTextFieldColumn(
              key: multipleTextFieldColumnKey,
              initFieldNum: 0,
              initFieldStringList: widget.goal.specificGoals,
              onTextChanged: (textList) {
                goalNameList = textList;
              },
            ),
          ),
          CustomButton(
            onPressed: () {
              if (_textController.text.isNotEmpty)
                widget.goal.name = _textController.text;
              widget.goal.setSpecificGoals(goalNameList);
              widget.goal.setDifficulty(_difficulty);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void countDown() {
    setState(() {
      if (goalNum > 0) {
        goalNum--;
        multipleTextFieldColumnKey.currentState.removeTextField();
      }
    });
  }

  void countUp() {
    setState(() {
      goalNum++;
      multipleTextFieldColumnKey.currentState.addTextField();
    });
  }
}
