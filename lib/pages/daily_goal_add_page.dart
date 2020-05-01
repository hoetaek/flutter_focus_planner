import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/daily_goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';
import 'package:hive/hive.dart';

class DailyGoalAddPage extends StatefulWidget {
  @override
  _DailyGoalAddPageState createState() => _DailyGoalAddPageState();
}

class _DailyGoalAddPageState extends State<DailyGoalAddPage> {
  int _difficulty = 1;
  final TextEditingController _textController = TextEditingController();
  final Box categoryBox = Hive.box(Boxes.categoryBox);
  Category _currentCategory;
  bool _validate = true;

  @override
  void initState() {
    _currentCategory = categoryBox.isNotEmpty ? categoryBox.getAt(0) : null;
    _textController.addListener(() {
      setState(() {
        _validate = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('반복작업 추가'),
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
                  style: TextStyle(color: kPrimaryColor),
                ),
                DropdownButton(
                  underline: Container(),
                  hint: _currentCategory == null
                      ? Text("카테고리를 먼저 만들어주세요.")
                      : null,
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
            padding: EdgeInsets.all(20),
            title: "반복작업",
            textController: _textController,
            iconData: Icons.add,
            borderColor: kPrimaryColor,
            errorText: _validate ? null : "칸이 비어있습니다.",
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
              if (_textController.text.isEmpty) {
                setState(() {
                  _validate = false;
                });
                return;
              }
              DailyGoal dailyGoal = DailyGoal(
                name: _textController.text,
                difficulty: _difficulty,
              );
              dailyGoal.addCategory(_currentCategory);
              Hive.box(Boxes.dailyGoalBox).add(dailyGoal);
              dailyGoal.makeGoal();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
