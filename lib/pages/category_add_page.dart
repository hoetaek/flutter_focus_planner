import 'package:flutter/material.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';

class CategoryAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category 추가'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            iconData: Icons.add,
            title: "카테고리",
          ),
          CustomButton(
            onPressed: () {
              // add Category
            },
          ),
        ],
      ),
    );
  }
}