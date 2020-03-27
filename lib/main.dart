import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/daily_goal.dart';
import 'package:focusplanner/models/work.dart';
import 'package:focusplanner/pages/archive_page.dart';
import 'package:focusplanner/pages/complete_page.dart';
import 'package:focusplanner/pages/focus_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/category.dart';
import 'models/goal.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(DailyGoalAdapter());
  Hive.registerAdapter(WorkAdapter());
  await Hive.openBox(Boxes.categoryBox);
  await Hive.openBox(Boxes.goalBox);
  await Hive.openBox(Boxes.settingBox);
  await Hive.openBox(Boxes.dailyGoalBox);
  await Hive.openBox(Boxes.workBox);
  Hive.box(Boxes.dailyGoalBox).values.cast<DailyGoal>().forEach((dailyGoal) {
    dailyGoal.makeGoal();
  });
  runApp(
    MaterialApp(
      home: FocusPlanner(),
      theme: ThemeData(
        primaryColor: kPrimaryColor.withGreen(150),
        scaffoldBackgroundColor: Colors.grey[50],
//        textTheme: GoogleFonts.nanumGothicTextTheme(),
//        primaryColor: Colors.amber,
      ),
    ),
  );
}

class FocusPlanner extends StatefulWidget {
  @override
  _FocusPlannerState createState() => _FocusPlannerState();
}

class _FocusPlannerState extends State<FocusPlanner> {
  int _currentPage = 1;
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
          FocusPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("목록")),
          BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_strong), title: Text("몰입")),
          BottomNavigationBarItem(icon: Icon(Icons.check), title: Text("완료")),
        ],
      ),
    );
  }

  void dispose() {
    Hive.close();
    super.dispose();
  }
}
