import 'package:flutter/material.dart';

enum ButtonState {
  add,
  modify,
}

class ActionsIconButton extends StatelessWidget {
  final buttonState;
  final Widget addPage;

  ActionsIconButton({@required this.buttonState, @required this.addPage});

  @override
  Widget build(BuildContext context) {
    return buttonState == ButtonState.add
        ? IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => addPage));
            },
          )
        : Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.work),
                onPressed: () {},
              ),
            ],
          );
  }
}
