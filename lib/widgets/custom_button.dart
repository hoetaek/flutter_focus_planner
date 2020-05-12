import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color color;

  CustomButton({@required this.onPressed, this.title = '확인', this.color});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).accentColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white),
        ));
  }
}
