import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/difficulty_selector.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/multiple_text_field_column.dart';

class GoalSplitPage extends StatefulWidget {
  final Goal goal;

  const GoalSplitPage({Key key, this.goal}) : super(key: key);

  @override
  _GoalSplitPageState createState() => _GoalSplitPageState();
}

class _GoalSplitPageState extends State<GoalSplitPage> {
  int goalNum;
  List<String> goalNameList = [];
  GlobalKey<MultipleTextFieldColumnState> multipleTextFieldColumnKey =
      GlobalKey<MultipleTextFieldColumnState>();

  @override
  void initState() {
    goalNum = widget.goal.specificGoals?.length ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '작업 나누기',
          style: TextFont.titleFont(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          GoalInfoCard(
            goal: widget.goal,
            goalNum: goalNum,
            countDown: () {
              setState(() {
                if (goalNum > 0) {
                  goalNum--;
                  multipleTextFieldColumnKey.currentState.removeTextField();
                }
              });
            },
            countUp: () {
              setState(() {
                goalNum++;
                multipleTextFieldColumnKey.currentState.addTextField();
              });
            },
          ),
          MultipleTextFieldColumn(
            key: multipleTextFieldColumnKey,
            initFieldNum: widget.goal.specificGoals == null ? 1 : 0,
            initFieldStringList: widget.goal.specificGoals,
            onTextChanged: (textList) {
              goalNameList = textList;
            },
          ),
          CustomButton(
            onPressed: () {
              goalNameList.forEach((name) {
                Goal goal = Goal(
                    name: name,
                    difficulty: widget.goal.difficulty,
                    status: GoalStatus.onWork);
                goal.init(categoryToBeAdded: widget.goal.category);
                widget.goal.category.addGoal(goal);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class GoalInfoCard extends StatelessWidget {
  final Goal goal;
  final int goalNum;
  final Function countDown;
  final Function countUp;

  const GoalInfoCard(
      {Key key, this.goal, this.goalNum, this.countDown, this.countUp})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10),
      decoration: kCardDecoration.copyWith(
          border: Border.all(
            width: 1.0,
            color: goal.category.getColor(),
          ),
          color: Colors.grey[200]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: goal.category.getColor(),
              borderRadius: BorderRadius.only(
                  topLeft: kCardRadius, topRight: kCardRadius),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(width: 10),
                Row(
                  children: <Widget>[
                    Text(
                      goal.name,
                      style: TextStyle(
                          color: goal.category.getTextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Table(
                  children: <TableRow>[
                    TableRow(children: [
                      Text(
                        '카테고리: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '${goal.category.name}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Text(
                        '레벨: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '${goal.difficulty} (' +
                              DifficultySelector
                                  .diffSentences[goal.difficulty - 1] +
                              ')',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Text(
                        '개수: ',
                        style: TextStyle(fontSize: 16),
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
                        ],
                      ),
                    ]),
                  ],
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
