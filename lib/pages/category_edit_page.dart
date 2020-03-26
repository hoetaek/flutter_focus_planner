import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/widgets/color_picker.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';

import '../constants.dart';

class CategoryEditPage extends StatefulWidget {
  final Category category;

  CategoryEditPage({Key key, this.category}) : super(key: key);

  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  TextEditingController _textController;
  int _currentColorIndex;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.category.name);
    _currentColorIndex = widget.category.colorIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category 수정'),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            borderColor: kColors[_currentColorIndex],
            textController: _textController,
            iconData: Icons.add,
            hintText: widget.category.name,
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
              if (_textController.text.isNotEmpty)
                widget.category.name = _textController.text;
              widget.category.colorIndex = _currentColorIndex;
              widget.category.save();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
