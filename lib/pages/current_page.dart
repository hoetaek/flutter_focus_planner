import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/screens/add_category_card.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/screens/show_current.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Box categoryBox = Hive.box(Boxes.categoryBox);
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.settingBox).listenable(),
        builder: (context, Box box, widget) {
          return box.get('currentCategory') != null
              ? Padding(
                  padding: EdgeInsets.all((20.0)),
                  child: ShowCurrent(
                      category: categoryBox.get(box.get('currentCategory'))),
                )
              : Container();
        });
  }
}
