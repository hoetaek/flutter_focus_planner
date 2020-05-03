import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/pages/goal_edit_page.dart';
import 'package:focusplanner/pages/goal_split_page.dart';

class GoalCheckBoxListTile extends StatefulWidget {
  final Widget secondary;
  final bool value;
  final Function onChanged;
  final Goal goal;

  const GoalCheckBoxListTile(
      {Key key,
      this.secondary,
      @required this.value,
      @required this.onChanged,
      @required this.goal})
      : super(key: key);

  @override
  _GoalCheckBoxListTileState createState() => _GoalCheckBoxListTileState();
}

class _GoalCheckBoxListTileState extends State<GoalCheckBoxListTile> {
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
              child: Text('작업 수정'),
              value: 'modify',
            ),
            const PopupMenuItem<String>(
              child: Text('작업 나누기'),
              value: 'split',
            ),
          ],
        );
        if (result == 'modify')
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GoalEditPage(
                        goal: widget.goal,
                      )));
        else if (result == 'split')
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GoalSplitPage(
                        goal: widget.goal,
                      )));
      },
      child: CheckboxListTile(
        secondary: widget.secondary,
        title: Text(
          "${widget.goal.name} " +
              ((widget.goal.specGoalNum ?? 0) > 0
                  ? "(${widget.goal.specGoalNum}개)"
                  : ""),
        ),
        value: widget.value,
        onChanged: widget.onChanged,
      ),
    );
  }
}
