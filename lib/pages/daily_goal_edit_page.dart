import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/daily_goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';
import 'package:hive/hive.dart';

class DailyGoalEditPage extends StatefulWidget {
  final DailyGoal dailyGoal;

  DailyGoalEditPage(this.dailyGoal);

  @override
  _DailyGoalEditPageState createState() => _DailyGoalEditPageState();
}

class _DailyGoalEditPageState extends State<DailyGoalEditPage> {
  int _difficulty = 1;
  TextEditingController _textController;
  final Box categoryBox = Hive.box(Boxes.categoryBox);
  Category _currentCategory;

  @override
  void initState() {
    _currentCategory = widget.dailyGoal.category;
    _difficulty = widget.dailyGoal.difficulty;
    _textController = TextEditingController(text: widget.dailyGoal.name);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('반복작업 수정'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  width: 1.0,
                  color: Theme.of(context).primaryColor.withGreen(150),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '카테고리 선택',
                  style: TextStyle(color: kPrimaryColor.withGreen(150)),
                ),
                DropdownButton(
                  underline: Container(),
                  value: _currentCategory,
                  isExpanded: true,
                  items: categoryBox.values.cast<Category>().map(
                    (category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    },
                  ).toList(),
                  onChanged: (Category category) {
                    setState(() {
                      _currentCategory = category;
                    });
                  },
                ),
              ],
            ),
          ),
          CustomTextField(
            title: "반복작업",
            textController: _textController,
            iconData: Icons.add,
            borderColor: kPrimaryColor.withGreen(150),
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
                widget.dailyGoal.name = _textController.text;
              widget.dailyGoal.difficulty = _difficulty;
              widget.dailyGoal.category = _currentCategory;
              widget.dailyGoal.save();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
