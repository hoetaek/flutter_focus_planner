import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/screens/add_category_card.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Boxes.categoryBox).listenable(),
      builder: (context, Box box, widget) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: box.length + 1,
            itemBuilder: (context, index) {
              if (index != box.length) {
                return CategoryCard(
                  category: box.getAt(index),
                );
              } else {
                return AddCategoryCard();
              }
            },
          ),
        );
      },
    );
  }
}
