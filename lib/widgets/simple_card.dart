import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  final EdgeInsets cardPadding;
  final Color borderColor;
  SimpleCard(
      {@required this.children,
      this.color,
      @required this.cardPadding,
      @required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(color: borderColor)),
        padding: cardPadding,
        alignment: Alignment.center,
        child: Column(
          children: children,
        ));
  }
}
