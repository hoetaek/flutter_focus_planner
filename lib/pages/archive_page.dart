import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
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

part 'archive_page.g.dart';

@HiveType(typeId: 4)
enum Mode {
  @HiveField(0)
  Category,
  @HiveField(1)
  WorkList,
  @HiveField(2)
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
      Hive.box(Boxes.settingBox).put(Settings.archiveMode, selectedMode);
    });
  }

  @override
  void initState() {
    _currentMode =
        Hive.box(Boxes.settingBox).get(Settings.archiveMode) ?? Mode.Category;
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
          style: TextFont.titleFont(
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
                    return WorkListView(workList: workList);
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

class WorkListView extends StatelessWidget {
  final List<Work> workList;
  WorkListView({this.workList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: workList.length,
        itemBuilder: (context, index) {
          return WorkCard(workList[index]);
        });
  }
}

class WorkCard extends StatelessWidget {
  final Work work;
  WorkCard(this.work);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      decoration: kCardDecoration.copyWith(
        border: Border.all(
          width: 1.0,
          color: work.category.getColor(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: work.category.getColor(),
              borderRadius: BorderRadius.only(
                  topLeft: kCardRadius, topRight: kCardRadius),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  '${work.category.name} - Lv.${work.difficulty}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: work.category.getTextColor(),
                      fontSize: 20.0,
                      letterSpacing: 1.2),
                ),
              ],
            ),
          ),
          ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return Divider();
              },
              physics: ClampingScrollPhysics(),
              itemCount: work.goals.length,
              itemBuilder: (context, index) {
                Goal goal = work.goals[index];
                return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.15,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Level',
                        color: Colors.blue,
                        icon: Icons.arrow_upward,
                        onTap: () {
                          goal.levelUp();
                        },
                      ),
                      IconSlideAction(
                        caption: 'Level',
                        color: Colors.redAccent,
                        icon: Icons.arrow_downward,
                        onTap: () {
                          goal.levelDown();
                        },
                      ),
                    ],
                    child: ListTile(title: Text(goal.name)));
              })
        ],
      ),
    );
  }
}
