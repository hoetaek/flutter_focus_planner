import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/models/goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/screens/daily_goal_view.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:focusplanner/widgets/goal_checkbox_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'category_add_page.dart';
import 'daily_goal_add_page.dart';
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
  ButtonState _categoryModeButtonState = ButtonState.add;
  ButtonState _workListModeButtonState = ButtonState.add;
  Box goalBox = Hive.box(Boxes.goalBox);
  Mode _currentMode;

  sortCategoryList(Box categoryBox) {
    categoryReorderedList = categoryBox.values.cast<Category>().toList();
    categoryReorderedList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void onCategoryActionDone() {
    setState(() {
      _categoryModeButtonState = ButtonState.add;
    });
  }

  onWorklistActionDone() {
    setState(() {
      _workListModeButtonState = ButtonState.add;
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
              buttonState: _categoryModeButtonState,
              modifyWidgets: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    selectedCategories.forEach((Category category) {
                      category.delete();
                    });
                    selectedCategories.clear();
                    onCategoryActionDone();
                    sortCategoryList(Hive.box(Boxes.categoryBox));
                  },
                ),
              ],
            ),
          if (_currentMode == Mode.WorkList)
            ActionsIconButton(
              buttonState: _workListModeButtonState,
              addWidget: IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoalAddPage(
                                category: null,
                                goalStatus: GoalStatus.onWork,
                              )));
                },
              ),
              modifyWidgets: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
//                    color: category.getTextColor(),
                  ),
                  onPressed: () {
                    List<Goal> goalCheckedList =
                        goalBox.values.cast<Goal>().where((goal) {
                      return goal.status == GoalStatus.onWork && goal.checked;
                    }).toList();
                    goalCheckedList.forEach((Goal goal) {
                      goal.delete();
                    });
                    onWorklistActionDone();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.done,
//                    color: category.getTextColor(),
                  ),
                  onPressed: () {
                    List<Goal> goalCheckedList =
                        goalBox.values.cast<Goal>().where((goal) {
                      return goal.status == GoalStatus.onWork && goal.checked;
                    }).toList();
                    goalCheckedList.forEach((Goal goal) {
                      goal.complete();
                    });
                    onWorklistActionDone();
                  },
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: _currentMode == Mode.Category
          ? FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoryAddPage()));
              },
            )
          : _currentMode == Mode.Daily
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyGoalAddPage()));
                  },
                )
              : null,
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box categoryBox, widget) {
          sortCategoryList(categoryBox);

          return ValueListenableBuilder(
              valueListenable: Hive.box(Boxes.workBox).listenable(),
              builder: (context, Box workBox, widget) {
                List<Work> workList = workBox.values.cast<Work>().toList();
                workList.sort((a, b) => a.compareId.compareTo(b.compareId));
                List<Goal> goalList = [];
                workList.forEach((work) {
                  goalList.addAll(work.goals);
                });

                switch (_currentMode) {
                  case Mode.Category:
                    return _buildCategoryView(categoryBox, workList);
                  case Mode.WorkList:
                    return WorkListView(
                        focusWork: workList.isNotEmpty ? workList.first : null,
                        goalList: goalList,
                        onCheckChanged: (bool anyChecked) {
                          setState(() {
                            if (anyChecked == true)
                              _workListModeButtonState = ButtonState.modify;
                            else
                              _workListModeButtonState = ButtonState.add;
                          });
                        });
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
}

class WorkListView extends StatefulWidget {
  final List<Goal> goalList;
  final Work focusWork;
  final Function onCheckChanged;

  WorkListView({this.goalList, this.onCheckChanged, this.focusWork});

  @override
  _WorkListViewState createState() => _WorkListViewState();
}

class _WorkListViewState extends State<WorkListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.goalList.length,
        itemBuilder: (context, index) {
          Goal goal = widget.goalList[index];
          return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              actions: <Widget>[
                if (goal.difficulty < 5)
                  IconSlideAction(
                    caption: 'Level',
                    color: Colors.blue,
                    icon: Icons.arrow_upward,
                    onTap: () {
                      goal.levelUp();
                    },
                  ),
                if (goal.difficulty > 1)
                  IconSlideAction(
                    caption: 'Level',
                    color: Colors.redAccent,
                    icon: Icons.arrow_downward,
                    onTap: () {
                      goal.levelDown();
                    },
                  ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: widget.focusWork?.isWorkGoal(goal) ?? false
                      ? Colors.grey[300]
                      : null,
                ),
                child: GoalCheckBoxListTile(
                  popupMenuItemList: <PopupMenuItem<String>>[
                    if (goal.category.priority > 0)
                      const PopupMenuItem<String>(
                        child: Text('우선순위 올리기'),
                        value: 'priority up',
                      ),
                    if (goal.category.priority <
                        Hive.box(Boxes.categoryBox).length - 1)
                      const PopupMenuItem<String>(
                        child: Text('우선순위 내리기'),
                        value: 'priority down',
                      ),
                  ],
                  onResultSelected: (result) {
                    if (result == 'priority up') {
                      goal.category.priorityUp();
                    } else if (result == 'priority down') {
                      goal.category.priorityDown();
                    }
                  },
                  goal: goal,
                  onChanged: (checked) {
                    setState(() {
                      goal.check(checked);
                    });
                    widget.onCheckChanged(
                        widget.goalList.any((goal) => goal.checked));
                  },
                ),
              ));
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
                Row(
                  children: <Widget>[
                    Text(
                      '${work.category.priority + 1} ',
                      style: TextStyle(
                          fontFamily: GoogleFonts.doHyeon().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: work.category.getTextColor(),
                          fontSize: 20.0,
                          letterSpacing: 1.2),
                    ),
                    Text(
                      '${work.category.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: work.category.getTextColor(),
                          fontSize: 20.0,
                          letterSpacing: 1.2),
                    ),
                    SizedBox(width: 10),
                    if (work.category.priority <
                        Hive.box(Boxes.categoryBox).length - 1)
                      GestureDetector(
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: work.category.getTextColor(),
                        ),
                        onTap: () {
                          work.category.priorityDown();
                        },
                      ),
                    if (work.category.priority > 0)
                      GestureDetector(
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: work.category.getTextColor(),
                        ),
                        onTap: () {
                          work.category.priorityUp();
                        },
                      ),
                  ],
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
                return Container();
              })
        ],
      ),
    );
  }
}
