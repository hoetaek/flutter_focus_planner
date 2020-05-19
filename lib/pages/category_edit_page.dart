import 'dart:io';

import 'package:flutter/cupertino.dart';
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
        title: Text(
          'Category 수정',
          style: TextFont.titleFont(),
        ),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            padding: EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomButton(
                title: "삭제",
                color: Colors.red[800],
                onPressed: () async {
                  await alertReallyDelete(
                    context: context,
                    name: widget.category.name,
                    onAction: () {
                      widget.category.delete();
                      Navigator.pop(context);
                    },
                  );
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
              )
            ],
          ),
        ],
      ),
    );
  }
}

Future alertReallyDelete({
  @required BuildContext context,
  @required String name,
  @required Function onAction,
  Function onCancel,
}) {
  if (Platform.isAndroid)
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('$name 삭제 확인'),
            content: Text('$name을/를 정말 삭제하시겠습니까?'),
            actions: <Widget>[
              FlatButton(
                child: Text('취소'),
                onPressed: () {
                  onCancel?.call();
                  Navigator.pop(dialogContext);
                },
              ),
              FlatButton(
                child: Text('확인'),
                onPressed: () {
                  onAction();
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        });
  else
    return showCupertinoDialog(
        context: context,
        builder: (dialogContext) {
          return CupertinoAlertDialog(
            title: Text('$name 삭제 확인'),
            content: Text('$name을/를 정말 삭제하시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('취소'),
                onPressed: () {
                  onCancel?.call();
                  Navigator.pop(dialogContext);
                },
              ),
              CupertinoDialogAction(
                child: Text('확인'),
                onPressed: () {
                  onAction();
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        });
}
