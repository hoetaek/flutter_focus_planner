import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class MultipleTextFieldColumn extends StatefulWidget {
  final Function onTextChanged;
  final int initFieldNum;
  final List<String> initFieldStringList;

  const MultipleTextFieldColumn(
      {Key key,
      @required this.onTextChanged,
      @required this.initFieldNum,
      this.initFieldStringList})
      : super(key: key);
  @override
  MultipleTextFieldColumnState createState() => MultipleTextFieldColumnState();
}

class MultipleTextFieldColumnState extends State<MultipleTextFieldColumn> {
  List<CustomTextField> children = [];
  List<TextEditingController> _controllerToDispose = [];

  @override
  void initState() {
    for (var i = 0; i < widget.initFieldNum; i++) addTextField();
    widget.initFieldStringList?.forEach((String initFieldString) {
      addTextField(initString: initFieldString);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }

  addTextField({String initString}) {
    TextEditingController _controller = TextEditingController(text: initString);
    _controller.addListener(() {
      widget.onTextChanged(
          children.map((textField) => textField.textController.text).toList());
    });
    CustomTextField customTextField = CustomTextField(
      padding: EdgeInsets.symmetric(vertical: 10),
      iconData: Icons.add,
      textController: _controller,
    );
    children.add(customTextField);
    widget.onTextChanged(
        children.map((textField) => textField.textController.text).toList());
  }

  removeTextField() {
    CustomTextField customTextField = children.last;
    children.removeLast();
    _controllerToDispose.add(customTextField.textController);
    widget.onTextChanged(
        children.map((textField) => textField.textController.text).toList());
  }

  @override
  void dispose() {
    _controllerToDispose.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
