import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:hive/hive.dart';

import 'custom_button.dart';
import 'custom_text_field.dart';

class CombineGoalsBottomSheet extends StatefulWidget {
  final Category category;
  final int difficulty;
  final List<Goal> goalCheckedList;

  const CombineGoalsBottomSheet(
      {Key key,
      this.category,
      @required this.difficulty,
      @required this.goalCheckedList})
      : super(key: key);

  @override
  _CombineGoalsBottomSheetState createState() =>
      _CombineGoalsBottomSheetState();
}

class _CombineGoalsBottomSheetState extends State<CombineGoalsBottomSheet> {
  int _difficulty;
  bool _validate = true;
  TextEditingController _textController;
  List<String> goalNameList = [];
  Category _currentCategory;
  final Box categoryBox = Hive.box(Boxes.categoryBox);

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _validate = true;
      });
    });
    _difficulty = widget.difficulty;
    widget.goalCheckedList.forEach((goal) {
      goalNameList.add(goal.name);
      if ((goal.specGoalNum ?? 0) > 0) goalNameList.addAll(goal.specificGoals);
    });
    _currentCategory = categoryBox.isNotEmpty
        ? (widget.category == null ? categoryBox.getAt(0) : widget.category)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                '작업 합치기',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
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
              Container(
                padding: MediaQuery.of(context).viewInsets / 3,
                child: CustomTextField(
                  padding: EdgeInsets.all(20),
                  title: "작업",
                  textController: _textController,
                  iconData: Icons.add,
                  errorText: _validate ? null : "칸이 비어있습니다.",
                ),
              ),
              DifficultySelector(
                currentDifficulty: _difficulty,
                onDifficultyChanged: (selectedDifficulty) {
                  setState(() {
                    _difficulty = selectedDifficulty;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).primaryColor,
                        )),
                    child: Wrap(
                      children: goalNameList
                          .map((chipGoalName) => Chip(
                                label: Text(chipGoalName),
                                onDeleted: () {
                                  setState(() {
                                    goalNameList.removeWhere(
                                        (goalName) => goalName == chipGoalName);
                                  });
                                  widget.goalCheckedList.removeWhere(
                                      (goal) => goal.name == chipGoalName);
                                  if (goalNameList.isEmpty)
                                    Navigator.pop(context);
                                },
                              ))
                          .toList(),
                    )),
              ),
              CustomButton(
                onPressed: () {
                  if (_textController.text.isEmpty) {
                    setState(() {
                      _validate = false;
                    });
                    return;
                  }
                  Goal.combineGoals(
                    _textController.text,
                    _difficulty,
                    GoalStatus.onWork,
                    _currentCategory,
                    goalNameList,
                  );
                  widget.goalCheckedList.forEach((goal) {
                    goal.delete();
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
