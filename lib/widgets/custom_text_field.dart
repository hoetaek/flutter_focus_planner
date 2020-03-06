import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final IconData iconData;
  final TextEditingController textController;
  CustomTextField(
      {@required this.title,
      @required this.iconData,
      @required this.textController});
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(width: 0.8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                BorderSide(width: 0.8, color: Theme.of(context).primaryColor),
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
