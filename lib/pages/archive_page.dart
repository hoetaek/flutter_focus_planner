import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/pages/category_add_page.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/screens/category_name_list.dart';
import 'package:focusplanner/screens/daily_goal_view.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'daily_goal_add_page.dart';

enum Mode {
  Category,
  WorkList,
  Daily,
}

extension ModeExtension on Mode {
  String get name {
    switch (this) {
      case Mode.Category:
        return '카테고리';
      case Mode.WorkList:
        return '작업순서';
      case Mode.Daily:
        return '반복작업';
      default:
        return null;
    }
  }
}

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<Category> categoryReorderedList;
  List<Category> selectedCategories = List();
  ButtonState _buttonState = ButtonState.add;
  Mode _currentMode;

  sortCategoryList(Box categoryBox) {
    categoryReorderedList = categoryBox.values.cast<Category>().toList();
    categoryReorderedList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void actionDone() {
    setState(() {
      _buttonState = ButtonState.add;
    });
  }

  void changeDropDownItem(Mode selectedMode) {
    setState(() {
      _currentMode = selectedMode;
    });
  }

  @override
  void initState() {
    _currentMode = Mode.Category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: DropdownButton(
          value: _currentMode,
          items: Mode.values.map((Mode mode) {
            return DropdownMenuItem<Mode>(value: mode, child: Text(mode.name));
          }).toList(),
          style: TextStyle(
              fontSize: 18.0, letterSpacing: 1.2, color: Colors.black),
          selectedItemBuilder: (context) {
            return Mode.values.map((mode) {
              return Container(
                margin: EdgeInsets.only(top: 12.0),
                child: Text(
                  _currentMode.name,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white),
                ),
              );
            }).toList();
          },
          onChanged: changeDropDownItem,
          iconEnabledColor: Colors.white,
          icon: null,
        ),
        actions: <Widget>[
          if (_currentMode == Mode.Category)
            ActionsIconButton(
              buttonState: _buttonState,
              addWidget: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryAddPage()));
                  }),
              modifyWidgets: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    selectedCategories.forEach((Category category) {
                      category.delete();
                    });
                    selectedCategories.clear();
                    actionDone();
                  },
                ),
              ],
            ),
          if (_currentMode == Mode.Daily)
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DailyGoalAddPage()));
                }),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box categoryBox, widget) {
          sortCategoryList(categoryBox);

          return ValueListenableBuilder(
              valueListenable: Hive.box(Boxes.workBox).listenable(),
              builder: (context, Box workBox, widget) {
                List<Work> workList = workBox.values.cast<Work>().toList();
                workList.sort((a, b) => a.compareId.compareTo(b.compareId));
                switch (_currentMode) {
                  case Mode.Category:
                    return _buildCategoryView(categoryBox, workList);
                  case Mode.WorkList:
                    return Container();
                  case Mode.Daily:
                    return DailyGoalView();
                  default:
                    return null;
                }
              });
        },
      ),
    );
  }

  SingleChildScrollView _buildCategoryView(
      Box categoryBox, List<Work> workList) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CategoryNameList(
              categoryList: categoryReorderedList,
              selectedCategories: selectedCategories,
              onSelectChanged: () {
                setState(() {
                  _buttonState = selectedCategories.isNotEmpty
                      ? ButtonState.modify
                      : ButtonState.add;
                });
              }),
          SizedBox(height: 10),
          ColumnBuilder(
            itemCount: categoryBox.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: CategoryCard(
                    category: categoryReorderedList[index], workList: workList),
              );
            },
          ),
        ],
      ),
    );
  }
}
