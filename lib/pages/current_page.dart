import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/screens/current_list_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box box, widget) {
          return box.isEmpty || (box.getAt(0) as Category).goals.isEmpty
              ? Container()
              : CurrentListView();
        });
  }
}
