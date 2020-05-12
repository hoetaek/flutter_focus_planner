import 'package:flutter/material.dart';

enum ButtonState {
  add,
  modify,
}

class ActionsIconButton extends StatelessWidget {
  final buttonState;
  final Widget addWidget;
  final Row addWidgetList;
  final List<Widget> modifyWidgets;

  ActionsIconButton(
      {@required this.buttonState,
      this.addWidget,
      @required this.modifyWidgets,
      this.addWidgetList});

  @override
  Widget build(BuildContext context) {
    return buttonState == ButtonState.add
        ? (addWidget ?? addWidgetList ?? Container())
        : Row(
            children: modifyWidgets,
          );
  }
}
