import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';
import 'package:hive/hive.dart';

class CategoryAddPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category 추가'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            textController: _textController,
            iconData: Icons.add,
            title: "카테고리",
          ),
          CustomButton(
            onPressed: () {
              Category category = Category(name: _textController.text);
              category.goals = HiveList(Hive.box(Boxes.goalBox));
              category.priority = Hive.box(Boxes.goalBox).length;
              Hive.box(Boxes.categoryBox).add(category);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
