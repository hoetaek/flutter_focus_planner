import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final IconData iconData;
  final TextEditingController textController;
  final String hintText;
  final String errorText;
  final EdgeInsets padding;
  final bool autoFocus;

  final Color borderColor;
  CustomTextField({
    this.title,
    @required this.iconData,
    @required this.textController,
    @required this.padding,
    this.borderColor = kPrimaryColor,
    this.hintText,
    this.errorText,
    this.autoFocus,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: textController,
        autofocus: autoFocus ?? false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          fillColor: Colors.white,
          filled: true,
          labelText: title,
          hintText: hintText,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 0.8, color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 0.8, color: borderColor),
          ),
          prefixIcon: Icon(
            iconData,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
