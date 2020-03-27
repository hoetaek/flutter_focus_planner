import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final IconData iconData;
  final TextEditingController textController;
  final String hintText;
  final String errorText;

  final Color borderColor;
  CustomTextField(
      {this.title,
      @required this.iconData,
      @required this.textController,
      this.borderColor = kPrimaryColor,
      this.hintText,
      this.errorText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        controller: textController,
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
