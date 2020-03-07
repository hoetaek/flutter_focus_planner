import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/pages/category_add_page.dart';

class AddCategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kCardDecoration.copyWith(
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => CategoryAddPage())),
      ),
    );
  }
}
