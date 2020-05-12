import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';
import 'package:focusplanner/widgets/multiple_text_field_column.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

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
  Category _currentCategory;
  final Box categoryBox = Hive.box(Boxes.categoryBox);
  int _difficulty;
  bool _validate = true;
  int specGoalNum = 0;
  List<String> goalNameList = [];
  GlobalKey<MultipleTextFieldColumnState> multipleTextFieldColumnKey =
      GlobalKey<MultipleTextFieldColumnState>();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _currentCategory = categoryBox.isNotEmpty
        ? (widget.category == null ? categoryBox.getAt(0) : widget.category)
        : null;
    _difficulty = widget.difficulty;
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
        title: Text(
          '작업 추가',
          style: TextFont.titleFont(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              title: "작업",
              textController: _textController,
              iconData: Icons.add,
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
                          '$specGoalNum',
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
                initFieldNum: specGoalNum,
                onTextChanged: (textList) {
                  goalNameList = textList;
                },
              ),
            ),
            CustomButton(
              onPressed: () {
                if (_textController.text.isEmpty) {
                  setState(() {
                    _validate = false;
                  });
                  return;
                }
                print(goalNameList);
                //todo verify empty space
                Goal goal = Goal(
                  name: _textController.text,
                  difficulty: _difficulty,
                  status: widget.goalStatus,
                );
                goal.init(categoryToBeAdded: _currentCategory);
                goal.setSpecificGoals(goalNameList);
                _currentCategory.addGoal(goal);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void countDown() {
    setState(() {
      if (specGoalNum > 0) {
        specGoalNum--;
        multipleTextFieldColumnKey.currentState.removeTextField();
      }
    });
  }

  void countUp() {
    setState(() {
      specGoalNum++;
      multipleTextFieldColumnKey.currentState.addTextField();
    });
  }
}
