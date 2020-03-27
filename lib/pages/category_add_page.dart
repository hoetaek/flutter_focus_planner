import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/widgets/color_picker.dart';
import 'package:focusplanner/widgets/custom_button.dart';
import 'package:focusplanner/widgets/custom_text_field.dart';

class CategoryAddPage extends StatefulWidget {
  @override
  _CategoryAddPageState createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final TextEditingController _textController = TextEditingController();
  int _currentColorIndex = 0;
  bool _validate = true;

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        _validate = true;
      });
    });
    super.initState();
  }

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
            errorText: _validate ? null : "칸이 비어있습니다.",
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
              if (_textController.text.isEmpty) {
                setState(() {
                  _validate = false;
                });
                return;
              }
              Category category = Category(name: _textController.text);
              category.init(_currentColorIndex);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
