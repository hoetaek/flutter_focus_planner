import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  CustomButton({@required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: onPressed,
        child: Text(
          '확인',
          style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).accentColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white),
        ));
  }
}
