import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/pages/category_add_page.dart';
import 'package:focusplanner/screens/add_category_card.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reorderables/reorderables.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  //todo 보기 모드 난이도별 / 카테고리별

  List<Category> sortCategory(Box box) {
    List<Category> result;
    for (int i = 0; i < box.length; i++) {
      for (int j = 0; j < box.length; j++) {
        if (i == box.getAt(j).priority) {
          result[i] = box.getAt(j);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ArchiveAppBar();
    return ValueListenableBuilder(
      valueListenable: Hive.box(Boxes.categoryBox).listenable(),
      builder: (context, Box box, widget) {
        return Padding(
          padding: EdgeInsets.all(2.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ArchiveAppBar(),
                Container(
                  height: 30,
                  child: categoryNameList(box: box),
                ),
                SizedBox(height: 10),
                ColumnBuilder(
                  itemCount: box.length + 1,
                  itemBuilder: (context, index) {
                    //todo 루틴의 경우 매일 초기화되는 'goal'로 만들 것
                    if (index != box.length) {
                      List<Category> list = sortCategory(box);
                      return CategoryCard(category: list[index]);
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ArchiveAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Archive Page"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryAddPage()));
          },
        )
      ],
    );
  }
}

class categoryNameList extends StatefulWidget {
  final Box box;
  categoryNameList({this.box});

  @override
  _categoryNameListState createState() => _categoryNameListState();
}

class _categoryNameListState extends State<categoryNameList> {
  List<Widget> _rows;
  void initState() {
    super.initState();
    if (widget.box.length == 0)
      _rows =
          List<Widget>.generate(1, (int index) => Text('', key: UniqueKey()));
    else {
      _rows = List<Widget>.generate(
          widget.box.length,
          (int index) => Text(
                ' ${widget.box.getAt(index).name} ',
                key: UniqueKey(),
              ));
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Widget row = _rows.removeAt(oldIndex);

      if (newIndex > _rows.length) {
        widget.box.getAt(_rows.length).priority = oldIndex;
        widget.box.getAt(oldIndex).priority = _rows.length;
        _rows.insert(_rows.length, row);
      } else {
        widget.box.getAt(newIndex).priority = oldIndex;
        widget.box.getAt(oldIndex).priority = newIndex;
        _rows.insert(newIndex, row);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: _rows,
      onReorder: _onReorder,
      scrollDirection: Axis.horizontal,
    );
  }
}
