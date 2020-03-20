import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/models/category.dart';
import 'package:focusplanner/pages/category_add_page.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:focusplanner/widgets/column_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  //todo 보기 모드 난이도별 / 카테고리별
  List<Category> categoryReorderedList;

  sortCategory(Box categoryBox) {
    categoryReorderedList = categoryBox.values.cast<Category>().toList();
    categoryReorderedList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Boxes.categoryBox).listenable(),
        builder: (context, Box categoryBox, widget) {
          print('reorder');
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 30,
                  child: CategoryNameList(categoryBox: categoryBox),
                ),
                SizedBox(height: 10),
                ColumnBuilder(
                  itemCount: categoryBox.length + 1,
                  itemBuilder: (context, index) {
                    //todo 루틴의 경우 매일 초기화되는 'goal'로 만들 것
                    if (index != categoryBox.length) {
                      sortCategory(categoryBox);
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CategoryCard(
                            category: categoryReorderedList[index]),
                      );
                    } else {
                      return Container();
                    }
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

class CategoryNameList extends StatefulWidget {
  final Box categoryBox;
  CategoryNameList({this.categoryBox});

  @override
  _CategoryNameListState createState() => _CategoryNameListState();
}

class _CategoryNameListState extends State<CategoryNameList> {
  List<Category> categoryList;

  setCategoryPriority() {
    int index = 0;
    categoryList.forEach((category) {
      category.priority = index;
      category.save();
      index++;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    Future.delayed(Duration(milliseconds: 20), () {
      setState(() {
        final Category category = categoryList.removeAt(oldIndex);
        categoryList.insert(newIndex, category);
      });
      setCategoryPriority();
      categoryList = widget.categoryBox.values.cast<Category>().toList();
      categoryList.sort((a, b) => a.priority.compareTo(b.priority));
    });
  }

  void initState() {
    super.initState();
    categoryList = widget.categoryBox.values.cast<Category>().toList();
    categoryList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: categoryList
          .map((category) => CategoryName(
                category: category,
                key: UniqueKey(),
              ))
          .toList(),
      onReorder: _onReorder,
      scrollDirection: Axis.horizontal,
    );
  }
}

class CategoryName extends StatelessWidget {
  final Category category;
  const CategoryName({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.tealAccent),
      child: Text(category.name),
    );
  }
}
