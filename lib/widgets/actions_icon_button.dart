import 'package:flutter/material.dart';

enum ButtonState {
  add,
  modify,
}

class ActionsIconButton extends StatelessWidget {
  final buttonState;
  final Widget addWidget;
  final List<Widget> modifyWidgets;

  ActionsIconButton({
    @required this.buttonState,
    this.addWidget,
    @required this.modifyWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return buttonState == ButtonState.add
        ? (addWidget ?? Container())
        : Row(
            children: modifyWidgets,
          );
  }
}
