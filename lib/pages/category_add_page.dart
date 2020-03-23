import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/widgets/color_picker.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';
import 'package:hive/hive.dart';

class CategoryAddPage extends StatefulWidget {
  @override
  _CategoryAddPageState createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final TextEditingController _textController = TextEditingController();
  int _currentColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category 추가'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            borderColor: kColors[_currentColorIndex],
            textController: _textController,
            iconData: Icons.add,
            title: "카테고리",
          ),
          ColorPicker(
            colorIndex: _currentColorIndex,
            onChange: (index) {
              setState(() {
                _currentColorIndex = index;
              });
            },
          ),
          CustomButton(
            onPressed: () {
              Category category = Category(name: _textController.text);
              category.goals = HiveList(Hive.box(Boxes.goalBox));
              category.priority = Hive.box(Boxes.categoryBox).length;
              category.colorIndex = _currentColorIndex;
              Hive.box(Boxes.categoryBox).add(category);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
