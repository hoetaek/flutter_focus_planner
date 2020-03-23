import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/pages/category_add_page.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/screens/category_name_list.dart';
import 'package:focusplanner/utils/work_list.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  //todo 보기 모드 난이도별 / 카테고리별
  List<Category> categoryReorderedList;
  List<Category> selectedCategories = List();
  ButtonState _buttonState = ButtonState.add;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentMode;
  List _modes = ["카테고리", "작업순서"];

  sortCategoryList(Box categoryBox) {
    categoryReorderedList = categoryBox.values.cast<Category>().toList();
    categoryReorderedList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void actionDone() {
    setState(() {
      _buttonState = ButtonState.add;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String mode in _modes) {
      items.add(DropdownMenuItem(
        value: mode,
        child: Text(
          mode,
        ),
      ));
    }
    return items;
  }

  void changeDropDownItem(String selectedMode) {
    setState(() {
      _currentMode = selectedMode;
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentMode = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          value: _currentMode,
          items: _dropDownMenuItems,
          style: TextStyle(
              fontSize: 23.0, letterSpacing: 1.2, color: Colors.black),
          selectedItemBuilder: (context) {
            return _modes.map((mode) {
              return Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Text(
                  _currentMode,
                  style: TextStyle(
                      fontSize: 25.0,
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
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box categoryBox, widget) {
          sortCategoryList(categoryBox);
          Provider.of<WorkList>(context).generateWorkOrder();
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
                      child:
                          CategoryCard(category: categoryReorderedList[index]),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
