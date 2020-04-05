import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:popup_menu/popup_menu.dart';

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
    PopupMenu.context = context;
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
                child: Text('test1'),
                value: 'test1',
              ),
              const PopupMenuItem<String>(
                child: Text('test2'),
                value: 'test2',
              ),
            ]);
        print(result);
//        menu.show(widgetKey: tileKey);
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => GoalSplitPage(
//                      goal: widget.goal,
//                    )));
      },
      child: CheckboxListTile(
        secondary: widget.secondary,
        title: Text(
          widget.goal.name,
        ),
        value: widget.value,
        onChanged: widget.onChanged,
      ),
    );
  }
}
