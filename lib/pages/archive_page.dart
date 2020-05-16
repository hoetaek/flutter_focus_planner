import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/screens/important_category_card.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'category_add_page.dart';
import 'goal_add_page.dart';

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
  Box goalBox = Hive.box(Boxes.goalBox);

  sortCategoryList(Box categoryBox) {
    categoryReorderedList = categoryBox.values.cast<Category>().toList();
    categoryReorderedList.sort((a, b) => a.priority.compareTo(b.priority));
  }

//  void onCategoryActionDone() {
//    setState(() {
//      _categoryModeButtonState = ButtonState.add;
//    });
//  }

//  onWorklistActionDone() {
//    setState(() {
//      _workListModeButtonState = ButtonState.add;
//    });
//  }

//  void changeDropDownItem(Mode selectedMode) {
//    setState(() {
//      _currentMode = selectedMode;
//      Hive.box(Boxes.settingBox).put(Settings.archiveMode, selectedMode);
//    });
//  }

//  @override
//  void initState() {
//    _currentMode =
//        Hive.box(Boxes.settingBox).get(Settings.archiveMode) ?? Mode.Category;
//    super.initState();
//  }
  choiceAction(String choice) {
    if (choice == 'Category') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CategoryAddPage()));
    } else if (choice == 'Goal') {
      if (Hive.box(Boxes.categoryBox).isNotEmpty)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalAddPage(
                      category: null,
                      goalStatus: GoalStatus.onWork,
                    )));
      else {
        if (Platform.isAndroid) {
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text('알림'),
                content: Text('카테고리가 존재하지 않습니다.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('확인'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
        } else if (Platform.isIOS) {
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('알림'),
                  content: Text('카테고리가 존재하지 않습니다.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('확인'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                );
              });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('카테고리',
            style: TextFont.titleFont(fontWeight: FontWeight.bold)),

//        DropdownButton(
//          value: _currentMode,
//          items: Mode.values.map((Mode mode) {
//            return DropdownMenuItem<Mode>(value: mode, child: Text(mode.name));
//          }).toList(),
//          style: TextFont.titleFont(
//              fontSize: 18.0, letterSpacing: 1.2, color: Colors.black),
//          selectedItemBuilder: (context) {
//            return Mode.values.map((mode) {
//              return Container(
//                margin: EdgeInsets.only(top: 12.0),
//                child: Text(
//                  _currentMode.name,
//                  style: TextStyle(
//                      fontSize: 18.0,
//                      fontWeight: FontWeight.w800,
//                      letterSpacing: 1.2,
//                      color: Colors.white),
//                ),
//              );
//            }).toList();
//          },
//          onChanged: changeDropDownItem,
//          iconEnabledColor: Colors.white,
//          icon: null,
//        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.add),
            onSelected: choiceAction,
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "Category",
                  child: Text('카테고리 추가'),
                ),
                PopupMenuItem<String>(
                  value: "Goal",
                  child: Text('작업 추가'),
                ),
              ];
            },
          ),
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => GoalAddPage(
//                        category: category,
//                        goalStatus: GoalStatus.onWork,
//                      )));
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => CategoryAddPage()));
//            },
//          )
//          ActionsIconButton(
//            buttonState: _categoryModeButtonState,
//            modifyWidgets: <Widget>[
//              IconButton(
//                icon: Icon(Icons.delete),
//                onPressed: () {
//                  selectedCategories.forEach((Category category) {
//                    category.delete();
//                  });
//                  selectedCategories.clear();
//                  onCategoryActionDone();
//                  sortCategoryList(Hive.box(Boxes.categoryBox));
//                },
//              ),
//            ],
//          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        backgroundColor: kPrimaryColor,
//        onPressed: () {
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => CategoryAddPage()));
//        },
//      ),
//          : _currentMode == Mode.Daily
//              ? FloatingActionButton(
//                  child: Icon(Icons.add),
//                  backgroundColor: kPrimaryColor,
//                  onPressed: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => DailyGoalAddPage()));
//                  },
//                )
//              : null,
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box categoryBox, widget) {
          sortCategoryList(categoryBox);

          return ValueListenableBuilder(
              valueListenable: Hive.box(Boxes.goalBox).listenable(),
              builder: (context, Box goalBox, widget) {
                List<Work> workList =
                    Hive.box(Boxes.workBox).values.cast<Work>().toList();
                workList.sort((a, b) => a.compareId.compareTo(b.compareId));
//                List<Goal> goalList = [];
//                workList.forEach((work) {
//                  goalList.addAll(work.goals);
//                });

                return _buildCategoryView(categoryBox, workList);

//                switch (_currentMode) {
//                  case Mode.Category:
//                    return _buildCategoryView(categoryBox, workList);
//                  case Mode.WorkList:
//                    return WorkListView(
//                        focusWork: workList.isNotEmpty ? workList.first : null,
//                        goalList: goalList,
//                        onCheckChanged: (bool anyChecked) {
//                          setState(() {
//                            if (anyChecked == true)
//                              _workListModeButtonState = ButtonState.modify;
//                            else
//                              _workListModeButtonState = ButtonState.add;
//                          });
//                        });
//                  case Mode.Daily:
//                    return DailyGoalView();
//                  default:
//                    return null;
//                }
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
          SizedBox(
            height: 10.0,
          ),
          _buildImportantCategory(workList: workList),
          SizedBox(
            height: 10.0,
          ),
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

  _buildImportantCategory({@required List<Work> workList}) {
    Box settingBox = Hive.box(Boxes.settingBox);
    var name = settingBox.get('impCategoryName', defaultValue: '중요');
    Category category = Category(name: name);
    category.init(0, isSpecialCategory: true);
    workList.forEach((work) {
      work.goals.where((goal) => goal.isImportant).forEach((goal) {
        category.addGoalToImpCategory(goal);
      });
    });

    return category.goals.isNotEmpty
        ? ImportantCategoryCard(
            category: category,
            workList: workList,
          )
        : Container();
  }
}

//class WorkCard extends StatelessWidget {
//  final Work work;
//  WorkCard(this.work);
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.only(top: 20.0),
//      decoration: kCardDecoration.copyWith(
//        border: Border.all(
//          width: 1.0,
//          color: work.category.getColor(),
//        ),
//      ),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.all(10),
//            decoration: BoxDecoration(
//              color: work.category.getColor(),
//              borderRadius: BorderRadius.only(
//                  topLeft: kCardRadius, topRight: kCardRadius),
//            ),
//            child: Row(
//              children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    Text(
//                      '${work.category.priority + 1} ',
//                      style: TextStyle(
//                          fontFamily: GoogleFonts.doHyeon().fontFamily,
//                          fontWeight: FontWeight.bold,
//                          color: work.category.getTextColor(),
//                          fontSize: 20.0,
//                          letterSpacing: 1.2),
//                    ),
//                    Text(
//                      '${work.category.name}',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          color: work.category.getTextColor(),
//                          fontSize: 20.0,
//                          letterSpacing: 1.2),
//                    ),
//                    SizedBox(width: 10),
//                    if (work.category.priority <
//                        Hive.box(Boxes.categoryBox).length - 1)
//                      GestureDetector(
//                        child: Icon(
//                          Icons.keyboard_arrow_down,
//                          color: work.category.getTextColor(),
//                        ),
//                        onTap: () {
//                          work.category.priorityDown();
//                        },
//                      ),
//                    if (work.category.priority > 0)
//                      GestureDetector(
//                        child: Icon(
//                          Icons.keyboard_arrow_up,
//                          color: work.category.getTextColor(),
//                        ),
//                        onTap: () {
//                          work.category.priorityUp();
//                        },
//                      ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//          ListView.separated(
//              shrinkWrap: true,
//              separatorBuilder: (context, index) {
//                return Divider();
//              },
//              physics: ClampingScrollPhysics(),
//              itemCount: work.goals.length,
//              itemBuilder: (context, index) {
//                Goal goal = work.goals[index];
//                return Container();
//              })
//        ],
//      ),
//    );
//  }
//}
