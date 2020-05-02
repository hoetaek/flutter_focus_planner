import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/screens/complete_calendar.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:focusplanner/widgets/date_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum CompleteMode {
  List,
  Calendar,
}

class CompletePage extends StatefulWidget {
  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  CompleteMode _completeMode = CompleteMode.List;
  Map<DateTime, List<Goal>> _events = Map<DateTime, List<Goal>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('완료', style: TextFont.titleFont()),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box(Boxes.goalBox).listenable(),
          builder: (context, Box goalBox, widget) {
            if (_completeMode == CompleteMode.List) {
              return _buildDateGoalsColumn(goalBox);
            } else
              return Container(
                child: CompleteCalendar(
                  events: _events,
                ),
              );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: _completeMode == CompleteMode.List
            ? Icon(Icons.calendar_today)
            : Icon(Icons.check),
        onPressed: () {
          setState(() {
            _completeMode = _completeMode == CompleteMode.List
                ? CompleteMode.Calendar
                : CompleteMode.List;
          });
        },
      ),
    );
  }

  Widget _buildDateGoalsColumn(Box goalBox) {
    List<Widget> _children = [];
    //todo 완료 취소할 수 있도록

    List<DateTime> uniqueGoalDateList;
    uniqueGoalDateList = goalBox.values
        .cast<Goal>()
        .where((goal) => goal.status == GoalStatus.complete)
        .map((goal) => goal.getDay())
        .toSet()
        .toList();
    uniqueGoalDateList.sort((b, a) => a.compareTo(b));
    uniqueGoalDateList.forEach((date) {
      List<Goal> goalsOnDate = goalBox.values
          .cast<Goal>()
          .where((goal) =>
              goal.status == GoalStatus.complete && goal.isOnDate(date))
          .toList();

      _events.putIfAbsent(date, () => goalsOnDate);

      if (goalsOnDate.length > 0) _children.add(DateListTile(date: date));
      _children.add(ColumnBuilder(
        itemCount: goalsOnDate.length,
        itemBuilder: (context, idx) {
          Goal goal = goalsOnDate[idx];

          // the tile widgets
          return ContextMenuCheckboxTile(goal: goal);
        },
      ));
    });
    return SingleChildScrollView(
      child: Column(
        children: _children,
      ),
    );
  }
}

class ContextMenuCheckboxTile extends StatefulWidget {
  final Goal goal;

  const ContextMenuCheckboxTile({Key key, this.goal}) : super(key: key);

  @override
  _ContextMenuCheckboxTileState createState() =>
      _ContextMenuCheckboxTileState();
}

class _ContextMenuCheckboxTileState extends State<ContextMenuCheckboxTile> {
  final tileKey = GlobalKey();
  var _tapPosition;

  RelativeRect tileMenuPosition(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
        _tapPosition & Size(40, 40), Offset.zero & overlay.size);
    return position;
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: tileKey,
      onTapDown: _storePosition,
      onLongPress: () async {
        final position = tileMenuPosition(tileKey.currentContext);
        var result = await showMenu(
            context: context,
            position: position,
            items: <PopupMenuItem>[
              const PopupMenuItem<String>(
                child: Text('작업 취소'),
                value: 'uncheck',
              ),
            ]);
        if (result == 'uncheck') widget.goal.uncheck();
      },
      child: CheckboxListTile(
        title: Text(widget.goal.name),
        value: true,
        onChanged: null,
      ),
    );
  }
}
