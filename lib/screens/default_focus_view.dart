import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';

class DefaultFocusView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '빈 페이지',
          style: TextFont.titleFont(),
        ),
      ),
      body: Center(child: Text('작업을 추가해주세요.')),
    );
  }
}
