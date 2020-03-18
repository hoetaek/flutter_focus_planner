import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/pages/archive_page.dart';
import 'package:focusplanner/pages/complete_page.dart';
import 'package:focusplanner/pages/current_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/category.dart';
import 'models/goal.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(GoalAdapter());
  await Hive.openBox(Boxes.categoryBox);
  await Hive.openBox(Boxes.goalBox);
  await Hive.openBox(Boxes.settingBox);
  Box categoryBox = Hive.box(Boxes.categoryBox);
//  Category category = Category(name: 'routine');
//  category.goals = HiveList(Hive.box(Boxes.goalBox));
//  if (categoryBox.isEmpty) categoryBox.add(category);

  runApp(MaterialApp(
    home: FocusPlanner(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.grey[50],
//        primaryColor: Colors.amber,
    ),
  ));
}

class FocusPlanner extends StatefulWidget {
  @override
  _FocusPlannerState createState() => _FocusPlannerState();
}

class _FocusPlannerState extends State<FocusPlanner> {
  int _currentPage = 0;
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _currentPage,
    );
    Hive.box(Boxes.categoryBox).values.forEach((category) {
      print(category);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            _currentPage = newPage;
          });
        },
        children: <Widget>[
          ArchivePage(),
          //todo FocusPage
          CurrentPage(),
          CompletePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          this._pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.archive), title: Text("목록")),
          //todo list
          BottomNavigationBarItem(icon: Icon(Icons.work), title: Text("작업")),
          //todo focus
          BottomNavigationBarItem(icon: Icon(Icons.check), title: Text("완료")),
          //todo done
        ],
      ),
    );
  }

  void dispose() {
    Hive.close();
    super.dispose();
  }
}
