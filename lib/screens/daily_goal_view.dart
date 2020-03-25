import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/daily_goal.dart';
import 'package:focusplanner/pages/daily_goal_edit_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class DailyGoalView extends StatelessWidget {
  final Box dailyGoalBox = Hive.box(Boxes.dailyGoalBox);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.dailyGoalBox).listenable(),
        builder: (context, Box box, child) {
          return ListView.builder(
            itemCount: dailyGoalBox.length,
            itemBuilder: (context, index) {
              return DailyGoalCard(dailyGoalBox.getAt(index));
            },
          );
        });
  }
}

class DailyGoalCard extends StatelessWidget {
  final DailyGoal dailyGoal;

  DailyGoalCard(this.dailyGoal);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      decoration: kCardDecoration.copyWith(
        border: Border.all(
          width: 1.0,
          color: dailyGoal.category.getColor(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: dailyGoal.category.getColor(),
              borderRadius: BorderRadius.only(
                  topLeft: kCardRadius, topRight: kCardRadius),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Text(
                      dailyGoal.name,
                      style: TextStyle(
                          color: dailyGoal.category.getTextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: 1.2),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: dailyGoal.category.getTextColor(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DailyGoalEditPage(dailyGoal)));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: dailyGoal.category.getTextColor(),
                      onPressed: () {
                        //todo message alert to check if really want to delete
                        dailyGoal.delete();
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    DailyGoalChip(dailyGoal.category.name),
                    SizedBox(width: 5.0),
                    DailyGoalChip("Lv.${dailyGoal.difficulty}"),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _AnimatedLiquidLinearProgressIndicator(dailyGoal.countComplete()),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Text("${dailyGoal.countComplete()}/66"),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class _AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
  final int completeNum;
  const _AnimatedLiquidLinearProgressIndicator(this.completeNum, {Key key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidLinearProgressIndicatorState();
}

class _AnimatedLiquidLinearProgressIndicatorState
    extends State<_AnimatedLiquidLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
      upperBound: widget.completeNum / 66,
    );

    _animationController.addListener(() => setState(() {}));
    if (widget.completeNum > 0) _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    return Center(
      child: Container(
        width: double.infinity,
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: LiquidLinearProgressIndicator(
          value: _animationController.value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          borderRadius: 12.0,
          center: Text(
            "${percentage.toStringAsFixed(0)}%",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class DailyGoalChip extends StatelessWidget {
  final String title;
  DailyGoalChip(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: kCardDecoration.copyWith(
        borderRadius: BorderRadius.circular(25.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}
