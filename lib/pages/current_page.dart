import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/screens/current_list_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Box categoryBox = Hive.box(Boxes.categoryBox);
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.settingBox).listenable(),
        builder: (context, Box box, widget) {
          //todo 카테고리 이름을 보여주기
          return box.get('currentCategory') != null
              ? Padding(
                  padding: EdgeInsets.all((20.0)),
                  child: CurrentListView(
                      category: categoryBox.get(box.get('currentCategory'))),
                )
              : Container();
        });
  }
}
