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
          return box.get(Settings.currentCategory) != null
              ? Padding(
                  padding: EdgeInsets.all((20.0)),
                  child: CurrentListView(
                      //box의 id를 받아와서 그 id의 status가 current이면 보여 줌.
                      category:
                          categoryBox.get(box.get(Settings.currentCategory))),
                )
              : Container();
        });
  }
}
